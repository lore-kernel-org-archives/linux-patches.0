Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D48B1A0B04;
	Thu,  6 Jun 2024 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683158; cv=none; b=VssKWjWuMsN6RILIO0qoLk36dzf4oRVmj0VdUPNclCgAU6xFZ6DxMXLzYCBiv3CzWawo//Rp7nHkeuelUxbpFkYZ5c4paTtLjqDHYj/I7MLDdowm9Lt2Bj+QnnoUEnFMyDfxsmQcEH9YgtcG9CQ3wRXjFEZc0OsW6ai4T6hXLE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683158; c=relaxed/simple;
	bh=VVldJC3qWOqChS4GMwb/rZ9/fXXM/Tbzv0DI5hvyfgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDgf+XWyZD0ZEKq4Y9HOyP2BPtwChmJmTjISNFI6zH9dXlhQQLbwsCs6L4dxWH6rZVlbIFCsStviZyGVGFUTUEiX7pZ4A+s2LiqCwrD68dQqWBonVXKhx/vbf7g9C2Zdkq1siiwSlzO2+B0DSVR6iochjCPEognVDgjMqq1qgok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nM3xtcpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nM3xtcpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA0CC32781;
	Thu,  6 Jun 2024 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683158;
	bh=VVldJC3qWOqChS4GMwb/rZ9/fXXM/Tbzv0DI5hvyfgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nM3xtcpGtQk/70nyNWCRP+j3VbF+PkQqWBWJsaE2wbjN957CU9Ra+4RfUeTLoLT1w
	 KzVu4dyHK4N12qVR9OoksnfInSfb6LosZhhW79NRaBEzQYlCAqUutQtLyXfYMAV+HS
	 k7/yV358tCf9ueSuAuDrSNkSDeRMH3ijsQozRMFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/473] wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class
Date: Thu,  6 Jun 2024 15:59:18 +0200
Message-ID: <20240606131700.830484836@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Artemiev <Igor.A.Artemiev@mcst.ru>

[ Upstream commit 9ef369973cd2c97cce3388d2c0c7e3c056656e8a ]

The declarations of the tx_rx_evt class and the rdev_set_antenna event
use the wrong order of arguments in the TP_ARGS macro.

Fix the order of arguments in the TP_ARGS macro.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Link: https://msgid.link/20240405152431.270267-1-Igor.A.Artemiev@mcst.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index cb5c3224e038a..137937b1f4b39 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1734,7 +1734,7 @@ TRACE_EVENT(rdev_return_void_tx_rx,
 
 DECLARE_EVENT_CLASS(tx_rx_evt,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx),
+	TP_ARGS(wiphy, tx, rx),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		__field(u32, tx)
@@ -1751,7 +1751,7 @@ DECLARE_EVENT_CLASS(tx_rx_evt,
 
 DEFINE_EVENT(tx_rx_evt, rdev_set_antenna,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx)
+	TP_ARGS(wiphy, tx, rx)
 );
 
 DECLARE_EVENT_CLASS(wiphy_netdev_id_evt,
-- 
2.43.0



