Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9926EB67;
	Tue, 14 May 2024 11:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687676; cv=none; b=OdUWmfqBMnCwLoqPng4unbM9b8amNTWe7YkfZvD+75IWgdJt+Syc7XMo1q0RQxgusZn9R3tkHdeS53hjsZ3AoMu2pfoh9GNu2F3Dyo0Gp3qLeNU9ekwhznGsMl0mZJP2/wkr7q9YWB5skzN9lxPhgKTZdCApGVfdWa9anjFmpXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687676; c=relaxed/simple;
	bh=kxqBQWSYiRh0RrTioR5swHtOSAK4AdpyyDsRTtfTXjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXotbCb5ObQFYYZlJIkJ8csr2bE61yeAzQx6qrJsgB0/LJuWmbyrk9pR0IHzt2zTBazucHVZYjeizo8tGqNAz2J+cDdSBDW2sckJ7Y3OYukeoJKdKFUnVL95Bfa8MMpSZHXhXSUusAexl/3gn9H1iR3sb5XahqxmEOHgHpOV0b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1ijYMgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1ijYMgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C1CC2BD10;
	Tue, 14 May 2024 11:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687676;
	bh=kxqBQWSYiRh0RrTioR5swHtOSAK4AdpyyDsRTtfTXjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1ijYMgp8EXDO3FJ7qwGuVCpCBrtrMESPHfK8VV6ZtaZfbI+IqZk1j90cLbR92jki
	 04GXroe5Vth+OpcIw1qUB1pXGJsMRiUaLn5TBQKL447SEMTW3JaclIGSbomp3uJwbu
	 MiKc5D/BcDVCC9+l2A7T9LtbvoqjxIlvBZ8BYSUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Simon Horman <horms@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/168] wifi: mac80211: fix ieee80211_bss_*_flags kernel-doc
Date: Tue, 14 May 2024 12:19:24 +0200
Message-ID: <20240514101009.189872587@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit 774f8841f55d7ac4044c79812691649da203584a ]

Running kernel-doc on ieee80211_i.h flagged the following:
net/mac80211/ieee80211_i.h:145: warning: expecting prototype for enum ieee80211_corrupt_data_flags. Prototype was for enum ieee80211_bss_corrupt_data_flags instead
net/mac80211/ieee80211_i.h:162: warning: expecting prototype for enum ieee80211_valid_data_flags. Prototype was for enum ieee80211_bss_valid_data_flags instead

Fix these warnings.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://msgid.link/20240314-kdoc-ieee80211_i-v1-1-72b91b55b257@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 21549a440b38c..03f8c8bdab765 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -113,7 +113,7 @@ struct ieee80211_bss {
 };
 
 /**
- * enum ieee80211_corrupt_data_flags - BSS data corruption flags
+ * enum ieee80211_bss_corrupt_data_flags - BSS data corruption flags
  * @IEEE80211_BSS_CORRUPT_BEACON: last beacon frame received was corrupted
  * @IEEE80211_BSS_CORRUPT_PROBE_RESP: last probe response received was corrupted
  *
@@ -126,7 +126,7 @@ enum ieee80211_bss_corrupt_data_flags {
 };
 
 /**
- * enum ieee80211_valid_data_flags - BSS valid data flags
+ * enum ieee80211_bss_valid_data_flags - BSS valid data flags
  * @IEEE80211_BSS_VALID_WMM: WMM/UAPSD data was gathered from non-corrupt IE
  * @IEEE80211_BSS_VALID_RATES: Supported rates were gathered from non-corrupt IE
  * @IEEE80211_BSS_VALID_ERP: ERP flag was gathered from non-corrupt IE
-- 
2.43.0



