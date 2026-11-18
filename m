Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039837;
	b=SIUGuapSNJO7UDLiznjQTeVFGV8m7CBq59sev3n8xzWnqxVab4gt0H6jVsuRuEPCX0WM
	 7yJHOxBNXqb18XbmZJHU+hfDvqCoqT3FXYepAG26S0gdLAwHxmXry1PyVl53wyXQTLKlm
	 HVi9oBiGUO788RM+oWD88pRGgUWs0RQCiXBMH4envL0eCR4bCyT/FXmpuqB3z+oY7xZpw
	 HuRwUzUImpUjGC0IFrxUuk4A6qofSYmtU/5b4eRaJhNgNR1al4ForOzaNWH8x5hukrLW4
	 eaomU2OP4UfypGFnuF6ER/mRH+h9+Fy7EUIDE3CAr1r2WpC9yqUUrm3Q2/HaM6Z/Ldw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JfU0z+l/C3S3U4rsNfAiwjKLo3LvL2BjygMXwj91Saw=;
	b=kvQf4Dqa+fKAxtfjNg5+RTOgZ1JSjKV+WWF0np1U2JYvUG8WiaRiH8vWWkg3RbhUOrZE
	 0isEURZ2KtZxBBF8rAFZNqotgOkVsj8Fs0+v9C90USuacBkUV6vFhXSHr4dXUqf7Xb0I/
	 xFd179jO5M5Wl3QguAK24yUoNFQse7cMNRQmZmR0dTwq4d9nUouckf+Y97kRqZJJs2ld+
	 jdPi/EqBkXoloxihPQOgVriARMp/EJr9OJ9I7Et+uf2NWHIR3zMaF0aD6niE+ulrn4xKW
	 5WJ1FUppvm4t+/jXb2BC4OFlcicnGuqmZrNMDrp85CAiYtdTMChCpYBMjTXpFbKGpFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WO4Slqp0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2B2606A320;
	Wed, 18 Nov 2026 22:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WO4Slqp0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEEA1F000C4;
	Wed, 18 Nov 2026 22:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039837;
	bh=JfU0z+l/C3S3U4rsNfAiwjKLo3LvL2BjygMXwj91Saw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WO4Slqp06hZjYP8qWGvTYniWXEPYwzI4rYxa+Zl/2+G/31QDPi+MHq+rCrAApxzOx
	 NmZ0mMwC3tH6s1SqWbcJIA1umuh2XCd73pelYDZPIDhAaAuc75Pu1I3hJ9fHEXWE9i
	 YWY+RQH/VRNGCJHO4IXtCGNGPl9TspeFzEtJLImI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2244/3318] md/raid5: setup_conf: Fix null-ptr-def in error handling path
Date: Wed, 18 Nov 2026 15:47:46 +0100
Message-ID: <20261118150429.167851842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 873dfe8d971fc..52eec38f17c3b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7576,6 +7576,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	conf->mddev = mddev;
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7649,7 +7650,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (ret)
 		goto abort;
-	conf->mddev = mddev;
 
 	ret = -ENOMEM;
 	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
-- 
2.53.0



