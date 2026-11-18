Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045144;
	b=fSrqF9F52z73edieHiUyVwg5dXEpOB1QE6+s6cTB7l5/JkltS0FykM8yYcH2DiMnNYHW
	 KBZY4tDaCZhF2KDr6wOx7uKbMH1nFLh1WhFzpYiVbaxu6j6TNP31xgB1l/b75QBd3UzHk
	 7n1+tlQpHgjUIr/pE97RCya0q609LiNYCOhc5DMtnsnabQ4hHoUjoDuGT9SMubE+vZlwA
	 jyMWhn7+L4SukrjQ+OwYfLkCkvoSyOXvDDq0pnY9UJyDICllDzC+TCmpnPcAiZfa09stp
	 Ozw6A7aY5jtatAOIAyjRuT7c+GyInZKguA8EaMpd/t3+5HCX41wh78jjey9dTt9eulw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yu4wnl7S0y4W3viKAN0FEyfw3LmjO5VMHJ5itwDNa88=;
	b=BFsbAkihMwooVXk6cDfEapXlsDf/p8pkwFFr5YhTm5VfdN5f+l2CMhPdkyRDdV7D0GUh
	 t1I5C84unGAZHlEGkKDfh8z3j9OvJXeP9E0BHRB7w2izQL/3sYP+jySJpMMbNnz3pdiL7
	 xCMX0S+YtLQA6vjqyX7TW+CTQdwy+Uu5nYbHq+Nbo8QSkrF+WRmpBjK4nxzOZ7U43VQZl
	 OvbHbzjDhEmH1WetbvezKQ07DgKa47yGQKRd37JM+KKSlru9mFc3rKP3apDE/l6q5h7b1
	 0r1u09PTwd3Ym/3AjutgAsR2jnOBRC8ggyllI0E7dFwZqjx6e2roAHQIXo8Uke84nQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqJONw8H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B12606A31C;
	Wed, 18 Nov 2026 23:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqJONw8H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB181F000C4;
	Wed, 18 Nov 2026 23:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045144;
	bh=yu4wnl7S0y4W3viKAN0FEyfw3LmjO5VMHJ5itwDNa88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqJONw8HSa5r0fVs9x7V3I+BU7vUFbK3fk/crJYtvCY6ZcVTV+rlCZUkbtPcycV5J
	 yVjUwShtOxV+CzkOI4fwmDdqLdkd1+GrEDRQrvC1Tn3uqQ4k4DSp/7RfK+Iq/MrJBA
	 27w3o7cF3kmVvkLL1Elc1x8LPpmKzb952mk2Uim0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0818/2857] ASoC: Intel: atom: Fix platform device leak on probe failure
Date: Wed, 18 Nov 2026 15:30:52 +0100
Message-ID: <20261118150231.027146401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



