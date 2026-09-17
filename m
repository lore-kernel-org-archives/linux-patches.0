Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32F14F391E;
	Thu, 17 Sep 2026 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664898; cv=none; b=ogtS56Dt0XXKqmuJpQ+3QC7GCBcnPlt1xl9izOOyKmPNqcs+pNnjqmMMxpj3NNb3KQeQTfAd6AYMoGUU+7mnxQnG+oKY8BBM4pO2dZuYF6g56GHew1d1ovbZUV4uxu0h8SDAyV4wV6GQ90ysebe6aDdhQgT7SptM//LsI9xmTrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664898; c=relaxed/simple;
	bh=VClwqOXfCbYvCUyg4O71VIRaUF6jTv4BCttkK20G8Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo3xwCI84dXxS6B47fWGCMduUg3s4d3ju0tR5+SjK1B4hhaC8vNZRjZBRuQH/hx4KTMFN0hXUCPO7s6KmAc0fRbPMnwZHZtDzEQE0IFvQ2GwM4WL89X5GWxITA4oFBJqTC6116YMPehTerWhGryOGdKOJjBo4fkLBH30Z2SGMjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W22orOg1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W22orOg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CA21F000FF;
	Thu, 17 Sep 2026 17:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664897;
	bh=gZLCggHEB1NsZaUYmtQk8bOBlWzjiNMqUsQrr3/Y+po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W22orOg1X1Kz/ANyQSE0Yt/QUX0fWogzTgd6b73EH9LLBWOpo2LrsDF8PyqQdiCkT
	 IJoS1Naj6QhiZZBcu7epDj6xWv6zHAAzX25P61D9SJe9p2hjzOe059CKySkwLC7VZ0
	 zRFSjdGiyEai0+fMLzR8Bq+5/VFw6kRw5UETiZHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0526/1250] ASoC: Intel: sof_sdw: Add quirks for new Dell laptops
Date: Thu, 17 Sep 2026 16:05:21 +0100
Message-ID: <20260917151606.201682877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit efd80de2de9d06ddf0eee55ca11b04e39bfc7cd8 ]

A couple of new Dell laptops are shipping using the sidecar amp
configuration. Add the required kernel quirk to enable.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260716144209.2411523-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index c9f4fe84c7eed..ffa6e2ad73f75 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -805,6 +805,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 };
 
 static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
+	SND_PCI_QUIRK(0x1028, 0x0e53, "Dell XPS WCL", SOC_SDW_SIDECAR_AMPS),
+	SND_PCI_QUIRK(0x1028, 0x0e54, "Dell XPS PTL", SOC_SDW_SIDECAR_AMPS),
 	SND_PCI_QUIRK(0x1043, 0x1e13, "ASUS Zenbook S14", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1f43, "ASUS Zenbook S16", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x2347, "Lenovo P16", SOC_SDW_CODEC_MIC),
-- 
2.53.0



