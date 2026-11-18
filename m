Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023751;
	b=rK9UfkoHI1mfwvcUCDq4h3q3GTJP1flVoYhKsa5RWx1d1QrjE7we/xsEWXuXkQEU9DZE
	 PIJPlFcRI/jZzyQAgKgtaMuRKPJGuhDdfS/UPHrb+ylXsMiCZ46JT93q8+jOIOl5MJa0f
	 Pm6wdnb8TIJqLMUdoag95UlEkCbhWmQgK/CgJSeMSPrKNUum7ZKHhZXgoQ/eAMvcl1Joz
	 eZ7evej5Kg2xULSBeKVjFfJRM75EsSokto4QEkS02x6m3KmY4LPeSvr9F6+iYwiYy3OtI
	 Yj5ncnqdi56SdJgNLplRaz1kh+30bF+GgSK/Z5C6KDbbFOiYhjGI/OVfS+/qi0eZTvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cF41ZZbdro6oY2LXhuj3ifSl8SN+bjS48DcyZjyx+4s=;
	b=1V58/pWMOr3mnjV6+GU33YkJgRynmspfrtWQCfD2h7aoB1I3f2H/k7wqOjiEfhMTuwBS
	 u4t1RgGw6YuPwRQNIE0jzu5dYz1AFHJz2LsOGCE8PXBaIAsjiFF+yjjWGpekmTC+lWqjH
	 g6km8WvW1gOH/t2iS3DI/y077ipkN+PAggeseb4kQwFODxwAwiJNmZmflW+JTUhUdgbS0
	 mR1nSqGSQ3SPew9HZDHhDe5/JX/v8Q0Jng/m4blsRq4e72cCOUOZ3n7y5nit2QSxM1HsC
	 vlQ2FYvkeeaDnei3Gvtd6WIcNaNdNO8XNIflTLHHc4wsrBA7PoKcsDDC3ks47WKwtVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4U64m0v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894D1606A325;
	Wed, 18 Nov 2026 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4U64m0v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFECE1F000C4;
	Wed, 18 Nov 2026 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023751;
	bh=cF41ZZbdro6oY2LXhuj3ifSl8SN+bjS48DcyZjyx+4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4U64m0vn3H34F9NK8nYL139FdMCtiQVOoj6NSVAOIJ+eYzhB4IwRYKIq/jRStWx8
	 XwlUp12KIu1keQoTBN8RgSdgyb/HMto8yQH6o0tjJ4zL0kbidJow6ZJ5484PTek2Kc
	 dd0Wzdp3JZVUANlIS6+FtNrPdLfPqpdNP7m1IP/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0482/2151] md/raid5: setup_conf: Fix null-ptr-def in error handling path
Date: Wed, 18 Nov 2026 15:36:57 +0100
Message-ID: <20261118150139.607652878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6f71c0c3dfd74..42602ac28d903 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7529,6 +7529,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	conf->mddev = mddev;
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7602,7 +7603,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (ret)
 		goto abort;
-	conf->mddev = mddev;
 
 	ret = -ENOMEM;
 	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
-- 
2.53.0



