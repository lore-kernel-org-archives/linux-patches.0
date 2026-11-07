Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063024;
	b=kBU+JeU/qqL00vwV6UMDIoZvTjyvRGwn7JMJGe4yDC6wG8mX85//GWRfqSEX4Mw+wqPi
	 OGPHZ+0k7NFXngosMob1OgumBan5SQicmOJKyIsIn1GC2J3QLmOamx+iRnKJ1wfE5CidX
	 c6gcxDOYlgF4dHVHfHWUDuLaqPSOZC6RAvwgwhkmxwlqfrlhum2rZ7sMlA0V9lQFAlHOw
	 EDfA595FPrHm+5V9AkBrD6JfDHB3VBh2tb+fvea6bDrMy/aRpGijjfOvojUd+G7nO++Dj
	 m9UZXvFnG8mwz/eUa1aGWrM2LkcB1iSxvi3jHK7Eltfg1b/t9pdT2xWozm9xeE7F0Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HbWpSct+8L8IV/hdyqvbh0uPV/pJDhTQzr24UoT933Q=;
	b=kWhsru5Gd91XnJH8Z/0W56rTRR4edCBvGqOSEzH40iktMoSphtjKfTCEDqD6/aR3BmL7
	 bfIdj9mCfbg9v3B0zzQZCQCTC3ZVQMC/mvQW/YTZtQunePzL4H3wSabGO0v5lSQsD+LZ7
	 BtxSCgged12Ql+4YvNGXtXyk4EvFnul2nTH1orEA8tIQDTckbFUrfEcKYO5Qh1z78ywrN
	 Ez4swAqB8PyAn0htFTry0BwaQutV1TmlaepYlgVmpT0RRZoV8KUcgChNWYm4D2sbjeHbL
	 T48qhI5oXq/aft4HNK9WrJ+BYPLRRCVwpJVEtwQZwnufA/5zJZWIAaWktUfAhU34Sdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AXqt6EbA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AF8606D80C;
	Sat,  7 Nov 2026 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AXqt6EbA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E31F008A1;
	Sat,  7 Nov 2026 14:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063024;
	bh=HbWpSct+8L8IV/hdyqvbh0uPV/pJDhTQzr24UoT933Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXqt6EbANUYlu8LjYST9Xf7cxXgk7rAmAyTEQf8bzW3qf0fMJjwgxsCZxeUDvJkoZ
	 VO2u2SsXdWnvS3d5JDzf8kGlMzo28n1mVLR5sep9A3Hj/AWHXoAMdTDjHF9TVAQB57
	 ilZ28gaqzZ5np5Wn84sm7U5HzEh3I4grpgZXUjVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 236/869] ASoC: Intel: atom: Fix platform device leak on probe failure
Date: Sat,  7 Nov 2026 08:48:38 -0500
Message-ID: <20261107134859.814292270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit dcc36d766dc82bc57cd730915d484119befcfca8 ]

sst_acpi_probe() registers platform devices for the SST platform and
machine board using platform_device_register_data(), but does not
unregister them when later probe steps fail.

Fixes: caf94ed8629a ("ASoC: Intel: bytcr_rt5640: fixup DAI codec_name with HID")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924134932.1590967-1-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst/sst_acpi.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/atom/sst/sst_acpi.c b/sound/soc/intel/atom/sst/sst_acpi.c
index 2571806304755..92a68dbd841ed 100644
--- a/sound/soc/intel/atom/sst/sst_acpi.c
+++ b/sound/soc/intel/atom/sst/sst_acpi.c
@@ -253,6 +253,11 @@ static int sst_platform_get_resources(struct intel_sst_drv *ctx)
 	return 0;
 }
 
+static void sst_unregister_platform_device(void *data)
+{
+	platform_device_unregister(data);
+}
+
 static int sst_acpi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -341,7 +346,10 @@ static int sst_acpi_probe(struct platform_device *pdev)
 			pdata->platform);
 		return PTR_ERR(plat_dev);
 	}
-
+	ret = devm_add_action_or_reset(dev, sst_unregister_platform_device,
+				       plat_dev);
+	if (ret)
+		return ret;
 	/*
 	 * Create platform device for sst machine driver,
 	 * pass machine info as pdata
@@ -354,6 +362,10 @@ static int sst_acpi_probe(struct platform_device *pdev)
 		return PTR_ERR(mdev);
 	}
 
+	ret = devm_add_action_or_reset(dev, sst_unregister_platform_device,
+				       mdev);
+	if (ret)
+		return ret;
 	/* Fill sst platform data */
 	ctx->pdata = pdata;
 	strcpy(ctx->firmware_name, mach->fw_filename);
-- 
2.53.0



