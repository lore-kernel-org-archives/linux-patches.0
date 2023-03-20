Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFAE1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F0FC433A4;
	Mon, 20 Mar 2023 15:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324489;
	bh=Elt/ux9plALmjFRZKJT4+VwOylzplvx0/RXwCyUM/Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWyvz5O9qfq59jXxZGPWBe6aH5cRf/mBSwf9UrrkKDIv4AO3HnTB+joHqae3w23GL
	 uR+2OfsRTG1iy4xSxLabCx1wH1FTEYWc6INbMrJF9WTjZ72hToa2QSbjAP8nrdKYgt
	 oIEbjzXKMjaEV3xT2MaDIUHFWCVkaK4bj0HE4EtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/60] ALSA: hda - controller is in GPU on the DG1
Date: Mon, 20 Mar 2023 15:54:19 +0100
Message-Id: <20230320145431.305904423@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 1bee263dfda57e45ad39c59a663c123a357ce38b ]

Add Intel DG1 to the CONTROLLER_IN_GPU list to ensure audio power is
requested whenever programming the controller.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200921141741.2983072-3-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: ff447886e675 ("ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index c0b8844a2d5bd..6a44ad513a965 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -366,7 +366,8 @@ enum {
 #define CONTROLLER_IN_GPU(pci) (((pci)->device == 0x0a0c) || \
 					((pci)->device == 0x0c0c) || \
 					((pci)->device == 0x0d0c) || \
-					((pci)->device == 0x160c))
+					((pci)->device == 0x160c) || \
+					((pci)->device == 0x490d))
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 #define IS_CFL(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0xa348)
-- 
2.39.2



