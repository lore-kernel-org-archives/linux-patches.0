Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64F727A900;
	Tue, 27 May 2025 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367859; cv=none; b=gNqOnjbsXENuV+e6o4Z5tHGmHJix445XZknCxWnZr7gKZuSI6R9dz+Q739ECtmk6S1KjKZLXq/+odF13M9JOyJLltViRTdDzrhSwxO7Fh+D5PowX8k2EV2iquG/kaYh5R1cVKlu1im+yPkGv/tf289cAfFtDM+7VFFrBY8dt4kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367859; c=relaxed/simple;
	bh=n8mGcZIKGMCgXLo0E/qGKOCpoZ8/k8kES3vqHGSnwDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzteDgQLXvw//9bA2zVt1k3ydwLDxO9GFYJCzZk9TUXMwSV83dVlO+RsoTbQ6MMlGmxR22ePMagbB1LFentornVFa0EbKd9rxq5iDpOyaxJlaqqRz/zPS3htiGg+uDsvsXpTfMjI95FiuwG79kIp4C6GWld7cxpZQhfbkH/BgAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2P1I/1V8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2P1I/1V8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6162CC4CEEA;
	Tue, 27 May 2025 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367858;
	bh=n8mGcZIKGMCgXLo0E/qGKOCpoZ8/k8kES3vqHGSnwDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2P1I/1V8luyRQazeHh94Tsk1O63ciCQULbM5sPGaxVCfYndyb8yO3KoIszfl5nz56
	 +KFdswyngOdcjcko0vG3kvDDWj70+T/9yDjBZ9iGXfDYmM0914TRtdZruGphOoRw4c
	 TlPIZ7J1gYbjQvzkt+Ra0pC6XXWmvXqnKEZdwAEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 522/783] wifi: mac80211: remove misplaced drv_mgd_complete_tx() call
Date: Tue, 27 May 2025 18:25:19 +0200
Message-ID: <20250527162534.410875405@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 3bd1c4eeae52f..ca247609f11bf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -9508,7 +9508,6 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
-		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
-- 
2.39.5



