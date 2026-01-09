Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FD8318EFA;
	Fri,  9 Jan 2026 11:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959885; cv=none; b=urAJf1alIQEqyxWfCHF7jX4KLm//QozTzrSwKHqO82TbXHiM/PKAMw9h9EsIz5GmiwLkWERDUD/MwqMUW/6Vif6xOkH5+waIdldqD3vcLGw8g1ZYSKp0loS8YtDrmL+uq2pbKMniAxA4Os11zZBQka14zqcN0Nb8UT6XTcYliXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959885; c=relaxed/simple;
	bh=WoSbJNGxvA+tD+/PCPlFXTF4SUxcHB0R9MUHaG0NCzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PG2U7l4NiRSJkRVssVXC86OJpROrEkscrdhSr2Rpwic49xmOAaoOqxqInw/e/ffZDmocoEsW1kfUhE/0ZkMqk+bOlxH8bm+1KbM49xPbQU1a/pYxsVCWXqUmSgGyqiJDA8nTK6uTXUEeQ2jUAzpBOp6WBV1uEXvS+DnSFCfduuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHQuBlN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHQuBlN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CC3C4CEF1;
	Fri,  9 Jan 2026 11:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959885;
	bh=WoSbJNGxvA+tD+/PCPlFXTF4SUxcHB0R9MUHaG0NCzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHQuBlN/cZaAOuMn/LOMRpOgicQFIslXAD6kI4cTEyN4dcS+Y1xWqGmEFhe4DWVKW
	 6fkocm80PePLjvSPLHywZ0zV4isgr6KERu7PUTFXQz07BUhyaHnfAfwjiHyEOvAr0t
	 +OkmrcShWMAkoQU3VqbLgkE3P2na1cMP4G3C3hhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ria Thomas <ria.thomas@morsemicro.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/737] wifi: ieee80211: correct FILS status codes
Date: Fri,  9 Jan 2026 12:35:47 +0100
Message-ID: <20260109112141.823871223@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0ff10007eb1a5..38e3e81b880fb 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -3297,8 +3297,8 @@ enum ieee80211_statuscode {
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



