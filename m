Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC3F149E06;
	Tue, 25 Jun 2024 09:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308468; cv=none; b=sr9L3Oru8NeFbJLATyLRTREg6P/hOJxmA3e4J0d4YsZ6wSaskkjWIEh11rDTyBOxPQ/Gj/3NyNL391MkclGBOlqzognOc6SfT+lI35GdRSYCqEWMvonC71E3THt8Bj7511Nn1YXa78bvLlAyFEJjpQJKrZz9uKTKXKyzo3zfgJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308468; c=relaxed/simple;
	bh=N6V/By3+5ttAiDaVlEJM7/c7bUEtfwSByHL1eEc6Hns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOWfhSA9Q2HB1D4PZTyutCyyj8aH6w+8LOmCXEI9j+qOHIAL5pAXJNQOYXESHlG7iwDwQcqO8kwtb0EViDofixVRHIf5tPI+C3pu51cbjImuS8FSgsCYEqzxV8ph8Vao1Diz3B5AEUEHNnfO2dGcaI7DSvc2AUy/GqT8uLhNzCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKI/n2ZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKI/n2ZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0445EC32781;
	Tue, 25 Jun 2024 09:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308468;
	bh=N6V/By3+5ttAiDaVlEJM7/c7bUEtfwSByHL1eEc6Hns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKI/n2ZH4GY7NqzJGwOpAVKQBL3/VC92B/Dr//39VcFAGAEg05/XY6FBeUy1aEzEO
	 qaB+a1VxJ4AcAoAGiTdYdg3D1DBDLoKkLWelTN8Xu/z8DBQypaiKORJONcHU2sPazy
	 l3Nk3UH4JRIOpx/CZyslke8y7JfJVlQjBnjDm+1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaul Triebitz <shaul.triebitz@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 100/250] wifi: iwlwifi: mvm: fix ROC version check
Date: Tue, 25 Jun 2024 11:30:58 +0200
Message-ID: <20240625085551.908727425@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaul Triebitz <shaul.triebitz@intel.com>

[ Upstream commit 4c2bed6042fb6aca1d1d4f291f85461b1d5ac08c ]

For using the ROC command, check that the ROC version
is *greater or equal* to 3, rather than *equal* to 3.
The ROC version was added to the TLV starting from
version 3.

Fixes: 67ac248e4db0 ("wifi: iwlwifi: mvm: implement ROC version 3")
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240605140327.93d86cd188ad.Iceadef5a2f3cfa4a127e94a0405eba8342ec89c1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 2403ac2fcdc3b..5f6b16d3fc8a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4643,7 +4643,7 @@ static int iwl_mvm_roc_station(struct iwl_mvm *mvm,
 
 	if (fw_ver == IWL_FW_CMD_VER_UNKNOWN) {
 		ret = iwl_mvm_send_aux_roc_cmd(mvm, channel, vif, duration);
-	} else if (fw_ver == 3) {
+	} else if (fw_ver >= 3) {
 		ret = iwl_mvm_roc_add_cmd(mvm, channel, vif, duration,
 					  ROC_ACTIVITY_HOTSPOT);
 	} else {
-- 
2.43.0



