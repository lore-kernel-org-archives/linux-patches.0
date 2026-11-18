Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058290;
	b=yW++kPBM30A8twSyBQrCFhyrWDNwDJSZI/D4qvhBbjtmLqTUET7Rd/+ApX7m34I5hw6P
	 Fe1pVwZZbY4KaACup1MnmYiC0Dv1XLXyexEtL5KCVXJ1ZeUTetiqwEaKz5492NrCEfGBs
	 euwq5rd9X+gt4P1tmG9X7HFvm758cTIMg2kgxZQXS9XKiIO387cW2MnIlnzNU+A3vj77W
	 2pK5qNjFxn8kkdT7MXCJwohhZNZZIqqHLtc+ArEGIxH7sVbCsPUYZq+KdRbemjv8X+9f4
	 bpuqfjgSI1b7gxrwwwAtiqLBC8QrfJdSbH6itM9ZX0MdwtYoJdvJivCtOt6Cw40c/IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WP5iAcAHtjk6c7K6PpjuqdgSdofxfFM8HDIopFu6x/I=;
	b=BomyqraW0bEp2BRlpuZQN8/hh3RrPSvOggDctzEn7pZYhtZ9aez0Hjew00oprCiFeUEE
	 iXi1Z2ev9WOU/M4C2lE7sOhmU7DM43QXQSb9CLH1b5wVgkMlBwtVjGlTmQpT7NOPxPaIG
	 JVHcQKRF1xiQ6LnfqvTStPhlIdVrqbdSNa4FvEVI0+sVk4MeF7hxsxbhW8E0V699BLhAj
	 4sNHaa2KWzqVDDyQY+7fEC6hQGVG27N5a0F5W2SAaMUUzy7VHGbUuAM6syaYvku+NEkFl
	 IcCAb01ZfzvCy7pyagQ0VUDq8ZFxWGYSimksVge+XJaZSY4IJiEDGvME6/CFNW6517w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fnv2WQyC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95437606A31C;
	Thu, 19 Nov 2026 03:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fnv2WQyC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E366A1F000C4;
	Thu, 19 Nov 2026 03:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058290;
	bh=WP5iAcAHtjk6c7K6PpjuqdgSdofxfFM8HDIopFu6x/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnv2WQyCic+/VRGzogulFqUwaoCSlmZ8Jg2/3W2xrOnE/JfqA6UJnX6ir7HeP+F1v
	 q0Re/YEoV9fbvWEnQoXbUBMgcP640UQxznxkQ4FH/TJpZE7HIkBCjCA3+t22rNKF8d
	 5odS+oUqGyXnNLDMhnjeBRlTFujvDgEoSs//g/Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0432/1848] ASoC: Intel: atom: Fix platform device leak on probe failure
Date: Wed, 18 Nov 2026 15:41:10 +0100
Message-ID: <20261118145932.234633610@linuxfoundation.org>
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
index f943a0884976e..ab2f4f8b9d283 100644
--- a/sound/soc/intel/atom/sst/sst_acpi.c
+++ b/sound/soc/intel/atom/sst/sst_acpi.c
@@ -231,6 +231,11 @@ static int sst_platform_get_resources(struct intel_sst_drv *ctx)
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
@@ -289,7 +294,10 @@ static int sst_acpi_probe(struct platform_device *pdev)
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
@@ -302,6 +310,10 @@ static int sst_acpi_probe(struct platform_device *pdev)
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



