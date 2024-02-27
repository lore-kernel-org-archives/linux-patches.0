Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF691419A1;
	Tue, 27 Feb 2024 14:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042710; cv=none; b=VdekZeWAnVVBOkZ8tMIuMo8ua14drrZgmwTuXhc80qXS6lZi0Mg+aeyTfxOkY1bTFq18Hwg5D/w16VmQMzWNaII10iVvd4V78acXmzH5NPU+wntAnrcR2wy5fFuAMfwNu3nvBYgl5rGp4El4K5FB+weElrvLd/ObJQN0t6rZtBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042710; c=relaxed/simple;
	bh=jvHyEx+XGN2MEQu636Hvvo+5QIxkIcRaH8R28Y7KAjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aK8YCVVOhRGgbciXZ+k4Bi2s9x6nOUnGilO/tRt76ciHcRgIQi0j9HpOPr9jC/0yKhXT2AA7fyQuS9rSTWyi69OcDJ3AKU/ul8nbajIi7Sxu72+sOGmXThDgh+V85xeJ5mvBzLKepbtZWrE8Lj7+X9j1Cph5zgT7gwlGqXo5Cdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFsA1TOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFsA1TOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A17C433F1;
	Tue, 27 Feb 2024 14:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042709;
	bh=jvHyEx+XGN2MEQu636Hvvo+5QIxkIcRaH8R28Y7KAjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFsA1TOqg2RQnScLrcsgfVunwe6OKZTzdb/gOQQBMZbbDEbWJGBU72nArEAhWgjXz
	 y83lRDvLvqgiK0DpA3+DF+kK2lpqgfuuAhlUyJahg6n+cI/50mJQDY5oHPS29jlMrI
	 sJntcQTOe8GLEEmCJn5+FLoMu5tHPxaP9OpNk8VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/245] wifi: mac80211: adding missing drv_mgd_complete_tx() call
Date: Tue, 27 Feb 2024 14:24:12 +0100
Message-ID: <20240227131617.324083024@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

[ Upstream commit c042600c17d8c490279f0ae2baee29475fe8047d ]

There's a call to drv_mgd_prepare_tx() and so there should
be one to drv_mgd_complete_tx(), but on this path it's not.
Add it.

Link: https://msgid.link/20240131164824.2f0922a514e1.I5aac89b93bcead88c374187d70cad0599d29d2c8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cc6d38a2e6d5a..5da0c2a2e293e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5923,6 +5923,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
+		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
-- 
2.43.0



