Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C3B646;
	Wed,  6 Nov 2024 13:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899318; cv=none; b=KrWAQZA5I6O/81dBo+etfa84VuDI2EQXsY4zqqFF5UH0ohRUk7P+ftCpfT5SdZCqWFxEGUHW69/1PQCL/xKk9i9+3CpW8UYbkFKJCP6H6aVCQjL3i3Dq8k3uFfFU7cdJfn2P+sNcIp3eojtPr+d3fi3YOYyQGsOlHgVYiHyjauQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899318; c=relaxed/simple;
	bh=QBf4813nqcknb/VY2H9YTEQO8wejSbmdP1zc9V6FvWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/4O8Ok3JVG500lJUONoVP0TzZug6mypZ9qvpg0x1zj0nEISWqtqSD2qHpQ3waMOV9fQwl07n9rO6pdknGfb/4Q5g2QZWXmVFOGYkRbwJsG7D6MlKHiDG1MzGlAYl1NM5Yuv4vG1xiv682fLDPCVUK5HJGWX2chjJtBUD0QyHGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNqFhpNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNqFhpNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D1BC4CECD;
	Wed,  6 Nov 2024 13:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899318;
	bh=QBf4813nqcknb/VY2H9YTEQO8wejSbmdP1zc9V6FvWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNqFhpNCyg4GN9VXupW6EF9UExWxTwXfcUn+zKcAhHkvCX5MSx+nQaXSjkBwUUgSX
	 VhVKSGGD/SibAp2bugeN0kyO+hRzU7KwXYUyNWXlt3g8quWYyIJSALfXaNRAbbf75F
	 kzQaunrJQ+bkT1cDHrjIGaUXasEb7OqO2yd4t57M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 73/73] mac80211: always have ieee80211_sta_restart()
Date: Wed,  6 Nov 2024 13:06:17 +0100
Message-ID: <20241106120302.119349911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4832,6 +4832,7 @@ void ieee80211_mgd_quiesce(struct ieee80
 
 	sdata_unlock(sdata);
 }
+#endif
 
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
@@ -4867,7 +4868,6 @@ void ieee80211_sta_restart(struct ieee80
 
 	sdata_unlock(sdata);
 }
-#endif
 
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)


