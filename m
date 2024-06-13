Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33533209;
	Thu, 13 Jun 2024 12:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280956; cv=none; b=BVFNevFOkCMXMDZpSop7vy3l1hCCq7Q3JdwJ85lYCBgSHNZk9lGBYxFbyBrEobEKt+zEdjEgyKuATGtgyrRmHzc1CaCuMUPReBwQBtnksW5jXjGhBwckp3mxdME3Cl44LMHgxq1bkZje4J6t0wPESjl2LE4uexdq8BIq2TJabSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280956; c=relaxed/simple;
	bh=VLPkdqocuRWq2HTKXKqa6o8vzyeJa8ZWqGkaOdc1pc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLosS2ejoNy1+sdr++c6mVwgpqc+iWbcIPj6tLXYqwLJ+ESeuYs27UKGibEJFRrfbgH4eXG0lNkFG3ZbLQWHMSd+30XfE41LggRiR+X9GCnVmMwg1Xr5Mu/Bad4v0kuvXaU1WUMjh/MchqnRq5bt1KXK0igbd3/Qj1UJyZPvY1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eeg9riKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eeg9riKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333CCC32786;
	Thu, 13 Jun 2024 12:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280956;
	bh=VLPkdqocuRWq2HTKXKqa6o8vzyeJa8ZWqGkaOdc1pc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eeg9riKyd+J168OrnWcBu16B5r2c3pD//IgYKT1eqpMfAvl3zIdZFrEEukyu7RJyt
	 fXj/5ECjGAm1WrUyT7Kt2Yiz88/JKWTLCvDsjuoSuYjPN8TUmdNIJJjJAx8qm3fcun
	 IQWgHaYuCzvkWs7xVXIu9E6/8BPe0pRYtXlctqhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Rander Wang <rander.wang@linux.intel.com>,
	Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/317] ASoC: soc-acpi: add helper to identify parent driver.
Date: Thu, 13 Jun 2024 13:31:49 +0200
Message-ID: <20240613113251.071966296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 644eebdbbf1154c995d6319c133d7d5b898c5ed2 ]

Intel machine drivers are used by parent platform drivers based on
closed-source firmware (Atom/SST and catpt) and SOF-based ones.

In some cases for ACPI-based platforms, the behavior of machine
drivers needs to be modified depending on the parent type, typically
for card names and power management.

An initial solution based on passing a boolean flag as a platform
device parameter was tested earlier. Since it looked overkill, this
patch suggests instead a simple string comparison to identify an SOF
parent device/driver.

Suggested-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Link: https://lore.kernel.org/r/20201112223825.39765-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0cb3b7fd530b ("ASoC: Intel: Disable route checks for Skylake boards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-acpi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/sound/soc-acpi.h b/include/sound/soc-acpi.h
index b16a844d16ef9..9a43c44dcbbba 100644
--- a/include/sound/soc-acpi.h
+++ b/include/sound/soc-acpi.h
@@ -171,4 +171,10 @@ struct snd_soc_acpi_codecs {
 	u8 codecs[SND_SOC_ACPI_MAX_CODECS][ACPI_ID_LEN];
 };
 
+static inline bool snd_soc_acpi_sof_parent(struct device *dev)
+{
+	return dev->parent && dev->parent->driver && dev->parent->driver->name &&
+		!strcmp(dev->parent->driver->name, "sof-audio-acpi");
+}
+
 #endif
-- 
2.43.0



