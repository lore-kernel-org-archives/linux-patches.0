Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA3D17B515;
	Fri, 27 Sep 2024 12:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440128; cv=none; b=DnlOZvdcPMyN5cxLiPRupJhlui3pn4J3VwnvDBltSEJmiRKBr133XXRR3XmOYUUGo64BMTpcDYvj9gV96Y8tLakEdMpUfxcdNoipBPVmHRGPaEQSWX2ReiVzI7so+n26szbRz3JKKUXaOOOnt511kTTFw6+WdxDostjAdY/IGiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440128; c=relaxed/simple;
	bh=/g4y7/Pjp7PWstRcHvvy3Jg/PXmXLiqCp1CE/hApKKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trlhC7tA/kxTcjkMcRmwCnKHpdX9CeRIJgyCk9Drid2t5az7GDaU0r4gn1wmnBoANF2fVjpXgu5e7yKRVN215GNGKjylTucljV71EVs+wEkUwPlSf64WLxoAjcGsgOL/91ZKxWhBlFYebooZToHFAPO4A1DeyQZ+uRN+kIO8nCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Il+gPFix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Il+gPFix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DA3C4CEC4;
	Fri, 27 Sep 2024 12:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440128;
	bh=/g4y7/Pjp7PWstRcHvvy3Jg/PXmXLiqCp1CE/hApKKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Il+gPFix6JOco6oeAnN20SbPLoiRtH4KQ0ZDJ7iPT2ypJ7dJ/vrUDyhNTc+vGkhk4
	 Q3nItFxpnmBZlqYdKj2aZS3OJw+qPEz7OyghrA2gHsnD7pSFm2/urXB8otq2MyiqZy
	 zysu/r5mJmtsfBBtg65xX5EZnfyh8k8gvaX1aC1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 42/58] drm/amd/pm: fix the pp_dpm_pcie issue on smu v14.0.2/3
Date: Fri, 27 Sep 2024 14:23:44 +0200
Message-ID: <20240927121720.466316940@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 7a0982523cf3ff00f35b210fc3405c528a2ce7af ]

fix the pp_dpm_pcie issue on smu v14.0.2/3 as below:
0: 2.5GT/s, x4 250Mhz
1: 8.0GT/s, x4 616Mhz *
2: 8.0GT/s, x4 1143Mhz *
the middle level can be removed since it is always skipped on
smu v14.0.2/3

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fedf6db3ea9dc5eda0b78cfbbb8f7a88b97e5b24)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
index 06b65159f7b4a..33c7740dd50a7 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -672,6 +672,9 @@ static int smu_v14_0_2_set_default_dpm_table(struct smu_context *smu)
 		pcie_table->clk_freq[pcie_table->num_of_link_levels] =
 					skutable->LclkFreq[link_level];
 		pcie_table->num_of_link_levels++;
+
+		if (link_level == 0)
+			link_level++;
 	}
 
 	return 0;
-- 
2.43.0



