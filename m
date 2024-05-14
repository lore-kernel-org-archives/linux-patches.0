Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE7B3B79C;
	Tue, 14 May 2024 11:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687679; cv=none; b=A6pb5gDlmMu7FVUmtazwyoGV/4qEbMlVPuGq1GSiEHntPUIo1II1BIK1LUhf4TnIW+4uhKxzVCqGmCRmzpnonnNm0r8XyPqinC2tUvfCTjL1oCFsg9AgIzkYI2w7YgR8ax/rZ24ksz+5zVI5UMyD7F2LPgiyoMr1E6QDcx3JVpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687679; c=relaxed/simple;
	bh=wBbE7GJE+gY4reUe1d8gNyLntm4zhWMTQHtwwP/DuCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tg70yzaRVnHlZiJkmfcybb4/Jprj+VsAvZTwM1poSa61PlysNdTpDus1feesYPgHbvW69i6ovUm25VtWihpK+PV1dFNw4GIVHQrWNYTISgMYQ7rsz0jjOq/dlUvB3kWluQ2zyt2Z9TduQmdlydwRO1G8PCV7H+42AVLsyGsot9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCDKacGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCDKacGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AF6C2BD10;
	Tue, 14 May 2024 11:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687679;
	bh=wBbE7GJE+gY4reUe1d8gNyLntm4zhWMTQHtwwP/DuCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCDKacGVfjmYruDYo0XZNLOI1HhbSF9wN9rc428HT1j5e6U3Mscw/GvjTzmWtvgjB
	 Zt3GSWuhwZfC7rTrb8+iWUtRfKbgoNP7RRiYcRavAoxdI/UL2xapSspwEPXgkpJNcd
	 H+t+cZWD9vj0KgSsKrb4P6ZO7T3GKjvXdrZY6OKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/168] wifi: cfg80211: fix rdev_dump_mpp() arguments order
Date: Tue, 14 May 2024 12:19:25 +0200
Message-ID: <20240514101009.227105610@linuxfoundation.org>
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

From: Igor Artemiev <Igor.A.Artemiev@mcst.ru>

[ Upstream commit ec50f3114e55406a1aad24b7dfaa1c3f4336d8eb ]

Fix the order of arguments in the TP_ARGS macro
for the rdev_dump_mpp tracepoint event.

Found by Linux Verification Center (linuxtesting.org).

Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Link: https://msgid.link/20240311164519.118398-1-Igor.A.Artemiev@mcst.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 19b78d4722834..dafea8bfcf3cb 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -963,7 +963,7 @@ TRACE_EVENT(rdev_get_mpp,
 TRACE_EVENT(rdev_dump_mpp,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int _idx,
 		 u8 *dst, u8 *mpp),
-	TP_ARGS(wiphy, netdev, _idx, mpp, dst),
+	TP_ARGS(wiphy, netdev, _idx, dst, mpp),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
-- 
2.43.0



