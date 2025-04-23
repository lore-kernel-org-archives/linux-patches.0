Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2514B1A08A6;
	Wed, 23 Apr 2025 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420013; cv=none; b=Z1/AzVdg4PsvntuoKu+ZUexpr4H/5Ct8kYl9LqlcOcU0tj+WbVi4/1OmRpApPoOCpFL9wEMuxuz23sUvIcI/d+WxDyDDAHTpf2WlcvT2F8JdHSXH+m3rASjLYQRW+L5xbZzVhH2/WGHkXGkivWhcz5IXn7DJkyUw9/U50cuqfl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420013; c=relaxed/simple;
	bh=Mk5F4Snv8KFUR1KCfR8sd4xD3Fp5PEL+ELQ2HyxNz6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3xN1N6VwsT3XlgDpfHm+rW/QGZvfv21YN7v7JQU+XbS0cKAgvG4yeI0NQjGz0N65Ji3XC30PRm+DAgz9x2z5ACtNQV9IOEumvQUDH8YHGNi23Gxfqp0Ee9hmE/YX+lAd+/Ezs7hGugojt9BjfWyByN4FzxFGEXnZUWt8U9SZpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qL2YPyWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qL2YPyWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE5BC4CEE2;
	Wed, 23 Apr 2025 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420013;
	bh=Mk5F4Snv8KFUR1KCfR8sd4xD3Fp5PEL+ELQ2HyxNz6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qL2YPyWKpY7xQQdPsQ1djLoFpkqX2sMqlYVzoLl5lb4IKJ98moGN7QAKAHiCy4WQf
	 g/u4jxJP34pwjnua8HzlLERfci1bHUr/q5aKcDyUHXYslJlwL6zISNCYHUvVmyF2Sw
	 pi4XQJLWQ4EgtcpZAB+K1KaKp9gXRzwOE/tmJaE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 092/223] ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S16
Date: Wed, 23 Apr 2025 16:42:44 +0200
Message-ID: <20250423142620.868045754@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit dfcf3dde45df383f2695c3d3475fec153d2c7dbe upstream.

Asus laptops with sound PCI subsystem ID 1043:1f43 have the DMICs
connected to the host instead of the CS42L43 so need the
SOC_SDW_CODEC_MIC quirk.

Link: https://github.com/thesofproject/sof/issues/9930
Fixes: 084344970808 ("ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S14")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250404133213.4658-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_sdw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -688,6 +688,7 @@ static const struct dmi_system_id sof_sd
 
 static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e13, "ASUS Zenbook S14", SOC_SDW_CODEC_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1f43, "ASUS Zenbook S16", SOC_SDW_CODEC_MIC),
 	{}
 };
 


