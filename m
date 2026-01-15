Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8940039B48E;
	Thu, 15 Jan 2026 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497690; cv=none; b=joWrj+QhKvqY3ziRa0xz3oRb1lkD42ed0pIuekThhZIDyc/tfwSMzpkyM5y8VBqcP9GFZfNLtQiAHVIf7U/cCEa6pAaHbaSf/HRHbwhs5dDCpMTZRcXZfCW5sJrbT9mdhN06c9RtsY/V0xKCpWAQyNM3HBT0saJdO1b9xVkqpho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497690; c=relaxed/simple;
	bh=H4UCD2ZlHLZvUtjRuZ9VY6rpBw9Jz26zlkyt2hFo25w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBwBoBtEBbC/ERAIKdAQ4Jmq42TXdjyeSm/QKZjruKiXYb19+5gGVmLyfOoTAMTz01qVyCwcnN12UvE68r6R15QDmCJ5hfXrYxv0h22DUOx5D8wAEXYogpxv2dt1rmaEMy4FJtHmE0CYSjGti5hxtEk2f/Jneaj8uiEjDziYw5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUAOnIXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUAOnIXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EF6C116D0;
	Thu, 15 Jan 2026 17:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497690;
	bh=H4UCD2ZlHLZvUtjRuZ9VY6rpBw9Jz26zlkyt2hFo25w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUAOnIXmL6tdVnZFH6p9h/OGenqQixmwboyGVxo5Z84Ah/OW9ZNl5MfIJhSCq/32M
	 dgbODdiw0pT0vG7WQWWgZv1mz1ACMwKsyn/GRMbbVw7cy9mMQir6woTXXSWkhyhPxS
	 q4ykeeboxBtgmA5qY/XTTgmFxch8ddIU4yRY/8Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ria Thomas <ria.thomas@morsemicro.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/554] wifi: ieee80211: correct FILS status codes
Date: Thu, 15 Jan 2026 17:43:22 +0100
Message-ID: <20260115164251.174799355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ria Thomas <ria.thomas@morsemicro.com>

[ Upstream commit 24d4da5c2565313c2ad3c43449937a9351a64407 ]

The FILS status codes are set to 108/109, but the IEEE 802.11-2020
spec defines them as 112/113. Update the enum so it matches the
specification and keeps the kernel consistent with standard values.

Fixes: a3caf7440ded ("cfg80211: Add support for FILS shared key authentication offload")
Signed-off-by: Ria Thomas <ria.thomas@morsemicro.com>
Reviewed-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Link: https://patch.msgid.link/20251124125637.3936154-1-ria.thomas@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 00ed7c17698d1..0c00a628cbde7 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2720,8 +2720,8 @@ enum ieee80211_statuscode {
 	WLAN_STATUS_DENIED_WITH_SUGGESTED_BAND_AND_CHANNEL = 99,
 	WLAN_STATUS_DENIED_DUE_TO_SPECTRUM_MANAGEMENT = 103,
 	/* 802.11ai */
-	WLAN_STATUS_FILS_AUTHENTICATION_FAILURE = 108,
-	WLAN_STATUS_UNKNOWN_AUTHENTICATION_SERVER = 109,
+	WLAN_STATUS_FILS_AUTHENTICATION_FAILURE = 112,
+	WLAN_STATUS_UNKNOWN_AUTHENTICATION_SERVER = 113,
 	WLAN_STATUS_SAE_HASH_TO_ELEMENT = 126,
 	WLAN_STATUS_SAE_PK = 127,
 };
-- 
2.51.0



