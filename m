Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469121C5F2C;
	Wed, 19 Mar 2025 14:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395068; cv=none; b=HKFi50lP4cibNge+JtnFlsQsBG2nj+lHRT2yDsLjqdf93Te/9/OnpgbC+uehLp2X4FFQHR6x14NtwA/Yio3OpG+weiPnN1//v+wIoHdETgSyvq6ZpXA3lEa/enwfzxIbWhJip+OZe+qzx4rEvM04LJcWgPESASHRtWo32GWh3i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395068; c=relaxed/simple;
	bh=Q0K4HJBZ4SzI9533+txpoYAxtxGhfb6a8ZafXybWbFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdNAq5bhs/Goq3+NAPbCsDQQfSCpq1ZS8TeH0CpyaiiLPDTAHJSut0U7PnEPLMyWN4hej4BwPYACgrMMhbtpg3FJFklfWlHndiqMlTzxbglF7RCJlon9vnm7OcMvOv6IeMqNxGADYB2rzn0i5U+wJUiOb4GHMRExrz0+YzNy0VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kT7/d9pD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kT7/d9pD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFF6C4CEE4;
	Wed, 19 Mar 2025 14:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395068;
	bh=Q0K4HJBZ4SzI9533+txpoYAxtxGhfb6a8ZafXybWbFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kT7/d9pDlKTcGDME6EJa+CpwJG4kGinT7hmGjIO7GAw70PUG2z1yyaeur9Tx12fch
	 NIdYhViKLvwtnqvbYVIxWA9UXDjZDXzFoqAsRYrcFpaOgEVER+7PblPWqrY0YDMkxv
	 Z845JuY7O6ECMgP40vNKspjMk9CBJAI2JUIuMjzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/231] ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S14
Date: Wed, 19 Mar 2025 07:29:57 -0700
Message-ID: <20250319143029.404331831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 0843449708085c4fb45a3c325c2fbced556f6abf ]

Asus laptops with sound PCI subsystem ID 1043:1e13 have the DMICs
connected to the host instead of the CS42L43 so need the
SOC_SDW_CODEC_MIC quirk.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250204053943.93596-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 8f2416b73dc43..f5b0e809ae066 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -687,6 +687,7 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 };
 
 static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
+	SND_PCI_QUIRK(0x1043, 0x1e13, "ASUS Zenbook S14", SOC_SDW_CODEC_MIC),
 	{}
 };
 
-- 
2.39.5



