Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C14A27FD49;
	Tue, 27 May 2025 17:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365911; cv=none; b=oIJ66qO6rngtutPed16Czikzw1RhctB+Edc5ZVP2HeYwG+kPJp1D+hn+NFISOOTzirwmzXzji3AyzAlcSGniD/xE/dGuv8UTJqT63D/Lzpn0MgxAo55KyqKTvEzKrEMp3QAlhribHld2DsTW7xXJXJF/78q91/RwTUXsHeu1OFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365911; c=relaxed/simple;
	bh=Oe7FzaDLlT/rzBxGGPmFMUC2JxzycPwgsBJSKGoKRTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWliH7gTATlL/28iDkOTaGbwo/WyfBf0E+ne5hjh3LuD/oqz5VqTSfg3/N4lcr2h1EBtBr2xVAcPPTtz9wrkyvPy2QNbwh38LIAQAHFKFtlSki+ZnAr/yb2tdRgJJsmPgVgxHC/vYeibE4ykB/F3SyRyld799PYqNHHyQHSsWsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMFnZVfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMFnZVfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980CDC4CEE9;
	Tue, 27 May 2025 17:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365911;
	bh=Oe7FzaDLlT/rzBxGGPmFMUC2JxzycPwgsBJSKGoKRTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMFnZVfL6UzszEXpwyTTltFBNBzOzFtX7ivSchvu/kjWYhjQbntvY0x8i1H5IBceA
	 dKNtL+PJ5N/J2hIV0mAjyh8UwIIX0IPEh+vsBArr1MqSHsPURn8B7WnDHCU4RjQILG
	 ynswlz+ztPywMpwVzngOVO81RfPZmDBr86itKMdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 529/626] wifi: iwlwifi: add support for Killer on MTL
Date: Tue, 27 May 2025 18:27:02 +0200
Message-ID: <20250527162506.486887607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 9141ea57abfce..68989d183e82a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -587,6 +587,8 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x7A70, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
 	IWL_DEV_INFO(0x7AF0, 0x1691, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690s_name),
 	IWL_DEV_INFO(0x7AF0, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
+	IWL_DEV_INFO(0x7F70, 0x1691, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690s_name),
+	IWL_DEV_INFO(0x7F70, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
 
 	IWL_DEV_INFO(0x271C, 0x0214, iwl9260_2ac_cfg, iwl9260_1_name),
 	IWL_DEV_INFO(0x7E40, 0x1691, iwl_cfg_ma, iwl_ax411_killer_1690s_name),
-- 
2.39.5



