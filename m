Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F90554903;
	Tue, 14 May 2024 11:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684606; cv=none; b=j4otSMVBWeOd2ImR3/tQLzpfD9tyh/R1gQoXUQ07B6XomjFu8WowYR9LFVrePyHEbY/q8GL1E41o2a4Jreql8hht96skcSCyqcHAy8g1MJ8bz09pi/+Nndp83lTxyv3NvDhykJJ+2NAykyc3Pj4xb44SxQ/kfO5hNWyaRF+/CI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684606; c=relaxed/simple;
	bh=m23gEuw4VWWoBhThmQzq1fvfG7nuXmLROn1swzXW4L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlqQGaiLNd02WC+r1wtZfDCKjwFKJEOP2ZHbMYj3iPik5MMl1d9lPnTf852r2HCBPReVFSciRby0lxP3otUNUTZeoNrPTdub/+1XSWBdL/zR5ttg51zaXboEh4ZwSXNki0rlsa4/GMwe2d8+B031xvD02FKNfrs4nheQuUkM2Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJDCdTRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJDCdTRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1849C2BD10;
	Tue, 14 May 2024 11:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684606;
	bh=m23gEuw4VWWoBhThmQzq1fvfG7nuXmLROn1swzXW4L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJDCdTRbtPTBka773KaCy8p9r4y7uAd6RYK9/wNl1uC97oog/JWKaS4V5/6O5OsC7
	 Xh0RcG2bX9IQOZ990iFibIobykKh9TT616DOtRqIbKEC68hLFnD8HpnEDchHVLeiXI
	 FpjketDJ1FSYw0cguvbAtOnzSFNBzQ9Z8apUWVXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Rander Wang <rander.wang@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/301] ASoC: SOF: Introduce generic names for IPC types
Date: Tue, 14 May 2024 12:15:02 +0200
Message-ID: <20240514101033.422193214@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 6974f2cd2fa94fef663133af23722cf607853e22 ]

Change the enum names for the IPC types to be more descriptive and drop
tying the IPC4 to Intel SoCs.

Add defines to avoid build breakage while the related code is
modified to use the new enum names.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230919104226.32239-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 305539a25a1c ("ASoC: SOF: Intel: add default firmware library path for LNL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sof.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/sound/sof.h b/include/sound/sof.h
index 51294f2ba302c..31121c6df0272 100644
--- a/include/sound/sof.h
+++ b/include/sound/sof.h
@@ -52,11 +52,14 @@ enum sof_dsp_power_states {
 
 /* Definitions for multiple IPCs */
 enum sof_ipc_type {
-	SOF_IPC,
-	SOF_INTEL_IPC4,
+	SOF_IPC_TYPE_3,
+	SOF_IPC_TYPE_4,
 	SOF_IPC_TYPE_COUNT
 };
 
+#define SOF_IPC		SOF_IPC_TYPE_3
+#define SOF_INTEL_IPC4	SOF_IPC_TYPE_4
+
 /*
  * SOF Platform data.
  */
-- 
2.43.0



