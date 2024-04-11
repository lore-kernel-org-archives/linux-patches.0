Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CD213FD94;
	Thu, 11 Apr 2024 10:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831225; cv=none; b=lMz+JVztdd7HodecGGIPiHP4iz+Pmh/aI01FsE1lEtDIagZAZlVeTebf5x0ts2Nu+DCO+9vHxWgs0ooQ/DfFt7HD/JzZjUblrGA68S7cIr9pypC8o88HFHMQv4JcmFQTXodSFYXUrft/RfTeVd8yRITolKPFJV+7vNmSAzSBCE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831225; c=relaxed/simple;
	bh=lem2TuFQrcbn+mzTpjiAizGcuH6dcVXmKT8HGpDssbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSeEXbB9Fj0iRbZNgw3cKAeab7dXrDtoCp7XSkiZ4McVodwpris+xVPD55mAWs7DctgTCQrZ5+vcmiD5hpmBK5JiYY2Tkw6y4LZ9jv2+2oPGe/fsx0uBmas/wpU9z8aMj+wCv0t/P2AxadOePwp6JPeUgVa/yjze2eGSgHLbJ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yN1lwx+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yN1lwx+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F76C433C7;
	Thu, 11 Apr 2024 10:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831225;
	bh=lem2TuFQrcbn+mzTpjiAizGcuH6dcVXmKT8HGpDssbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yN1lwx+eyGYsUmb2mvfrwOZm+8WSL/Z6hl0XXUg+3AQFvZKPjEKWnuH9EXr/pyDAR
	 rkxcS42Z/3LychQ4v0aOapN2CRcKOnpeuNXz/Du0jYu4easGkkGrGOQkOkG7PAjoEz
	 oyaUm7pHWrvgl+laH5rkkdw0WWDyXVAA9SqZD7dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Emil Velikov <emil.velikov@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/114] ASoC: SOF: amd: Optimize quirk for Valve Galileo
Date: Thu, 11 Apr 2024 11:56:16 +0200
Message-ID: <20240411095418.365444309@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit a13f0c3c0e8fb3e61fbfd99c6b350cf9be0c4660 ]

Valve's Steam Deck OLED is uniquely identified by vendor and product
name (Galileo) DMI fields.

Simplify the quirk by removing the unnecessary match on product family.

Additionally, fix the related comment as it points to the old product
variant.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Link: https://msgid.link/r/20231219030728.2431640-7-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index cc006d7038d97..add386f749ae9 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -28,11 +28,10 @@ MODULE_PARM_DESC(enable_fw_debug, "Enable Firmware debug");
 
 const struct dmi_system_id acp_sof_quirk_table[] = {
 	{
-		/* Valve Jupiter device */
+		/* Steam Deck OLED device */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Valve"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Galileo"),
-			DMI_MATCH(DMI_PRODUCT_FAMILY, "Sephiroth"),
 		},
 		.driver_data = (void *)SECURED_FIRMWARE,
 	},
-- 
2.43.0



