Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0034F1E8836;
	Fri,  9 Jan 2026 12:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961820; cv=none; b=McY+SsXbMWBZ5c6eMUgS9kwci3NjotLC/4E0DT1WhPM+Nxwc1mSzgPBw6Dk3ldWEk3vCbB0oRwPbpczIEhyeCGys8SRby5BfDeltGl5nNGeKilecdvtfeNVh2XQz3DFZ3tzrWbx59vYdHpmkhKFQiVcjefBRC2+35Cyz8XneWVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961820; c=relaxed/simple;
	bh=PoPIs6NwsSb3v4E0tLFxQBCdOziI4FMh71TuUSkclyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3o2qF/Yi0g3fQy0gH7YypyDr+wlRpa8nE6Y42ExvQu5JfulJYpriU3nE6RsR0smZjgS47Jw9kWXgLnJGbW9rL7O73iLNHHVIoEmFuNboCAM7pZCEWElLw3ZT1L9iKiF4aatNjNVW0CtCoCcwpVEoRyXiqkzZhtwqblT6/rC8kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xn1oadqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xn1oadqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DB9C4CEF1;
	Fri,  9 Jan 2026 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961819;
	bh=PoPIs6NwsSb3v4E0tLFxQBCdOziI4FMh71TuUSkclyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xn1oadqBZ0eJ8kP5zL+XiDpe9PeIS79v7nHFcXQXMncqqm8JwvTpatbLlJQFaA926
	 mCmAQSYplrp9tO3c7PIOpYDTjn5jcemCV76x8pLOp8+hfhcPJgtJuxtjJUFTzDxT2K
	 ZY61KKXTd1dSXT6Jy93U7emeN721eXc69pNZcsnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ria Thomas <ria.thomas@morsemicro.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/634] wifi: ieee80211: correct FILS status codes
Date: Fri,  9 Jan 2026 12:37:06 +0100
Message-ID: <20260109112123.023188677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8e00918b15b49..c16e90c5588ee 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -3157,8 +3157,8 @@ enum ieee80211_statuscode {
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



