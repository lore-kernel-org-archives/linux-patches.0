Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060631;
	b=A5I5VpaMDNOG1q7GlIGyCKCjzOuwXKPmI7Aw8r0vIWTipY4uWtDEwwS+Ah9FCq3PR0Na
	 sllNsXmNSe6oDms6oLkFg1sfK75vRDFIPUlk7EESeTtYVULSEu85vKtl10RGxRH1ZW95d
	 sjaUH9Qgl7EB5oQRhmqWdRkUmKCCwP/pOqaag2oNkye6kUCqbWkMjqnctApSLr/AZ5WyY
	 A/ZTdy0L+d8eEnyJsZXWwjfEdL843uJagJY0IdPgwzkUPXzl+W8IDSEIkXG2JUN42xM61
	 Zd+J9otKufr4CHO7nddxupS9A65C2BdgT6G/wjCwDtH+i1GjFp07u6NTOyAOgIDhTMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R6RLnbQPe/0FVpAkvLqpvJSZZHUBVoguulTiIFoUqgE=;
	b=yo5Na8l2/hdEsq0P4Vxm/Y6o6uEQdP+kAY0otck7tFF+yE09EVKFHTIsiejtwZLDC2Yq
	 +xY8MeS4kx91zAfAAkwT27diwUUAjOUL5JsMwk3fdNMVsdLpYQRVXyYo3J0NiMoX5GnTs
	 0g0lWZ4zqxq9vJzHIthMfg05/n06Kiyfl2dRpUY8EQCc7D8iLl1BAthTEU9EU5Qq1XmeE
	 U/07RLwuI/pIBFzuyaoMVk3Dz0xZRh2YwtpOFsFPL3iRHHwKuyyiZfXvbMyEyV6WS7Lt7
	 X1oyqGbCLOsNZPE/U2+GBL5zTFolvSyuxanWnuYwO0XGq0l/uhzO+VD1hnJUlLjAjZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNrkbn5z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A37D606A320;
	Thu, 19 Nov 2026 03:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNrkbn5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F71C1F000C4;
	Thu, 19 Nov 2026 03:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060631;
	bh=R6RLnbQPe/0FVpAkvLqpvJSZZHUBVoguulTiIFoUqgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNrkbn5zlVGVaLODswVhizJLRYDVDxYTq4ke4jycXYh0/2wqfAbMhCxBQzDMLTp3i
	 HrmhHB5JjJaJG2uUWvrm/y7bg5tiQ9iRZ8f2xzSZfOODG+9EmziOJCSojswP3dSMrT
	 x0XcjEZI2SbQGN/OizRDMOeXomeqCQAmKuEwCtMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1268/1848] md/raid5: setup_conf: Fix null-ptr-def in error handling path
Date: Wed, 18 Nov 2026 15:55:06 +0100
Message-ID: <20261118150012.752869766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit eba5f518701b1c7f2d883504f89c41611bd2de46 ]

For raid5 setup_conf, if an error(eg. bioset_init fails) happens before
'conf->mddev = mddev', following error handling path could trigger a
null-ptr-def problem:

 free_conf
  log_exit
   raid5_has_ppl
    test_bit(MD_HAS_PPL, &conf->mddev->flags) // conf->mddev is NULL !

Fix it by initializing conf->mddev in advance.

Fixes: 3418d036c81d ("raid5-ppl: Partial Parity Log write logging implementation")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://patch.msgid.link/20260915081731.122933-1-chengzhihao1@huawei.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f1fc249fcfd8b..9f403ac87de01 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7213,6 +7213,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	conf->mddev = mddev;
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7285,7 +7286,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (ret)
 		goto abort;
-	conf->mddev = mddev;
 
 	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
 		goto abort;
-- 
2.53.0



