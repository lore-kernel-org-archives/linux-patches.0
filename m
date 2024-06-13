Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6836744C6F;
	Thu, 13 Jun 2024 12:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280715; cv=none; b=pNS+5NfoWqwD06TxvC910iVILJAxecmLj0Ksrhn4r1VDKq/zleWtqPPmHkxq0pc6R7n/2gPcgaNHFr1jbVXe4uDjo8Qx1z9oePmcaeymAq3EMuWboXiqytiFuEwcMeD84QN9UswUhNwtpVc19Uf2vAHy20ZTscBWYfud3dB/Rgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280715; c=relaxed/simple;
	bh=Uo8fpEHLOkH88cRa5wYs+QAGuoKEAkyf8NheDv8YKQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgT7Gn4cMvjubRcMPWZ3gT1TP5fF8sVhsIWNw+UQIGMqxyOMTaIPUOFrO9TGhgvlPMaoTKNbBhrWtc3UwdQ0HyHX51o/tQAYPc6ovYwE70m9xKz+V9PZ6/TJm4FegPgEOOnEOqPiMuO86lXWMBQPf83Tyuvi/bCpnZ5f+wLi0+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekLyCtTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekLyCtTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8A3C2BBFC;
	Thu, 13 Jun 2024 12:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280714;
	bh=Uo8fpEHLOkH88cRa5wYs+QAGuoKEAkyf8NheDv8YKQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekLyCtTKK9A5D1GSTwwX5NeGtR6P5p4GL3LON0LGhQZ0gGDi7chPeWgpMlgzUyYWH
	 +oQGh/LL4+6kc7x7UwhS1crn2Mj8H9M1DCqG1PKwwXoS65dh0nT1shwXmDVwIywRT4
	 wbsie7dYi7lzfP7Kl2f+nzGVZMtHyc9g3cqtIj+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/317] wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class
Date: Thu, 13 Jun 2024 13:30:28 +0200
Message-ID: <20240613113247.937201270@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index edc824c103e83..06e81d1efc921 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1660,7 +1660,7 @@ TRACE_EVENT(rdev_return_void_tx_rx,
 
 DECLARE_EVENT_CLASS(tx_rx_evt,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx),
+	TP_ARGS(wiphy, tx, rx),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		__field(u32, tx)
@@ -1677,7 +1677,7 @@ DECLARE_EVENT_CLASS(tx_rx_evt,
 
 DEFINE_EVENT(tx_rx_evt, rdev_set_antenna,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx)
+	TP_ARGS(wiphy, tx, rx)
 );
 
 DECLARE_EVENT_CLASS(wiphy_netdev_id_evt,
-- 
2.43.0



