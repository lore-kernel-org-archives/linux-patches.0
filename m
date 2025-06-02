Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB1F221F1E;
	Mon,  2 Jun 2025 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877146; cv=none; b=qRUhU+lsbg5dPUSqzAtaq0cIER5MEU0tqEJ8dpwGW0ZjTUIu9llnCrvMbckr6azmdncaF0kgpRl/HpeY69Rjjzsdo/595mqR3r9XwUurjYacwCSdfKU0KTIUVILfuGvciQ98MfnX5scxH2ZxevS8toaKSArbD/m5ukhqACL+bVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877146; c=relaxed/simple;
	bh=s3x/YPNboyIf7aCLgV7WkLmupy0zgX58+y917k/GBRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kD9VgLJEI4HmmyjWVaG8ujQSMPad7lpemtf5wb26UedGOyf+dwwerjfEwJvv0v2ngnTJ9nl7o2sK9mJDCh1Do5aj4UKcJJqsSdUvyDPr/IrjrCcPZd1G/uhnBKyQIuHPJTvn+J3LxZT5OEm2wxceKGu/nkjwsHwSXFjlIkU4CF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URA4mugu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URA4mugu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3A4C4CEEB;
	Mon,  2 Jun 2025 15:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877146;
	bh=s3x/YPNboyIf7aCLgV7WkLmupy0zgX58+y917k/GBRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URA4mugu1NXwWgfNne5PFwTZMx7chUs5Idzfyl/yJHKWcl3B/F6wSL6o1RuW9awEk
	 ZtUYHK07N4exiOYvsDP5dYBDbRTN3P8u8lbWUZ6yf0y8hD7UKPCE6jJk4rAsB05jKX
	 RlgnaJPJfpuJxC0miMq7bACG3fgGQvdPtuGXY2Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/325] wifi: mac80211: remove misplaced drv_mgd_complete_tx() call
Date: Mon,  2 Jun 2025 15:47:43 +0200
Message-ID: <20250602134327.410025911@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f4995cdc4d02d0abc8e9fcccad5c71ce676c1e3f ]

In the original commit 15fae3410f1d ("mac80211: notify driver on
mgd TX completion") I evidently made a mistake and placed the
call in the "associated" if, rather than the "assoc_data". Later
I noticed the missing call and placed it in commit c042600c17d8
("wifi: mac80211: adding missing drv_mgd_complete_tx() call"),
but didn't remove the wrong one. Remove it now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250205110958.6ed954179bbf.Id8ef8835b7e6da3bf913c76f77d201017dc8a3c9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8f0e6d7fe7167..b300972c31500 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7312,7 +7312,6 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
-		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
-- 
2.39.5



