Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06FE238C06;
	Mon,  2 Jun 2025 14:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874012; cv=none; b=CgYLi9WmmHMlzE5RmMNbVSRA04hkS/gScyxww+bEcyh9zFFEDYooojrzwN4KvcY1t0LbMT3rQgKNZQ9N0S1DryYDp1jWXIO7nMWKJ/MaprhkSXjNCkffNhilc2zOsS8fylCGI+2CxKfJDW9x2Iy78J9DFyqCON8GPuWeT4cN//4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874012; c=relaxed/simple;
	bh=NJ5Id5A87l1Jiitzv0URgDPyMadpmLMlveAM2DMR/iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXd9NbNN13KZ3ocMexyX349yFJJHhHkZihoIzx2AwAAVIfQwuCDuu00CG5KmEKoluvKj95kp3MAwWfCbYNz7+diDQE3MmulKEO1RSvzaQNUGFXJdGYtyLQOYATQuLDQNAhv5tn4S5Uk/Vh6PeNyjLkzaFoxIYZEOKlAeacAS28w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6fUssOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6fUssOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89A3C4CEEB;
	Mon,  2 Jun 2025 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874012;
	bh=NJ5Id5A87l1Jiitzv0URgDPyMadpmLMlveAM2DMR/iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6fUssOU1RNDgj+R/nMDANLOWM6sywGp+Ss0t6Ipb+gBZao/bfC33crNx1d8Lu8TE
	 xXdDtV0r0Pm1dmJOJ6IRyagv3Jh2pdRuUxlD8Vruu9mUbtGlNtGJwORmPHiSWcvLBi
	 ttowgM1NMoT6k17s5hgDIF7Xip8KiYomRKqVRi4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 327/444] wifi: iwlwifi: add support for Killer on MTL
Date: Mon,  2 Jun 2025 15:46:31 +0200
Message-ID: <20250602134354.215227591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ebedf8b7f05b9c886d68d63025db8d1b12343157 ]

For now, we need another entry for these devices, this
will be changed completely for 6.16.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219926
Link: https://patch.msgid.link/20250506214258.2efbdc9e9a82.I31915ec252bd1c74bd53b89a0e214e42a74b6f2e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 4a2de79f2e864..c01a9a6f06a4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -580,6 +580,8 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x7A70, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
 	IWL_DEV_INFO(0x7AF0, 0x1691, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690s_name),
 	IWL_DEV_INFO(0x7AF0, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
+	IWL_DEV_INFO(0x7F70, 0x1691, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690s_name),
+	IWL_DEV_INFO(0x7F70, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
 
 	IWL_DEV_INFO(0x271C, 0x0214, iwl9260_2ac_cfg, iwl9260_1_name),
 	IWL_DEV_INFO(0x7E40, 0x1691, iwl_cfg_ma, iwl_ax411_killer_1690s_name),
-- 
2.39.5



