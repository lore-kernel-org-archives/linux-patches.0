Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064143;
	b=rHd0Xi8aOk00Eb8XuCxJZWYof7XP/jObAZPk0zz3l0nOMdAt2jKqNf8r44XaUyew02cb
	 tRsx2zx7nALzTFxl5UGUjWqHsIemLCRp67rPID3A7sRMn8DWaCxmzSYNJjW4PD0ga4XDi
	 46y2GGz9vxsckfmjgZ0AoGo7jMAFzO/NTCZstofkjmsTM36bgg8YXmWFjKNhYyF3kZAZU
	 Vbd2bwsqDRaZbQbRaRH1cX9phPR+hwZeDK2BaBdUEpwXKIMBQwGmxs8NlKPHiNsuKfguq
	 rVV5MCREyNQor7Oeq3+AyyntKOrxdTXJv6J8MpExxBqlFKa9d0HXy9AjJ+aIEiG4URg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DiR/PlWpCTATaN+pXUgJ62cdeTh5/yqN+tMEPYds5WQ=;
	b=LnFAbac5OVlOQca77kArftSlIixYx10/O4xggYvjp0l/uYHE0lFWsC7Q+kZJ1FnI9RCw
	 lFmQ2E+poNmDI8EJRte4laT9MF9Oq4RMU7mZEtYvGIoS6Cio6giMrUen5CxZILjoeAhEf
	 JLkfLiFNCq1bUh46b13f6RAljBfLIZ1FIMK5Jtt0GVv46eu1FKv6Nth09AWSTsb/BZyyG
	 bMgo64C23XhCorNcfyA5uhNaQcGuIZEEiA0KzBST/x14/9F44Tsun2QXgrrO7rfLhf+vG
	 TLZAjTZ5Y0oezMpLddBmKQparcbnogCOrjSfW0LSUUvj3knoyE8UkvNueYj4zdghZ3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01HXo6mX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5ED606B89A;
	Sat,  7 Nov 2026 15:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=01HXo6mX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7CE1F0089F;
	Sat,  7 Nov 2026 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064143;
	bh=DiR/PlWpCTATaN+pXUgJ62cdeTh5/yqN+tMEPYds5WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01HXo6mXoHcZbcAwI8C3HkITjDUERT07YPCArSDivdUSAGNpaNQE4d+0jc/4IMALq
	 vqen1Js7PtGAiXoUVJLsWDAUgMFeYmRF4kEITpKWFRnonDOPleVmJbxkBAxQUKOKC2
	 15KEQlDTX1RcV2LhTQRWU7JlgVaUMMkqQlpURAeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0291/1257] ASoC: Intel: atom: Fix platform device leak on probe failure
Date: Sat,  7 Nov 2026 08:43:07 -0500
Message-ID: <20261107134947.502901348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 73624e1b138a6..de1ad168008bd 100644
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
 	strscpy(ctx->firmware_name, mach->fw_filename);
-- 
2.53.0



