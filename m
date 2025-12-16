Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D80376BE8;
	Tue, 16 Dec 2025 12:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888075; cv=none; b=nXFbMZhZPzN0VMQYNft6KzYfbydn9kjF5rd3qQn6BnXEJejymGJZ1ekGUcql2BGIrXi7WQ5pAdG7YMq6XxUpEkRL6dA31qLTSit0q56l4ZvIX4SsGAuGe62lzcJhXarBRyY7numB+v5vt4ZM9WppbhFoj0dy0WWasJBr2S2ncDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888075; c=relaxed/simple;
	bh=Xsx6Yss8PvMqK98fqPn8svVK0afpa2trf9fzLtq/U+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2wzE9vi0Cg/y0X3HPTnvu5hqmBTZVXvyvSaEL7WeZ3Kfvrbm6tOf+YqrqVxU4Ls7enEHllgHjhUau0Cta2hUKwL7MIauKSuguajIEJES3temOoYx9m43iQ2YtpphVB+Kxh94eLdxECZGvSNhGNQFcHcycfoZ37liUyXtMHmWAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwwzKlc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwwzKlc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB1FC4CEF1;
	Tue, 16 Dec 2025 12:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888075;
	bh=Xsx6Yss8PvMqK98fqPn8svVK0afpa2trf9fzLtq/U+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwwzKlc7Hki5RivUvyhV2hCpWEYsEL7j/tw1pWsIlhoKTZ5QyL1gItas3ky7IEbXd
	 7fjU/s3uy5cB65QuKDZwNEiTXHjh7itnPXC/lXC5YqTVZb2ouXAkhwfoC4+psoujuQ
	 FUi1NG3BL44fYNGbNjHgGIu7d96Lrc5L0JGv1npw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ria Thomas <ria.thomas@morsemicro.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 417/614] wifi: ieee80211: correct FILS status codes
Date: Tue, 16 Dec 2025 12:13:04 +0100
Message-ID: <20251216111416.480068302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ddff9102f6332..1f4679092e69d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -3594,8 +3594,8 @@ enum ieee80211_statuscode {
 	WLAN_STATUS_DENIED_WITH_SUGGESTED_BAND_AND_CHANNEL = 99,
 	WLAN_STATUS_DENIED_DUE_TO_SPECTRUM_MANAGEMENT = 103,
 	/* 802.11ai */
-	WLAN_STATUS_FILS_AUTHENTICATION_FAILURE = 108,
-	WLAN_STATUS_UNKNOWN_AUTHENTICATION_SERVER = 109,
+	WLAN_STATUS_FILS_AUTHENTICATION_FAILURE = 112,
+	WLAN_STATUS_UNKNOWN_AUTHENTICATION_SERVER = 113,
 	WLAN_STATUS_SAE_HASH_TO_ELEMENT = 126,
 	WLAN_STATUS_SAE_PK = 127,
 	WLAN_STATUS_DENIED_TID_TO_LINK_MAPPING = 133,
-- 
2.51.0



