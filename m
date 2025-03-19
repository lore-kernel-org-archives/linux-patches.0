Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C5F1B2194;
	Wed, 19 Mar 2025 14:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394905; cv=none; b=VrkOQg8QBRgvQWpLFqL2m+tj+giBk5V9tUJsgPRS6gFEaSLO4Kk/7KkXAjTN27sMBfvUoNuhi7KZxTHNrhuCgM71RCBelfJjxlSszoBWgevaJ+PNxTs+4W/bJAqc7iBD+4EgG4/T7RvdVMPGHUNi4SY+rVF1mqeoPrrxV2Qw0Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394905; c=relaxed/simple;
	bh=zgossc8tH6T3nb1y+p90jKSG6qBZHYA50oZnUIqUCAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFZHROlcZ+gRthNZ6GDEJOovu+nQrAAV1s3T0+IBewiQ5uFWOOQ5IJ0UpfQ6Q4azq2g24QGrXmBG6l73QvVbYFQHYeSPKOd0kUtxM5hpM0FlA4WpKNff7UtmwWWgKiIo9stXo7MQU1LXgQ7cgjWxUo8QpyPyrvBF77pq3C4qJAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEKtcBnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEKtcBnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2206FC4CEE4;
	Wed, 19 Mar 2025 14:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394905;
	bh=zgossc8tH6T3nb1y+p90jKSG6qBZHYA50oZnUIqUCAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEKtcBnJ32efa/rjqoSBC+2bpkW9SSTN77o/nxGRKm73LhUeI2rqg6X0j3zyeQvvf
	 2C+OdhWswQPCKkrgqKRnwpO/NUkoJ9P5AACwAdjPnkNh6FKSpbc2jOubeWzIyO33Df
	 yBIveeH2qVweSTsmyo1AKx1doNUoyyTR0SiWnVZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday M Bhat <uday.m.bhat@intel.com>,
	Jairaj Arava <jairaj.arava@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 108/241] ASoC: Intel: sof_sdw: Add support for Fatcat board with BT offload enabled in PTL platform
Date: Wed, 19 Mar 2025 07:29:38 -0700
Message-ID: <20250319143030.394552158@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday M Bhat <uday.m.bhat@intel.com>

[ Upstream commit d8989106287d3735c7e7fc6acb3811d62ebb666c ]

    This change adds an entry for fatcat boards in soundwire quirk table
    and also, enables BT offload for PTL RVP.

Signed-off-by: Uday M Bhat <uday.m.bhat@intel.com>
Signed-off-by: Jairaj Arava <jairaj.arava@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250204053943.93596-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 352c7a84cc2e8..e3e474fa4dae4 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -747,6 +747,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOC_SDW_PCH_DMIC),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Fatcat"),
+		},
+		.driver_data = (void *)(SOC_SDW_PCH_DMIC |
+					SOF_BT_OFFLOAD_SSP(2) |
+					SOF_SSP_BT_OFFLOAD_PRESENT),
+	},
 	{}
 };
 
-- 
2.39.5



