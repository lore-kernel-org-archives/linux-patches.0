Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2C64E0B66;
	Wed, 30 Sep 2026 16:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786215; cv=none; b=d/SogTiyiEwYOYOckGUWUSFyT1DFhjARAHwoGVCNMmZAuHmAapj7g96VkT7XavLtlHH9XeYkgiirnaF4KZZHaDP/P6eJZ9hhoFY+hbtiRp94Qx3F4zqMogdy9phxyPbWoEALSY5C7pcKtjpPzVtGiHsG7hyZ/4P1X5ON9nHOnbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786215; c=relaxed/simple;
	bh=1xZAXoOu73x+zq0+/IPEGvbTyj0alNiy8Qv7OPJKwv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQearRlpaFAVeuLDqz/XCJulwUIezwiVkRsv4MnbITEC0rNwPiTf4iEAJj/aijzR7Nl+bBHgcbxAjP3cAFEcLKjM17HVmDsr+Crydc5MFd1eXxpTlxZy276enzXdMLPGVQ5hX4M4noxXcKHAjF20uEepJb/5cXBqZpzUzyK5szo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3zQPidd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3zQPidd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0426D1F000FF;
	Wed, 30 Sep 2026 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786214;
	bh=filUbEVdXogIs54QZNmQbuhW/mHin3CP0UMzTnGNhnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3zQPidd97m+cEmGEfe5n7aYGsgdHRaKjkqlQx/IvlJV8hmoyrPomJnXTAA54VpJY
	 Ev5rDh76liymmQLIt1/HHVirtpZkeEi5rftmhJYewKxCO9pi5oioudLPDx+jNxCpIW
	 4sYxFDgTfJhRLw9IvtsKkoK2y+O7zS+svockIClY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 781/982] ASoC: SOF: avoid a NULL dereference with unsupported widgets
Date: Wed, 30 Sep 2026 17:25:17 +0200
Message-ID: <20260930152433.530866212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>

[ Upstream commit e3720f92e0237921da537e47a0b24e27899203f8 ]

If an IPC4 topology contains an unsupported widget, its .module_info
field won't be set, then sof_ipc4_route_setup() will cause a kernel
Oops trying to dereference it. Add a check for such cases.

Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230329113828.28562-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>

[ Backport to 6.1.y: although the upstream stable tag names 6.2, the
  same module_info dereference is present here; the source change is
  otherwise unchanged. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 49289932ba7e6..9540ba6ef659e 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1600,6 +1600,14 @@ static int sof_ipc4_route_setup(struct snd_sof_dev *sdev, struct snd_sof_route *
 	int dst_queue = 0;
 	int ret;
 
+	if (!src_fw_module || !sink_fw_module) {
+		/* The NULL module will print as "(efault)" */
+		dev_err(sdev->dev, "source %s or sink %s widget weren't set up properly\n",
+			src_fw_module->man4_module_entry.name,
+			sink_fw_module->man4_module_entry.name);
+		return -ENODEV;
+	}
+
 	dev_dbg(sdev->dev, "bind %s -> %s\n",
 		src_widget->widget->name, sink_widget->widget->name);
 
-- 
2.53.0



