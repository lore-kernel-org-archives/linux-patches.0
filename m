Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F432FD688
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 07:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761119595; cv=none; b=khMpBSGYEztzFkXCM9y3tZ3ICJzJVjHVI3XnQTpFt4OLGbyJNVVgVT5wE3o39syDq6kMKMog2LY4r//iMh9tpnysvRbW50Ugfg0xPGR8UAlqCu5ZntMZyhIgjWjq41Y9Yy6qxQ5MVYc6HMlHxltXlUt34+6P4JPXZJCXQcZIVQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761119595; c=relaxed/simple;
	bh=NVEVc5HmVV5+klwi8ZNSMdxU2jEjKAdogelzBxuyRrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEhweXTlc6dVTGOM1yoczTueNKFPN3pWqDwp+hF5maCNZhQP1btudSTJJgSzRW9sI3UYGCE1lDQutFAletbYuU4ac1SVFde+54G2NS+FiJCiGryb3kCknkb0p/+2bXNXTRjCnUhaZV/3Aypwb70XoJBbr2n2EbJEQi9G8kVwPkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=aXMYE9l8; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="aXMYE9l8"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b3c76f3703cso113940666b.3
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 00:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1761119589; x=1761724389; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:list-unsubscribe
         :list-subscribe:list-id:precedence:user-agent:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Np0FoOcxlyI7hVIm/wC5O0j9mybbBaqeBJm2gWQTDc=;
        b=aXMYE9l8nljjgml9UEVzQw73lVBYIM1qfbPfN0+c2Jtl3QGUYencmwdXZVIHvOevwZ
         po53kk2oXeRpiVza0MeOAlYPNjcZkPpJ7qgP2zVYnvzDFgjlfprjr7Vpr8l80Sg3U0Y+
         nNZ4uUxVILmqJUNyRH938DY6s+vYF3RsIy63AE2s1Skn3EF73nY2uFqClk9eUdTn2onF
         Qx2yOi8a8CjF542AKaouB5mCVEjdkLVpnjEA1S0X9hIcqqaf/udPoMmy05/D63q6d9LF
         NbQFeITIXk7rC5tihBoljBaHVxiWcBHlM8lr1C8DnXiTf6RQAu3+vnbqSeZv7lfhLc5+
         2OkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761119589; x=1761724389;
        h=content-transfer-encoding:mime-version:list-unsubscribe
         :list-subscribe:list-id:precedence:user-agent:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Np0FoOcxlyI7hVIm/wC5O0j9mybbBaqeBJm2gWQTDc=;
        b=CxifOoPN8dL9udmBGZclNRxb2tZWppbSCf6SQaMIRbGOBnQ42nOZ5VstQ05B3FdYsE
         AHkGVKnb6AFWUNdXAQwkFM4Pq1UYxGgDc5kD/8aXsyUccwNbXQzkLx2pp5cwpSri/14q
         Lt5xEoY6uWrN83inCTTYGQFbSK5SPPma+nLseIaTUpVDTjuN0MNQXpZ/YkaHVoVPrEJC
         bede/sK7f2UD4NOToyrUwt3jYU1iEDpgj6330aizGqBOXWHLiePmGt2UBoWAyIuN+7Dj
         a23HQHY9OO5rw4tsMxFOl/50TR+LedoKfRZ6EOy8bboadt0AkZP7B5m42M06KlaLR/WG
         oYhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl34FpZOTzabW7BLIoC4kArwbVyZdG19HSC1Ek47oW7sIl9Sk5Bo/Csqdi87A6e9seROUg3ILt@lists.linux.dev
X-Gm-Message-State: AOJu0YxkbxfXZopPbXhbd/kDNFEtlSlRWAHPJur1VVEsYGY1n3XELEkK
	YKLCyoEi0Iag0Tgqx8RsLuvlVlXRsAxDY+dIqukPm2fxW7dvMfJW+MqUHXuCRr+/dQ4=
X-Gm-Gg: ASbGncurRU2qT5DFG1+D8yzeEnhfEmmjhxEPXB0t7YcYU4mrDHiuQlBUFP5oH1uNXls
	hjM7OiQwcPmJECDB7GbfDylEDHnTshnCgOaftc2rQIBb1tZyi1uyT277Ibr/93CM8IqHmYdfbmC
	EkQ9ks0bAVDzLkEBfdZQt8sAUBL36+MBpc9U+C5x7NvG+5MKKOm9Z5oDDgd/yvDfdfMf2CGQFPP
	my8+VD7rL1xLemxjxPx3d8LOziQRV/chosR8Z9b8fNVw3RtYYtqTdJ5KM0WZTfwl+a58z2vlYfa
	FsrRHdd9LqWrBMFjrJsmPnf9Y6znRco3Crqfupy1jFtfsc7gL1IyCP0N3uQ9+D1WbvTF6aP5rKH
	WZN5dSQsmDxlVoXqLK9Llv4Xm3CvWgRSZy7ZWBu7IQWlxh+C4qDVBZUCCFdiWRFU7dLrYUnMWHu
	qnkxLfQpAIj5xznrGDWEXxPuGXY/u/9H8ZcB8=
X-Google-Smtp-Source: AGHT+IFWiu60bAMGJoOFtuBtm/G16Iaqoy90K2ZjhLUjbbNGur2Q4tyDRQlfvomdLboRV0XvpFF8Rg==
X-Received: by 2002:a17:907:6ea3:b0:b65:c8b8:144f with SMTP id a640c23a62f3a-b6c793063bbmr421456866b.6.1761119588933;
        Wed, 22 Oct 2025 00:53:08 -0700 (PDT)
Received: from lb02065.fkb.profitbricks.net ([2001:9e8:146b:cf00:d95c:fb2c:e457:3090])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65eb9523a7sm1291852666b.71.2025.10.22.00.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 00:53:08 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: axboe@kernel.dk,
	hare@suse.de,
	john.g.garry@oracle.com,
	patches@lists.linux.dev,
	sashal@kernel.org,
	yukuai3@huawei.com
Subject: [PATCH 6.12 111/136] md/raid0: Handle bio_split() errors
Date: Wed, 22 Oct 2025 09:53:07 +0200
Message-ID: <20251021195038.635577649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20251022075307.gtj4IBn4YOxDmnffQ2OyOQzZGo0GMPLga_vv7czr1e4@z>

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 74538fdac3e85aae55eb4ed786478ed2384cb85d ]

Add proper bio_split() error handling. For any error, set bi_status, end
the bio, and return.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241111112150.3756529-5-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 22f166218f73 ("md: fix mssing blktrace bio split events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -464,6 +464,12 @@ static void raid0_handle_discard(struct
 		struct bio *split = bio_split(bio,
 			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
 			&mddev->bio_set);
+
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return;
+		}

The version of bio_split return NULL or valid pointer, so we need adapt the
check to if (IS_ERR_OR_NULL(split)) for all the 3 commits about Handle
bio_split() errors for md/raidx.
