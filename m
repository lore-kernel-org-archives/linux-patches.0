Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A310F1E5216;
	Wed, 19 Mar 2025 14:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394938; cv=none; b=XVijnH0O5OmktBB4TBsxvH4Jv5JW0D85R657lpcpGyAoTVRxfOTWQFju7k9FnCDml+qdknS/FPcPYFt0YTlI4TwK5J3Y60cqCYeRcfAUf4L+Y+kgRD3W+er9i+JN3gEbMClhzxW0VGs6YlhkSHLGoE2Jtf4FIQSy5z/speB25zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394938; c=relaxed/simple;
	bh=PlOObE7wVbXJoLMJfxohyfrHr4LdBfClUrYkCy73pvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBXOecRodttBW8HgCOgDzJqOoTL3UqA70jYXwvSXXvbZyDANRO0HwKxkTWbTp8/jeWSmfj/LNnrNftz3UD5bHntuidTIDRpqIBEnXBEBG3ynCwYZijulDteDYTDCdWWwotJASTc2UUQACS3dbYgDLGPnfVBq12jWO1Fx/kYcgWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlOjw22a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlOjw22a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7007AC4CEE8;
	Wed, 19 Mar 2025 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394938;
	bh=PlOObE7wVbXJoLMJfxohyfrHr4LdBfClUrYkCy73pvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlOjw22aQvTr9LaQSgz0QOAZG/VQNq2a0OUAhOLCpy9Eh/dXCJfw9g1A22RbRIRFF
	 V6NWbO3fpZQ4/mOJE4o77U8e03hnlpai12nezvPjz6kWuJniwePcIgsinWCHYDL24e
	 VqtGyVWUYtZUqOeLV+wopot4SF2sOie8JqgKPww0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 107/241] ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S14
Date: Wed, 19 Mar 2025 07:29:37 -0700
Message-ID: <20250319143030.369125606@linuxfoundation.org>
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
index 62e71f56269d8..352c7a84cc2e8 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -751,6 +751,7 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 };
 
 static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
+	SND_PCI_QUIRK(0x1043, 0x1e13, "ASUS Zenbook S14", SOC_SDW_CODEC_MIC),
 	{}
 };
 
-- 
2.39.5



