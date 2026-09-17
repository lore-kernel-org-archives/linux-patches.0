Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B02150B8DA;
	Thu, 17 Sep 2026 16:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664077; cv=none; b=OrysvOAxHSRmNSAUhcSK11jpL7tVibOh5Nlm9blTuewD/wQIjqnXj7jLZhOMLEG2fNk+/iiOmPxujsbCD06nCaYtjn+ttPJG42OZ8hh0E3k4q7VU2ORwnLoP4Vt7A46mvKcxY0o12oWkjASlQAC6lfGoDJfGF2AGgV9kvQ2KTao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664077; c=relaxed/simple;
	bh=MWxePA41ZHERA/O8h96PI4jnSXIvb8gHaKVV2lI8/dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opnumKcdoBcOtvYRIsvIbEFpxYZGh5h+RziPr734+AEj5nVbxj+Pb77AjoEDBfvf76za9LUcpT0mVRPr1LVLkRCL9Vmdvn341qUkO6/M/DQv7eYAKNnSYDVThd7OnxQeOQ9Wqlsi1Xdmo8LYuRWY+tbkCDOIqPoCxvGdPeHGyAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1d9CqX1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1d9CqX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D24B1F000FF;
	Thu, 17 Sep 2026 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664075;
	bh=JJkd7IoSrdw3pQqDO1pGBulBkgct7lgUmwScvNzM/gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1d9CqX1ImzHUKgJcInhko0wnB+022PNolRCGPgxvAcF9MrMbO1ubkf4ReWGmjC40
	 SW8unVsoKawGL5LXXeTJ64GK5Gge/DTGoZ6X6IE09WTFzq/F+FS/U366ZGT4lrA7K3
	 aOVoqleh/DBNk5UwBXTHGXE7FJCaQKUt8AgGV7bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0214/1250] wifi: iwlwifi: mld: call iwl_mld_free_ap_early_key() for AP only
Date: Thu, 17 Sep 2026 16:00:09 +0100
Message-ID: <20260917151557.931179166@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit c35c44434329c6b3bd2c6c1e5add5ae10d933a4d ]

The driver supports intalling IGTK on a NAN device interface. When
the IGTK is removed, iwl_mld_free_ap_early_key() is called which
results in a warning since no links are attached to this interface.
The iwl_mld_free_ap_early_key() function should be called for AP or
IBSS interfaces only. Check the interface type before calling it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Link: https://patch.msgid.link/20260512222731.d67d658b421d.Ife2d1f3b17119ce696582ce6a2a69026d368d8af@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 322669d78b193..27ae06e208402 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2164,7 +2164,9 @@ static void iwl_mld_set_key_remove(struct iwl_mld *mld,
 	}
 
 	/* if this key was stored to be added later to the FW - free it here */
-	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
+	    (vif->type == NL80211_IFTYPE_AP ||
+	     vif->type == NL80211_IFTYPE_ADHOC))
 		iwl_mld_free_ap_early_key(mld, key, mld_vif);
 
 	/* We already removed it */
-- 
2.53.0



