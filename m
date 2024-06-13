Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB63C1474C9;
	Thu, 13 Jun 2024 11:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279749; cv=none; b=kAD48EoP1IP/E78D/vYWpFIxuzWkeJLo9pqxj0C34CF2aXYTgBVG8fCn4JOW73OpHqk4dIdDvWjXSR/6OJ4cp/ZaPE5jLZEt4Q02z218z1RIqLL3xhSW3ES8v+pk8I9onmV+s/bjq0Hdtoi/96W2apAB+GbYQkd94ShDaupnV50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279749; c=relaxed/simple;
	bh=Y5OMvtCpgJ3IgF+PhUtCQAnzfTDeCm3YWMiKHHRjUJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzxa0h2NC1oRJGVtKnNwUFzdB+l/CCFOgUOaPmrSMW1MDnNyTiLEAalP5YJ6ysXOQWI762TGeTnxGtvkASFC445Gxb6pLeIWwxJ8Csjeg929ZPvZugUUtwsD7ls3dmN9TTqt50SlkBgopGh/NypSBvBkqVOdqn0hrr9K/+oJIU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wduIRIRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wduIRIRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A58C32786;
	Thu, 13 Jun 2024 11:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279749;
	bh=Y5OMvtCpgJ3IgF+PhUtCQAnzfTDeCm3YWMiKHHRjUJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wduIRIRaZ8wHqMNnTeA8btfd7kGR17B6sNckPfE65Gqr6TMFQJ5k7gQgzXqnUAENC
	 yKO6X78kvkfBVI8TkzLFbP3IlSst8YaZWEg7kkVEksyv2sP5ffwK+OTiQR2V1tKm3I
	 dQHGbiVcWgYOOP2n7a5Cip+0KWzJdObnOueFUZWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/202] wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class
Date: Thu, 13 Jun 2024 13:31:46 +0200
Message-ID: <20240613113228.085055952@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 630b72355ebb5..90307fe4639b2 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1630,7 +1630,7 @@ TRACE_EVENT(rdev_return_void_tx_rx,
 
 DECLARE_EVENT_CLASS(tx_rx_evt,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx),
+	TP_ARGS(wiphy, tx, rx),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		__field(u32, tx)
@@ -1647,7 +1647,7 @@ DECLARE_EVENT_CLASS(tx_rx_evt,
 
 DEFINE_EVENT(tx_rx_evt, rdev_set_antenna,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx)
+	TP_ARGS(wiphy, tx, rx)
 );
 
 DECLARE_EVENT_CLASS(wiphy_netdev_id_evt,
-- 
2.43.0



