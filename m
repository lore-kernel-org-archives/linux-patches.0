Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11BE1DED7C;
	Wed,  6 Nov 2024 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899103; cv=none; b=ebnDIPM0A+5UBUH31LxbYAJrZGgs+k568ltb1N4bNuZ0Y6j+H7DnbOpYyaywFoEfggV1AoT3uSYi189xW1FgabK737smzaquETpN4fJHq0fe9SVANIJosqmSLPqkDl5qoeomIieozgQLHsy31NhOz6xjd43NfNWolTq11GnKI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899103; c=relaxed/simple;
	bh=ExSeAd+C7zMMX5S/1qPo/ibgPWMKWQg52bKBWoOrVl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koHfMgma/ZwQA6Q/uZ0fZVScP3ZN/9BshtjsSRSkpt0nhRVlIGEbFestXBoBH5KvWHMWysLwBqVFfghZeWQBK09IvpsVbyTfuJBUqgVjYsFkQM8IXMKiYIOlaWSQm4py0jvHWQzj3vUmu8xMMnEOqEyt3nOrRIJ94iPkW9Y0XgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qt3hUWby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qt3hUWby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37735C4CED3;
	Wed,  6 Nov 2024 13:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899102;
	bh=ExSeAd+C7zMMX5S/1qPo/ibgPWMKWQg52bKBWoOrVl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qt3hUWbyr5deD1cy0PIOYot5Jt8nKfXk5KxFSBqu0YpcAA9FV8fptXFqmZKOccE7H
	 Hw5WAYDBw/1M1OUqMErvHAi64PxiH4BZNrXdRYv0jEcjg/DvXQmcIIZctlGbEKVFQV
	 mngN24SKo9b0Zrvp8IAi9GcV+/h18bQSCksLizTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 461/462] mac80211: always have ieee80211_sta_restart()
Date: Wed,  6 Nov 2024 13:05:54 +0100
Message-ID: <20241106120342.891262425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4563,6 +4563,7 @@ void ieee80211_mgd_quiesce(struct ieee80
 
 	sdata_unlock(sdata);
 }
+#endif
 
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
@@ -4598,7 +4599,6 @@ void ieee80211_sta_restart(struct ieee80
 
 	sdata_unlock(sdata);
 }
-#endif
 
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)


