Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E0027B320;
	Mon, 22 Sep 2025 19:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569824; cv=none; b=VBBOmlh5nOwTb6cjYz3MVO/DgxWBf0OUagsqKmezqTl1PiK8PlLyGmHWsTbAn1yyTFsxR761qFszDf9EqpT3puT4a8tQatvIPbwl9QPQMs4GcBapS0CelIlPx6XiqMnJByYKijF8GthBC83DSkN36XNTV+U9TOzbjZmV2O5Htb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569824; c=relaxed/simple;
	bh=uEeopwblUIccedRJaZBrxcRPIs6DGGjfUvajy5h2aqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUtjOoBudEJLdeK/MWG8MYZZFp+YLSScr+M0zGECmcpR3NqVHUhZkkxt3QauhRkFu0I82AMG1Lqynpxs0gBg0m+p79u/mqwFJrsab3vXPkou0rbjG+/M74VNLXO3ETMj/3srwbt41Ow4FJU8n7NH8VFphLvy3IC2LYOHpHaD4es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkHVFxVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkHVFxVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC11C4CEF0;
	Mon, 22 Sep 2025 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569824;
	bh=uEeopwblUIccedRJaZBrxcRPIs6DGGjfUvajy5h2aqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkHVFxVQuktlX3EZWzg8mBXgOc9SZ6mP3Y6Oxs7FXAfaiHBMIxxEHvhPXXYn4W7s0
	 YUFrOvXklAZ6sQOXmY/R6f9ApvQPXrNbiddBOxuNY7eHIAA6p0AylpkxOhoS/5KT4q
	 xTJT3pP/aO2Qu12lE8mQrXoubEYMv4BZNhnne8mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/105] wifi: mac80211: fix incorrect type for ret
Date: Mon, 22 Sep 2025 21:28:48 +0200
Message-ID: <20250922192409.049527795@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Yuanhong <liaoyuanhong@vivo.com>

[ Upstream commit a33b375ab5b3a9897a0ab76be8258d9f6b748628 ]

The variable ret is declared as a u32 type, but it is assigned a value
of -EOPNOTSUPP. Since unsigned types cannot correctly represent negative
values, the type of ret should be changed to int.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Link: https://patch.msgid.link/20250825022911.139377-1-liaoyuanhong@vivo.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index d1c10f5f95160..69de9fdd779f2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1388,7 +1388,7 @@ drv_get_ftm_responder_stats(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata,
 			    struct cfg80211_ftm_responder_stats *ftm_stats)
 {
-	u32 ret = -EOPNOTSUPP;
+	int ret = -EOPNOTSUPP;
 
 	might_sleep();
 	lockdep_assert_wiphy(local->hw.wiphy);
-- 
2.51.0



