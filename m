Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9071D3BC68E;
	Wed, 30 Sep 2026 18:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794712; cv=none; b=pFnwaECP1xEJW35IF5zIclM3aisIlNwxo8IpeaL3utk9OHsDC449co/+Oc2pDHQ0qJ6cZOuZsHQi2fNmfQDxZoA3HR7yY5n5pOh3ROIRLqMqnK32drWK9J8nN3j9iNm1uhFbEUMf9kwOdvY2ov95Y26dNGLCTByV78r3fJMZ9GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794712; c=relaxed/simple;
	bh=2F28nfcatLDeIrcQ+pFb/EUiBigp1A0kmdLvac7PBMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKHD9viTwjX3xfvyaPmQnVW/UyAn7POdbItmkzQiCC2EtlSeEoCU1/TJ0av58F+YffnYQP3sEEJS1M5Mj2eEUAyFFzmpB++uF8U39g6ZcIGBtdljitbYqiuVACUDOfS9WdLxrMp92Qdov2PsYUxvrvPmbqZp1NWDvH1SRIog2Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3/j/vCy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3/j/vCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BBF1F000FF;
	Wed, 30 Sep 2026 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794711;
	bh=gZeWXyLYzxMHhq7BTjZId6Q2NGBBOLR87xwYJGLP4NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3/j/vCyxyxWjAgH4319kvBDkVoeiC1oJ8gr5DUzJK+iQAwlicE4Mh0cZ10RkZp3H
	 eHNer/Y3fLWL9WBumK4MoRDI3SMB1MhR6bNQyhqRvzmWCcLQIuYNf9v7s+fwtLPTQ3
	 ZIhiHq3SoNNvTwt+z8NTb542wkBRPY1GmKVgrvXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0306/1193] wifi: iwlwifi: mvm: fix an off-by-1 boundary check
Date: Wed, 30 Sep 2026 17:16:30 +0200
Message-ID: <20260930152440.947817091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d35a8865d00b..9f7dc8c33bd7c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3423,7 +3423,7 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
-- 
2.53.0



