Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016510;
	b=nPA/HLRUo9grG1jT6IZ0/mjT5QxMtvQPcAMHpLXx2UwQ/bk3W+WnWhkC0stOmCxbH7qa
	 4VQpgqqP+wbeWkq28birqOOMlEGZc2QGPISITyOGDTMypHuqWZld69I/ULYMqFZ5vQjKA
	 NZMwJf6ivt9ek4Ycj+PO3TcyB9e2bMF4PFuNTJD2OAcZp3PghjeGQfR9bZwia6QXZ5FAK
	 5/D2CfZUHHtWUicMinPZF8QpqKdH7+LoJ0dqdFGw+W5hYNp56XB0qQWEJmYq6Ek+a5/lm
	 A4uhARLrju+HybAhGN15TQF2k4qLt9xwzzvWZtVsl+3t5pxU85W4BSNKvV/eu4OXL1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+BJAcMDWfQi3kFuUWtVliMLjRdgVd7eE4RQPu63XwFc=;
	b=DszfARylmOLbaNTU9h4sSPYQ/GZ2h7qQiMsjqV8+TwB7GEENLTZECp2OBez13nfov0L7
	 e4IIKBeftplF/f9uITD/ifoHclRP722R2kPT3IAQ0Veft+EITrjE1IPxQ/1R/I4h7URRf
	 8pJuP4ly58J+imMCiyBHpE7I+MhrVYSvVfCGZgMG07OHA3hrFeSF0FYjkkSOTg+4bDDCS
	 GWcrAD1Co5y548SoLL7fUQZvTC32tTR3bZgp3mM4OFX56lObAxFk12ewksRG3hl4Vki3b
	 36GbehFX8b5v9anaZ0TFRNmqOuYsnjij9M/UwUmqyJAwCWI/cHIgLMB3aVN95r3MW4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5YLJDf1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3840606A320;
	Wed, 18 Nov 2026 15:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5YLJDf1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232DC1F000C4;
	Wed, 18 Nov 2026 15:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016510;
	bh=+BJAcMDWfQi3kFuUWtVliMLjRdgVd7eE4RQPu63XwFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5YLJDf18/UUMXwzuBKf2wd5ZHUnD4efn2ZSr4cNxUzgNIo+1DoIzeQrSHUkvwsIx
	 o6hzRQmGRVBm/L8OEkOiKCi7DGKC6/KWbgnZCvaqyRXRwgDUVWy/W1gKrqx/iuPGcS
	 5HecgMKQXyrPhIjvE+gLyePhngeAhRPXzd6ZT3RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0517/2651] md/raid5: setup_conf: Fix null-ptr-def in error handling path
Date: Wed, 18 Nov 2026 15:29:17 +0100
Message-ID: <20261118150306.364703293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d5a8428778e36..45b00c9904215 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7679,6 +7679,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	conf->mddev = mddev;
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7747,7 +7748,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (ret)
 		goto abort;
-	conf->mddev = mddev;
 
 	ret = -ENOMEM;
 	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
-- 
2.53.0



