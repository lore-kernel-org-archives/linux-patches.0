Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036078;
	b=PruM5+rJ/g9pZqXP9IAzhxNatEh4wMelTgo1BYI2QsT4iwtAQvUH9ip7h1UjCAPvY8VR
	 jvf6gO7hd8HVhoEDMGtfVl+2LoSimKpC/MLEVT8hKo3qF8Q5C2bW/i1iZKmSwKcHqv3R8
	 2q9rvWcejrYCkj8Bj22Yk+4g4TYI3nizgZdnSjxBrS4aQcHwi+ceRq/2gEuTBMKSkrZ/j
	 /RG6oKok51S2RHuU/92ohNvDHWv1mQF61IbDL7lX7gUl6vot6EbqjyfHXEXn/sWZUw12J
	 GljNjdx1zMN9znRDby+8DCSmjbUSDc4fErWsu5lIHwEbhqmdIjqxnItBUQcFesIUuqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mEvEvErtOTP+Zz5ounwz4R6flmIAnJRd0KCojJ91T8I=;
	b=mjUw1/cSAZ1XDgrTLKi8XqbfnbkMezmhxaooHkuHIXLRAOxGKeVn4UCPPy22UbNRMVoZ
	 NYn+yecEyOl9KJZ0LyvlCs6APlk9959HD8wJS5kRvJPrWpXwZcz26qWKuufrCARKXZbAX
	 J34iovaeA9kqH2tlOBoS1XOc2i/G8bnI/1sZj3nElHeSUP2t1/HBLtKwHKgC1r8nJOnoT
	 dXlnsc3H/pFrnKoOsL5noA3pJJL8ojVJnbdoQeoRBKE+lKaGprABURWPy0eY2wl4nVG3D
	 2VTaR66fgrv8+EXSao6xecpan3icIFqWvUC6uSUP+EXMcwa7nl8/mXGuOQezbo+DmBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZgglGWq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6BE606A31C;
	Wed, 18 Nov 2026 21:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZgglGWq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34FF1F000C4;
	Wed, 18 Nov 2026 21:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036078;
	bh=mEvEvErtOTP+Zz5ounwz4R6flmIAnJRd0KCojJ91T8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZgglGWqbQnIxJqdMD9HjHkNtoNvQutzox4cc9aWrcZ9REx4S2GczKUuh6FIHE50F
	 eEjA9wulXmT8ZCaUEQ+zfRimS9mjznWA/gDmoQ6MMXsDLVKsBRe7HUY44DuN8kPS/i
	 iaESF0JLBYlUVzVo2yiByoc8u9tFfLsBi87qt3dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0932/3318] ASoC: Intel: atom: Fix platform device leak on probe failure
Date: Wed, 18 Nov 2026 15:25:54 +0100
Message-ID: <20261118150347.514525684@linuxfoundation.org>
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
index cfa1632ae4f03..40a8b7a486e6d 100644
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



