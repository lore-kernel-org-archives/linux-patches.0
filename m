Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C2F2DEA79;
	Mon, 22 Sep 2025 19:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570114; cv=none; b=Ck9h+yoqDYsSoGz9Q8RNn+UpmNmhzaqkJV6AmkGLA1mFLKpjQgKAvTVUeYnocHPPFdNlhCeBo5qhAtEijUhppeyWxmQwHmDKVyQwZF8F/+DUviaKgXZklTMKE+QsRcUzQ/P+WS28Emm83wTfbK9kAex4bdNTagD1iUqeYfp+e1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570114; c=relaxed/simple;
	bh=GZgD1yZEsWESRKlM3B6Q1/VhJeCfLRJInjPNMCHo454=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nb+Q1QE3ggRAsF5j4MtbeSnyrXIpNgi+Wb9kQ/hPpuUEEnNUgthOFDD/isBOh2PNndwEibCluykviw9Ih/4rbjI2e0MN49MedjcxF9AoUffEBBOjbi9X8JTYc/De4ZtnPhYoKJM3LcdTk9POQsvRdn+7yjjxn4NeXBeLcb4/ZBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xA109SGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xA109SGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F164C4CEF0;
	Mon, 22 Sep 2025 19:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570113;
	bh=GZgD1yZEsWESRKlM3B6Q1/VhJeCfLRJInjPNMCHo454=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xA109SGnBmqzxxpZvvZ/H0uy6WF7SERSvTUpgp231mcND8efYWDiWyH0M5tiiT1vP
	 A6YkSjJGDXdPQqgjAsmzjlkxBi0CztfFZpuSS93xMfQJN+3rgQnrwaltqhmEdw1fOw
	 Juuk1p0Zcu6i8LaO2SZlxrob+/mNR9OVFNiQygFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 010/149] wifi: mac80211: fix incorrect type for ret
Date: Mon, 22 Sep 2025 21:28:30 +0200
Message-ID: <20250922192413.149635687@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 307587c8a0037..7964a7c5f0b2b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1389,7 +1389,7 @@ drv_get_ftm_responder_stats(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata,
 			    struct cfg80211_ftm_responder_stats *ftm_stats)
 {
-	u32 ret = -EOPNOTSUPP;
+	int ret = -EOPNOTSUPP;
 
 	might_sleep();
 	lockdep_assert_wiphy(local->hw.wiphy);
-- 
2.51.0



