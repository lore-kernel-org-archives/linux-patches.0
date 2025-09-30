Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E23A18CBE1;
	Tue, 30 Sep 2025 14:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244170; cv=none; b=T+gFCpvF2u9Dxr0WbXErEnDoIKB08pl3G1ldsNFYOEPCoTWiRnAvnw2Ut2KwDO/N4XP6GUF2NlpL9sPR/S/Rfh4LDYhH8dWKYmZ+CgGidqLrK3fsDbKmCUQuZTpySLeRIsI99l9sao4NSpmpDmNFiwUOI6OaBSvBD2u+FazzE/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244170; c=relaxed/simple;
	bh=0fB6UqOIH2gLtZk/HJN/SRa1XLXkcE1r2cL2tGzEHqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+iyVLHkhcMwUa9CO8sIyTBNUEYQtANcxyjjbfkWqW3gOww55KbSlc+fdNrEX86gl250KgyVK4GGO0mcRM/wyoDsTug03e0mexSrfKgRZ23a69Ggz3r/mTxajrkKznHIQM4mt+CD8aleA8gv3HM3v7qJpZFFaJLgzY/6/QFSXrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeUb0TuN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeUb0TuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97833C4CEF0;
	Tue, 30 Sep 2025 14:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244170;
	bh=0fB6UqOIH2gLtZk/HJN/SRa1XLXkcE1r2cL2tGzEHqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeUb0TuNTThA+eao10n+VVQC/4mNfPbynq7ZzkyzAg3qg3qA2YkqQ1s0hYi0z6sd+
	 7otX+I7ViqegtpXmRHfRJv9vuk3r4O/el24E/LctI5LJCq2CQ2ACYkqNcEzTn7k2Sb
	 M19tx608wxw+01P6Tz153sT6KptOLNZQ2OQzxDYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/122] wifi: mac80211: fix incorrect type for ret
Date: Tue, 30 Sep 2025 16:46:18 +0200
Message-ID: <20250930143824.930468846@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

From: Liao Yuanhong <liaoyuanhong@vivo.com>

[ Upstream commit a33b375ab5b3a9897a0ab76be8258d9f6b748628 ]

The variable ret is declared as a u32 type, but it is assigned a value
of -EOPNOTSUPP. Since unsigned types cannot correctly represent negative
values, the type of ret should be changed to int.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Link: https://patch.msgid.link/20250825022911.139377-1-liaoyuanhong@vivo.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index a172f69c71123..d860c905fa733 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1236,7 +1236,7 @@ drv_get_ftm_responder_stats(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata,
 			    struct cfg80211_ftm_responder_stats *ftm_stats)
 {
-	u32 ret = -EOPNOTSUPP;
+	int ret = -EOPNOTSUPP;
 
 	if (local->ops->get_ftm_responder_stats)
 		ret = local->ops->get_ftm_responder_stats(&local->hw,
-- 
2.51.0



