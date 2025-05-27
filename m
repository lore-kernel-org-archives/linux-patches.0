Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5233513A244;
	Tue, 27 May 2025 17:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365659; cv=none; b=ZKlKkuqWpI+EuSms7JjB4aYIulJubdL1LD02HJDdGNiiWbGtTAjQRYidfsjO+tOBADH30zgy0CpR1sp7KyCYo6sDJPBArTmm9faYh5mDwjBNT4jXGhOm37Adu2Ohfpcfz+h/TjZ56sQM4rbVWtuimSqWT63DlKPwkR5b/njExn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365659; c=relaxed/simple;
	bh=p5iBq7jy2GR3YedqWbZh70x4P1rOeT9xew6cjm5rKOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPwWlAShekw7202j4VQfdKxsPriJbHQcleZROSECQM5lLDr94WFuVxw86RMxzmj8KleVF4SWBKtG93RXm4Q1cwyK8IcAClyVLYSllDW8TeLlFyqhhcCzeHuMynB8f8hl2WDOYrmeW/wjy7emVKhaksXvWu2Ec7hozTTuoSN0Ii0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nai5wvKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nai5wvKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4B1C4CEE9;
	Tue, 27 May 2025 17:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365658;
	bh=p5iBq7jy2GR3YedqWbZh70x4P1rOeT9xew6cjm5rKOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nai5wvKYgp/bgrikkWTxyVJj+ga4iSA5Tz5grIJgZyoIzCgM11Q54IbGmZ3kotUh7
	 XR9ORFNQpWB1zfAm2bU/o4DwRCL89s9seaklDVXi1dwut1UECorWI/Xsvzab/cKC+c
	 BygOJvpFC9kBGYv5rNMa+btbLj44c1JC8h0RkmqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 417/626] wifi: mac80211: remove misplaced drv_mgd_complete_tx() call
Date: Tue, 27 May 2025 18:25:10 +0200
Message-ID: <20250527162501.956606346@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6a29877fd7b37..6a23a24f7d794 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -9220,7 +9220,6 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
-		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
-- 
2.39.5



