Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10485339B3D;
	Wed, 30 Sep 2026 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791166; cv=none; b=RDukmcVEFi4USdcPkvlB1w2qrJb6e5pwbDSXNzedIAzqXv3GlaNtLd4XcBJtq7CBGCL0nMqpVUjo6/wn1ZOMPqU2uKW6KKfjbn59ZqVNktcSoocn+EN9RgL9vOeeIlBlWJgfxYvj+Ln0XDalEf3waO4buqJS4DHOtsbLFb3oghk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791166; c=relaxed/simple;
	bh=DWfj8MsIMWrYeJjtvpeyLEs3PD2mgtBGjymAhEBRo+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewNQDYIogmn//0Gweh/vIBkIwRgR7DV9XdEen++eLmBq2YPZED3rwq+ZE4z8W1gpWF/I1QMNvpIQxL7uXAW965QJLDt3xOw9VcCztiZZtrf1gSSfwwSsAK+ZE+VkXfg7SpYHf6bRrao3mIKPmxlkD8ezfZTvmmxsIrsrXsTO6us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKQg2hvt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKQg2hvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D13F1F000FF;
	Wed, 30 Sep 2026 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791165;
	bh=3CuIlKKWynQ83ZrniCYQ81f/EcganbU2yg7MPfLluqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKQg2hvtWVhz5wfctnr/MrvgK1z8VUvnypBaIQ0lvs8TI7ABLVMymPS+psuc9KG38
	 buhEFg06ENsbkri0ykEQcwTOxYWDhSrnQIgPYIdUasQq4nDEyjg6uUXFA3Xb+M5bFc
	 Sl55N3eu0YbO+MuzBROjeMbksKZujmdi1uvoodZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/752] wifi: iwlwifi: mvm: fix an off-by-1 boundary check
Date: Wed, 30 Sep 2026 17:21:16 +0200
Message-ID: <20260930152402.686899674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0e2841fc84dcd..080ce8e4e2439 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3039,7 +3039,7 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
-- 
2.53.0



