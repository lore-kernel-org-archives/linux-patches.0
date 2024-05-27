Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EA1168C4;
	Mon, 27 May 2024 19:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837592; cv=none; b=ed1Vkj5Uyp55G18F+DAklxTRmtxagt/mqHM/RYLBUrj7IMDc2MIWYqy2kQ9RHx9E3J5/JhlAshV7HBbzrwE7nl1r81q8F2xypFdF9tS2DDXvTnR1fgbSUXpH5v2IBRRwn5PJ9m5/Iw2eGKK5a+q9bqFe/7sO8yMishnCv1+Uc1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837592; c=relaxed/simple;
	bh=Dh58MPGSt9+uscW6DIW0oL3wlrkSwyMiJMQsyMeT2QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gttqmLdKH3SE+xjQKzqWncL58F6aTIXwAVb4BA1lZi3LbsM3sJmmg9+1x1vU4dgCRswsfmTb9opUDn6xKs73APoAXrOEeVxqZJtzRZhV0Kro4NQ0CryWf22JND1oQktKU4MJ78vnaSY2xmrVnROAl3zdVwYZY+7R525rKzbiYWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZcw2vCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZcw2vCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F87C2BBFC;
	Mon, 27 May 2024 19:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837592;
	bh=Dh58MPGSt9+uscW6DIW0oL3wlrkSwyMiJMQsyMeT2QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZcw2vCjvXGUY7WrRGBFTQKMl5sZmEW63rGFxHxbr2j/oNtb61/C3S2MTOdoctm8j
	 2j/NUhaKzGp0SV6zcPcAAWTnrBuBteTZkrigxUufDufBrGOdrZHPAz4whU49zlsnMq
	 s+QmlRfVMINv+Ro0GeKPtzUGtKLcLpgCVXUhldpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 043/493] wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class
Date: Mon, 27 May 2024 20:50:45 +0200
Message-ID: <20240527185630.295133464@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index cc3fd4177bcee..0cf8f958081eb 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1747,7 +1747,7 @@ TRACE_EVENT(rdev_return_void_tx_rx,
 
 DECLARE_EVENT_CLASS(tx_rx_evt,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx),
+	TP_ARGS(wiphy, tx, rx),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		__field(u32, tx)
@@ -1764,7 +1764,7 @@ DECLARE_EVENT_CLASS(tx_rx_evt,
 
 DEFINE_EVENT(tx_rx_evt, rdev_set_antenna,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx)
+	TP_ARGS(wiphy, tx, rx)
 );
 
 DECLARE_EVENT_CLASS(wiphy_netdev_id_evt,
-- 
2.43.0



