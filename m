Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815312FCBFC;
	Tue, 30 Sep 2025 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245091; cv=none; b=SCC7XiMH5lkau5qdaRFJj/sIZ+FL7a8kG9khyAm2K0YP4b27zxBYRAK7lku6rSMSunEzrVr5CQ0jZnroh2MldAE4zaAcu+Sf9MNioZCWc/k3hA2D4/Dx70i/KprAINEUCOIT3LNx0S3QiBd7SX/krsmG5+Cw+85k16yBcXH2TcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245091; c=relaxed/simple;
	bh=9exXmOqjO/12mf3eCa5pWfxZdeyzPfRc2x93iO6lhok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYA+jhOk9y3XhT/ATYjml7FHNR3lagWMh0nEykktXsQ/Vh6nCd5edPgbRc98l71iBRo+CPZKhLDJACg5g0rl5hMsk/sqITKCVsd+BLBb9Vm5GIzt+3gZifCivKioWhLarhmfOQh++JZ/qqiXd7NISGadD0aSWRs410SvUhHgu+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnV2i+rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnV2i+rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08648C4CEF0;
	Tue, 30 Sep 2025 15:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245091;
	bh=9exXmOqjO/12mf3eCa5pWfxZdeyzPfRc2x93iO6lhok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnV2i+rgEAEzvP4Fp0B9LNhETmGjemM7jmJZ9VrZEhXKrK3HoHNQP1uLjUUpWNTVH
	 5SQUFDcX4fypY2vYU0V9AukSXl5wEao4CnAA+HmSB6UpSuv3FxywZDulmScvUddtWI
	 XxSh0Cko75Q84taL73rUOXZLd0/CbgJKDALudwfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/151] wifi: mac80211: fix incorrect type for ret
Date: Tue, 30 Sep 2025 16:46:36 +0200
Message-ID: <20250930143830.228427329@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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
index c336267f4599c..d415a031bfa02 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1254,7 +1254,7 @@ drv_get_ftm_responder_stats(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata,
 			    struct cfg80211_ftm_responder_stats *ftm_stats)
 {
-	u32 ret = -EOPNOTSUPP;
+	int ret = -EOPNOTSUPP;
 
 	if (local->ops->get_ftm_responder_stats)
 		ret = local->ops->get_ftm_responder_stats(&local->hw,
-- 
2.51.0



