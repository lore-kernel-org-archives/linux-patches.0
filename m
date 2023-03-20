Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B71C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF979C433EF;
	Mon, 20 Mar 2023 15:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324854;
	bh=sFh+slsaerm0TBFtv1wg/yGEi4mxAKvEZDoV0mTpmvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VeL/4MgbTwyFaufDEJV7NeBtF6GCWDwB7rSV3LO5eUuRGtX8jMSt6Oijv06byNmPx
	 uR/uYdUzlvf+5/2xFZQex7Dz0TWXX89ICfuVM5ObSGDGeBn91Lupf9aWvtWzJ9EmsU
	 MgbnCj1Yl4tzXj+OokvbCeF7M1IT6P7kLAjXzZR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaska Uimonen <jaska.uimonen@linux.intel.com>,
	Adrian Bonislawski <adrian.bonislawski@intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/198] ASoC: SOF: ipc4-topology: set dmic dai index from copier
Date: Mon, 20 Mar 2023 15:52:31 +0100
Message-Id: <20230320145508.045557908@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaska Uimonen <jaska.uimonen@linux.intel.com>

[ Upstream commit c99e48f4ce9b986ab7992ec7283a06dae875f668 ]

Dmic dai index was set incorrectly to bits 5-7, when it is actually using
just the lowest 3. Fix the macro for setting the bits.

Fixes: aa84ffb72158 ("ASoC: SOF: ipc4-topology: Add support for SSP/DMIC DAI's")
Signed-off-by: Jaska Uimonen <jaska.uimonen@linux.intel.com>
Reviewed-by: Adrian Bonislawski <adrian.bonislawski@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307110730.1995-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4-topology.h b/sound/soc/sof/ipc4-topology.h
index 0aa87a8add5d3..2363a7cc0b57d 100644
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -46,7 +46,7 @@
 #define SOF_IPC4_NODE_INDEX_INTEL_SSP(x) (((x) & 0xf) << 4)
 
 /* Node ID for DMIC type DAI copiers */
-#define SOF_IPC4_NODE_INDEX_INTEL_DMIC(x) (((x) & 0x7) << 5)
+#define SOF_IPC4_NODE_INDEX_INTEL_DMIC(x) ((x) & 0x7)
 
 #define SOF_IPC4_GAIN_ALL_CHANNELS_MASK 0xffffffff
 #define SOF_IPC4_VOL_ZERO_DB	0x7fffffff
-- 
2.39.2



