Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79D837B3FD;
	Thu, 17 Sep 2026 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668562; cv=none; b=aKTDn1F7YAlcuj4KVKjS+wgfTpMFYpbjHXg/UUgoW6DD7P/4KAGRwrVjtg0Ym+0U6+vXXlMArnXOXV9mvxy65G21PB8vWjapbeQkb4FztaSckvU6h7yyz5UkE9lN0ieXpIIt8XLIInfLCiYm6pu1+2jkI6yxAT6qqITsMzTAqmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668562; c=relaxed/simple;
	bh=oVlF929xHviqP6JVS2M5NOTBLwnpLvBcF70iBxBatOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo8x6R7vJ7PI0d+Z0lVU2j/OFpyf9PPwIL3VEn+UXhM/UdNgMsp5d6uNAaEjn9Noegcgs7Ph5mUqqw6pCKy5RpwHeyC5TE7KbQpbQeTTWme5r8MakzrZxNCJjqeIp2znhZPhoc6kEPxPj2HWnCZScD9xxVXlaorrFqmrYkFZ4wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Afj5/4gu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Afj5/4gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146911F000FF;
	Thu, 17 Sep 2026 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668561;
	bh=WJsHI69/vH+RW6IXg1wBe2fi17HLUf6JiRFBICWp4H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Afj5/4guEfrGNg98678V63o+Ra2GAi1StbG29sm2ArBSi50iOZTGskvafcbFNzFFQ
	 GyajjC3YfvkUca8unDwkx0Nr39TbSsyTsNp9NoKMKf1oVJJ3UWFYyUkgfZDmOqSOFD
	 hkRHzp+D7l22LTGeh2xohLxJ7vPYai6KDgdOuFeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0416/1102] wifi: iwlwifi: mvm: fix an off-by-1 boundary check
Date: Thu, 17 Sep 2026 16:05:59 +0100
Message-ID: <20260917151550.110051398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d77aff138c9ec6c8562f4c2c9f262d3d9c4b4cb8 ]

Before looking at the 11th byte, check the length is big enough.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20260714141909.d22bf52a18d0.If0ef6612a67cca671428b06dbdeec68549e50ae6@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3fd257f770baa..0a1ba7a8f4562 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3616,7 +3616,7 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
-- 
2.53.0



