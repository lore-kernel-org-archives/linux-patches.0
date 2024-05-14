Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281F8143C47;
	Tue, 14 May 2024 11:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686327; cv=none; b=A+wbaMhIh+VB6xuWWV0wLkSHllIR8uo9YEKMLOBjQmuOHOYM0MmB97YIch3YKpBbm6rVYyCjDQascxM+8FIWlTM5cOFA2fJel/HzCrYkYEDBDN+j5Q3C5k2yU5TfKcCScsZjig2dMjkv9yyxzv2yPx7bN0x6PF5UuxZawnDPW9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686327; c=relaxed/simple;
	bh=3o8cTqVljCbEToLLLcHx+A5pQauRZCYV7cpaBBHcSGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYMdYKCE+oS5kh9q4JJdihNl1Kc9xKDFYv/z3y5v8Ukjv5y06yFLm61p70/m72LUvNwT/hI7u6kXKBwpEAdOFtAIyr0doZXbJpzzezk0XOwLQaWPl0CqTsOEya3mvgrG5z3HgSxvvuodFFf0gEhEqmyAUfw9Dl7jivhb61F0kl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cU3FpFNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cU3FpFNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF75C2BD10;
	Tue, 14 May 2024 11:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686327;
	bh=3o8cTqVljCbEToLLLcHx+A5pQauRZCYV7cpaBBHcSGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cU3FpFNLtgE/MoZAkckei7Oo3sLdg/Rq49FEj+mdc6QPXWDl29WAGJm73ZGhasMR/
	 0lh2OMGmc4OZdMaoUm1hWRieVtefYwIEbgbc3pKOE6zxT16lYXHvCB2V1zVK6pWtaC
	 vP0dz3OOC1FrErzHMh/0DQE8d27iqy4D0WeNV7wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/236] wifi: cfg80211: fix rdev_dump_mpp() arguments order
Date: Tue, 14 May 2024 12:17:41 +0200
Message-ID: <20240514101024.129838304@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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
index a405c3edbc47e..cb5c3224e038a 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1018,7 +1018,7 @@ TRACE_EVENT(rdev_get_mpp,
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



