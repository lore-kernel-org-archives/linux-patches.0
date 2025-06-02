Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD9B22A7F9;
	Mon,  2 Jun 2025 14:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876282; cv=none; b=dW0R82c6XD53649F+zR7bTeANBv/3/4HrIP2DsPgqmPzk7lxoN8/cGuFkh5yfpwrKKqgP0L6PFjXugtvv3hJDa+17o+bTBP4aKIzDRTiAF/AKZ0ZuC2cfMtj/6iNJyOAWOjd5GLTmE3US+HZxAXVhy4NIED7fiFwyOQQ+dTDvXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876282; c=relaxed/simple;
	bh=ymSkNBPkaW8Z5QzukKyCQF+bjbKjtpFzP0/6N3+fg9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGaQalf3FPkXI0s7n+cvlaARo7rUYWZkA1CCz7SzwzbrSlJZ3XBmvG9TuLLCums4ngLnmqSqiYzw8T5/QjPNj0iBs6ows5fSy4sNTW7INv9nR3hwYZOj5AdnxVw410yJykuiOm8IMIqmO7UQg0io2xrTjaKOppJdRlsBkJh82xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JH83Vedz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JH83Vedz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC3BC4CEEB;
	Mon,  2 Jun 2025 14:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876282;
	bh=ymSkNBPkaW8Z5QzukKyCQF+bjbKjtpFzP0/6N3+fg9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JH83VedzcN8gyPt7DMBm3hBUuUchj4J2bfZwCKagED/Viq/Ck0pXFsP3My5a3MFcu
	 zRzcLuYwRM7m3DTteNvjLC+euA3GnTGToAXJFff/AZhOPy5qubuMYx4p9jK2ggkb9f
	 iXS2Z00gpOrq5PivYqqIeKiymTEHL9urep5WHWxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/207] wifi: mac80211: remove misplaced drv_mgd_complete_tx() call
Date: Mon,  2 Jun 2025 15:48:21 +0200
Message-ID: <20250602134303.771805585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 11d9bce1a4390..ae379bd9dccca 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5952,7 +5952,6 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
-		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
-- 
2.39.5



