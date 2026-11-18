Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029683;
	b=dqMRhD4lawHWhyoTZiqcmcn/TnyYLLME15qYX9pG3Ut4tIO3TpC2EPRBP2msvbjU1jt+
	 n8lpluANiBmihkBFKfxeHoH8SF92ZcCi2WYOx70Eyt6Zswgd1AshqNUlpp768mBQHx4DO
	 Sw6L6Qz4OJvjFD6CM/KYVr9O6CZw/gHkMfeevC9QfA5J8DeHikfWuXhGw1n7DHE2tPIwC
	 2+YU7IMT9hNQG/tWuDBgFq7sjudY7/ZqOswjhax+ZU2/EyJ23ZhwzXSfpvUT4dCslt3ad
	 hI+tY3SVGzIOgFqoJYhVAaivMS4qR+irj6OQt3Pc+RAbVwdx8ddMUka3BLxn9ketyzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+3eNHlaKvALzVNTPR6UxaWcjVeyRNvbtAMIsV9VrGqY=;
	b=fsuJX5L/XYdUHrW6Iz4RR2FouxVFvcO6rwlmmOsBn7K1j5SIOze32Bl6y62bTpITHKSN
	 q/ME51LLlnJcowNcqKPpy7tYLFelB4/fHHC404n+C3XY/IakabfV3FSxTC0CdcoKlYGvK
	 JOl5fSibG/dynlZb1muMbDeqhJOCnOZyYeuL334X16QXFSDjwW+nhtm365+wdEjpsgrjC
	 iyqz67Z8n42buC1EP5wOWqMgQxjhe8X7BSCnDMkCQ8r1XX+9D1If3Q595wtBTVZvERj25
	 gWvn/s9yqnjFMkqSoGu1hQ1vKaPOz5ZvDHyvrshHGpJ3k6vK7FM+ahHFQEU2qebsQ1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+st4tW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE2C606A325;
	Wed, 18 Nov 2026 19:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+st4tW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B421F000C4;
	Wed, 18 Nov 2026 19:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029682;
	bh=+3eNHlaKvALzVNTPR6UxaWcjVeyRNvbtAMIsV9VrGqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+st4tW8Zb16YTaa0ecqBW7PnjKImyWEZR/juSEukAu+QnTlvuo9kB1rMqjxNtys+
	 nwX0hoGg0tfEFXyM1AhjB5uM0uTQymznWVPZXiokhpLvbA4Lu/cZW6qB/ARuyHi9yw
	 unwtnEURzZsWuaQDjcp8DGUwRvCcRx6J4wXvRnfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0438/1756] md/raid5: setup_conf: Fix null-ptr-def in error handling path
Date: Wed, 18 Nov 2026 15:42:45 +0100
Message-ID: <20261118150026.176824159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3a4f949e95c11..2dd4a7fb83dc6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7534,6 +7534,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	conf->mddev = mddev;
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7607,7 +7608,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (ret)
 		goto abort;
-	conf->mddev = mddev;
 
 	ret = -ENOMEM;
 	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
-- 
2.53.0



