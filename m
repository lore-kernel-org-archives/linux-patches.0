Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C769E37A4AA;
	Wed, 21 Jan 2026 18:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020055; cv=none; b=mmoE9JIrLUp1DYNV9WOx6IBgP1yFU0sCFXSF39PAyHaVmcKRKQjO93cu9XQ1BY3JKyeHuL2zJftnjCWzMhW4mHJcNneClNzeKm3t/8op46FZN26UR9KPGrvRzimM+SLX3EFNxv29ptSNwzaE4VGGImKn3a7MxVqMoaU/Qo/+H2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020055; c=relaxed/simple;
	bh=bvlxSOopSC4lkQ+T0Zr6hrRjWbQiJeo+iehekZsdbHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVMNPkryBNW0UeMlSd4uI+DU3zGWCXcl0XvKUVFgEhC1eql5qNctAmRSyfzbglSB3PX4ToOTBYFGAG6FMXcK6RM6B1zcEE2L5VJ8D70FjIjMsI7+p7/i2aYk3Qxv9xMvHSEWcpjzjEQIwrd6+r+ijbIfaOnPa1z3ndzHFMITD5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=be2YtP21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="be2YtP21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33864C4CEF1;
	Wed, 21 Jan 2026 18:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020055;
	bh=bvlxSOopSC4lkQ+T0Zr6hrRjWbQiJeo+iehekZsdbHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=be2YtP21UC27sNqQCmV+/csqQDGeRqKNIPR/ZA/Yp+UMR8KiLesG6sugBe1lPtZM9
	 EnAJ3Jfuxtc6FLPpKRljcSjkJtsCwzLtH9vl2oxnQDKeaeUbcxJlratTffWkdVCWkA
	 jbuizgnZ8IO9A18AHCTwEr3DuIPr4aYJoK0vrZzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/198] net: airoha: Fix typo in airoha_ppe_setup_tc_block_cb definition
Date: Wed, 21 Jan 2026 19:14:35 +0100
Message-ID: <20260121181420.243543659@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit dfdf774656205515b2d6ad94fce63c7ccbe92d91 ]

Fix Typo in airoha_ppe_dev_setup_tc_block_cb routine definition when
CONFIG_NET_AIROHA is not enabled.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601090517.Fj6v501r-lkp@intel.com/
Fixes: f45fc18b6de04 ("net: airoha: Add airoha_ppe_dev struct definition")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260109-airoha_ppe_dev_setup_tc_block_cb-typo-v1-1-282e8834a9f9@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/airoha/airoha_offload.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/soc/airoha/airoha_offload.h b/include/linux/soc/airoha/airoha_offload.h
index 1a33f846afafa..0e82f1f4d36c4 100644
--- a/include/linux/soc/airoha/airoha_offload.h
+++ b/include/linux/soc/airoha/airoha_offload.h
@@ -51,8 +51,8 @@ static inline void airoha_ppe_put_dev(struct airoha_ppe_dev *dev)
 {
 }
 
-static inline int airoha_ppe_setup_tc_block_cb(struct airoha_ppe_dev *dev,
-					       void *type_data)
+static inline int airoha_ppe_dev_setup_tc_block_cb(struct airoha_ppe_dev *dev,
+						   void *type_data)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.51.0



