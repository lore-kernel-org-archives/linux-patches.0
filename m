Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE27444C6F;
	Thu, 13 Jun 2024 12:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281771; cv=none; b=NCHGVv4syPtwvAKPJrS+pYVi3+RSg8YXiaqplGU0zITt+kR5HmHNQ1pa/F0OFnNd30VNIs3LOkzLFY0RK0Aa6uGmfhDHIZagnP16kyORXgww9qbnvnRllNrTLjS4INh95TL82mdcSlS8oWKX8wNx4l03N5t9eg6/DA1DJfvT8v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281771; c=relaxed/simple;
	bh=JAUk0RFP3zoaTSKvtr3Q3P7c5SDNeTnDzYZiU/NArRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxNfCQWTSdEA8gVjQPHr5L464Kr3wNrmTBBXEfHURy4EAAM0MYgisKxROmTcctahYjO2vw3q4U29k6trgg0iVbeQqs//rLUW7v4OW7wGedfAtgudK3wP/cip1iOcmXjzNa9YkYvs3y02aT+x8kncozc6NpzK+39TBm+eUKcBqY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5ecc57J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5ecc57J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574EAC2BBFC;
	Thu, 13 Jun 2024 12:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281771;
	bh=JAUk0RFP3zoaTSKvtr3Q3P7c5SDNeTnDzYZiU/NArRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5ecc57Jvo0jS1hyaoegxYyOpeTujsfao5I6habyEzUJ8wu7FrUccy5NU/1ujjTWD
	 CsjZkh+KxjrvuVwksqH64x4XxivV8gJguZkdwhFT+Xvxz9J6Jbj+yXhMeMGsfMmQ+w
	 +uuaVs9/rFQ8a/cathch4Bpn3bZLGFDWJA1h+LSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/402] wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class
Date: Thu, 13 Jun 2024 13:29:36 +0200
Message-ID: <20240613113302.888135269@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index dafea8bfcf3cb..9467193424150 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1687,7 +1687,7 @@ TRACE_EVENT(rdev_return_void_tx_rx,
 
 DECLARE_EVENT_CLASS(tx_rx_evt,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx),
+	TP_ARGS(wiphy, tx, rx),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		__field(u32, tx)
@@ -1704,7 +1704,7 @@ DECLARE_EVENT_CLASS(tx_rx_evt,
 
 DEFINE_EVENT(tx_rx_evt, rdev_set_antenna,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx)
+	TP_ARGS(wiphy, tx, rx)
 );
 
 DECLARE_EVENT_CLASS(wiphy_netdev_id_evt,
-- 
2.43.0



