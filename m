Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084D9313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301037; cv=none; b=NVbaSrPfXKmH++CT9v2DQujY15RGh3gLU7j6iYoHLoHN10cjXvwqv9DEdJ05cfDvx0DZapo0qIjbQrNC2AQ7dwyNde1T0hpX/KRLqC4AtgbyHXKuUdo04EFCanNcH4Jum3xPycqmGNLIXyzksMnB+avg8h1L29N8CsaV6JH6RCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301037; c=relaxed/simple;
	bh=uGDpzHTtUaNXSXJoe1MY35FQKaWKiROdHYsRyK59aN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uwi/6bt+i6verjoh5wjqIYQqQ4RyV+lqeO/twMlHUBGGbY8M5PJaDvzpKfS4vnW/fV3+byyzkTo0P803RNTwgA54D47ldyycDQjI3Q8SQU1xpwgkpcV9h3afAV1U5EpnRQIW/doW1K4dtzOq3Q1tsOJXa01C2vzn86GXRbnA9+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GOcyBbGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOcyBbGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C934BC19423;
	Sat, 28 Feb 2026 17:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301036;
	bh=uGDpzHTtUaNXSXJoe1MY35FQKaWKiROdHYsRyK59aN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOcyBbGoZSXTm4XNJ3erZgO06Hw3A1M0WQgrD/B7my7ozjLGmTW5GVqhhR+C0Oux1
	 yGLwd47HKKY2qOJnuMfRvuIXRyYVA6VJwTxb1C+zdxMQ9zbyZ41r3buX0Mu6OloQ0m
	 PHjsyI/zbY/Qxanf3qILF9UEqmeIM21HnZ0RK1qOY33bJ/vNIx27yvDjWnUYNk46bC
	 H5AamgfMLeZ/WEAmExkB7dggIT3VaMJy9PLrbT0qFhSk48HvUOmaLmZ0CJdTCix/mY
	 rLuD5Yf/JMp+c1ksP0mz1i7A8dev/nvzPn17+6VWZzG/qLZlZ1wAi//cpzd7n2C/Cz
	 R3U7ZIgsB6Gbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/752] PCI: Add Intel Nova Lake audio Device ID
Date: Sat, 28 Feb 2026 12:38:05 -0500
Message-ID: <20260228174750.1542406-174-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit b190870e0e0cfb375c0d4da02761c32083f3644d ]

Add Nova Lake (NVL) audio Device ID

The ID will be used by HDA legacy, SOF audio stack and the driver
to determine which audio stack should be used (intel-dsp-config).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260120193507.14019-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 92ffc4373f6de..03b7c0380f71c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3142,6 +3142,7 @@
 #define PCI_DEVICE_ID_INTEL_HDA_CML_S	0xa3f0
 #define PCI_DEVICE_ID_INTEL_HDA_LNL_P	0xa828
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
+#define PCI_DEVICE_ID_INTEL_HDA_NVL	0xd328
 #define PCI_DEVICE_ID_INTEL_HDA_BMG	0xe2f7
 #define PCI_DEVICE_ID_INTEL_HDA_PTL_H	0xe328
 #define PCI_DEVICE_ID_INTEL_HDA_PTL	0xe428
-- 
2.51.0

