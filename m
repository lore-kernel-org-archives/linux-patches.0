Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052349;
	b=fofzfsuP5CupHfknAWrECeWEw6M2RgDaY8uY03CSzjO01Xw4UMc1fndcRkI8RVsoWYT3
	 PQ+nicwIDinz3sWMgyR9l2G3kTB+/L3v3VVwZlm8JmTVqO99iIIkyTyDJkayvWRd5APxK
	 TZAxFQvzKjCP/HZStSYKzzWKIVVtXYnq8QLzkTPDDxIzsCFRcXunDkzGPvsNFGku95x/h
	 mQIvCp06eFR3uy+l0kLeQ+N0C6FR4hyGi7GvZlhNprM0+PupIv9BvOJHfwWtvpkHO7ScF
	 d3dfPPALsuDsUtDW93dhYUEZM10q3JkUh7U3eD2RQ1hlQK/pHl8cDswxWESGfGCnrcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8qItVhNX4U1rgBG15mjjDFJlflAv+j4WJU48+4hmdXw=;
	b=OSyjRc73QZudCn6JyZRoh+TgnIA5SlQSLq1NYtuMLCVTrW/OgOucS0ZP9LUPh6gnsH6N
	 JBhA44rCbsz4sufYwq5J49qSw1soVc94AVILcLeD9qsJPGm51IkrYGEj1dUiYC+tSoc8H
	 5cse6JjqmyFMysNY8rXpBtvqC3hT5OmCnzzg7HuMGd73p+UcNG9Zhlk/gNXeshiQdTal4
	 0ifV3HFelVdjIc3sogX0kPqoUJ8GQ03uTpD/dQOZgY88Z1EjsuWU2Wd0f387dRNbZr5oI
	 MoeCvikhaWhNxhbweOu8WBuxznoPyTZVKSTBG0IaQa+2C7TH79YynRyHSQJm/w0z5Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbsBAHIj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE75460A380B;
	Thu, 19 Nov 2026 01:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbsBAHIj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435D31F000C5;
	Thu, 19 Nov 2026 01:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052349;
	bh=8qItVhNX4U1rgBG15mjjDFJlflAv+j4WJU48+4hmdXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbsBAHIj4XfF9Btz0FCy6hmf4rHzgqWEjRh+CqlERfPEB55uwc5MgmsmgbV5F1OEl
	 fuoL164CrNN9Euovd87qCeLNt9lHOa4i7FhDctlR1H6cCLQRg42mgFUxf0F1W5qglD
	 LQDh5n6kOEOeTWmm8XtM7zUwNEOI4jzHZHWlUNbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0533/2214] ASoC: Intel: atom: Fix platform device leak on probe failure
Date: Wed, 18 Nov 2026 15:36:49 +0100
Message-ID: <20261118150032.372089456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 83fbee88e02a2..0e18e24125135 100644
--- a/sound/soc/intel/atom/sst/sst_acpi.c
+++ b/sound/soc/intel/atom/sst/sst_acpi.c
@@ -254,6 +254,11 @@ static int sst_platform_get_resources(struct intel_sst_drv *ctx)
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
@@ -342,7 +347,10 @@ static int sst_acpi_probe(struct platform_device *pdev)
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
@@ -355,6 +363,10 @@ static int sst_acpi_probe(struct platform_device *pdev)
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



