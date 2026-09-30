Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15749501F2D;
	Wed, 30 Sep 2026 15:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782906; cv=none; b=tdo7kP1FO5JiNjqTJRK2JrVudCOnA8dzrQL71aHUb2ZBi/+AyUBmnpzZXCDx4rgB7RMWWOXNMbwv1T87KWmqBoL0IWXIYybKSin2AdbPQUD6ZcaSxRpykDdTpGYl7qA1A4qUOURvwMRP2wcbTmfp0jNDCDPOklhU93dW4brPWB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782906; c=relaxed/simple;
	bh=qMWcTc4GPwbdJotgP5QbdM/hDluuyeOvFTeg4MFIW8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvXrIYs67TVRwdXDIAr17ytbqDNgGXOwr4KUdIjtPK2kubdrlvu1B2uV94bbl/fRr/9+CDtXnaCE39oe9eZCcqV78z7X7xLPtsKK0XOGFElZvO+3PBf/xoorzQJ1ZzVrbr39EM2bFutTlt/gwB2G7+8obUa1vO0Ot0JO9CiHkVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Illdy9hQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Illdy9hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47401F00893;
	Wed, 30 Sep 2026 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782902;
	bh=EV1qw3ojOmtjPEOMhtlhgIywzwXUuQBB4Bymbr1NYHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Illdy9hQfSLCvr/h80wz6UN3DxXtvRzQzl0OzH7n/ToRfIm0Y9lOqiHiYNCvFlXlK
	 6ZFDPvCa1h7FH4WcTIj+jdvzID/EZO46Zk79tnrCpif/9A0C03g+BiWNwiURN1C9Ev
	 mzNkJgMNsYaUEwM1UOpX7gfmYKxrNKjddQxUIROk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/595] wifi: iwlwifi: mvm: fix an off-by-1 boundary check
Date: Wed, 30 Sep 2026 17:20:58 +0200
Message-ID: <20260930152351.286836666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fa784d8352901..56a174b2eb76d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3075,7 +3075,7 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
-- 
2.53.0



