Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B851F668F;
	Wed,  6 Nov 2024 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896921; cv=none; b=Ewhuslyha+wmA0ZLeUxFMCvBi09j9PbVasI/X6vFwwnpmWbLScWpA/pFkpZfFEWfQTbl2Jhdv61rVzuD8ocEmYU3S8/rBfUVemYAYarS/7uHiifpIBTmXdRsoDusb7pBF3fnGgiQMxvv2Sn5miB8VAvY42o2V1it1gm3Cl0oYPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896921; c=relaxed/simple;
	bh=uzRX11l09FSG1dhyM/tmmVCiU90sEleZxSy36NSsW1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQzL8f1JRhqy5j+W25nsBgi3NMmhzRIMWB11EhH/EszpA2e7vkD6m2cPNunG3pLoliIDtyida7+BM22VxqSOZLvcBBJy0R0pyCBcOYB/mUh4snnGfg1eJ+/u86n/dOi+DAloSdHvBnmESKUTNWrOfo0CKzrKqzM3j0q3FFCeLig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qj45aDPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qj45aDPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B831C4CECD;
	Wed,  6 Nov 2024 12:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896921;
	bh=uzRX11l09FSG1dhyM/tmmVCiU90sEleZxSy36NSsW1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qj45aDPDwnuT8G13xSTfg3a4ahz/DwBBYJdszf9gPwNnRz3K8Upfy8+2acU8ON8Ly
	 0k7P0ALC7JYb53hw+yahBF/6sXH9arfsWNfv27qDqRWugqrmp5V3+tQIauS3FVL9k9
	 K2zszqWBPBqLftmjzFCw/bu2Jb7HhVRDWjcXeGyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 110/110] mac80211: always have ieee80211_sta_restart()
Date: Wed,  6 Nov 2024 13:05:16 +0100
Message-ID: <20241106120306.219229076@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 3fa5a0f5b0d69e31c6476cd81afeca3cc25a4927 upstream.

When CONFIG_PM isn't defined we don't have the function
ieee80211_sta_restart() compiled in, but we always need
it now for firmware restart. Move it out of the ifdef.

Fixes: 7d352ccf1e99 ("mac80211: Add support to trigger sta disconnect on hardware restart")
Link: https://lore.kernel.org/r/20220312221957.1fa96c72db51.I8ecaa5f9402fede0272161e0531ab930b97fba3e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4778,6 +4778,7 @@ void ieee80211_mgd_quiesce(struct ieee80
 
 	sdata_unlock(sdata);
 }
+#endif
 
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
@@ -4813,7 +4814,6 @@ void ieee80211_sta_restart(struct ieee80
 
 	sdata_unlock(sdata);
 }
-#endif
 
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)


