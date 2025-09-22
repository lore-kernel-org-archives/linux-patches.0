Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B638125F780;
	Mon, 22 Sep 2025 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569651; cv=none; b=tzqIJetYfTU+XQKEbW/ea9oMfe2pZs5Nm4x5cdHrNylKF+2A7osVrfWfhWAmhQX7QIHgEcPCkvEBx9zNSAZA0GMTcJ7+VLAb1Wb4JzX6aGub2szI3qmkCRlqMfSb5DlpH+czoJvFjiQEIQwAeLbqK8XRDqaBOZKQYj0Zwd5lOUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569651; c=relaxed/simple;
	bh=ZX3BmobO+KlexnpurRx9Mnb5/nYEmVDSHMOp1Yzc5FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7YhrxriEXN9p8tPO/Cl6yd83egnYWrOk5WEFawC5hMtZUYLCGvgft3lyVBCKb3Kb0T/zMBy8ygzb82CLQ969KdoUn+Uqyz9cicrzrZ3ylQA4/FsknIHyWmGWiEIPWL+R4H6Tlct4tEDU6Xwna/wDgV/nvJ83azHKw4xRDx6TE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gqBHCJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gqBHCJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FAEC4CEF0;
	Mon, 22 Sep 2025 19:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569651;
	bh=ZX3BmobO+KlexnpurRx9Mnb5/nYEmVDSHMOp1Yzc5FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gqBHCJ+j9z9SJOxtIZY0kK/XcUtygQ+WnEbOWI16mxwh54gKypo40nCoFP6iekEc
	 htMr5GSaMXNTaWPJ1iQcUpzfcc4Wi7nTS6BIFQFC7H/XuYVOaOwvSwPO4RfZU6roAZ
	 3Z/XSZ9YuV62UHZnMQMLUxC7/Hrt20T9kP56C8A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/70] wifi: mac80211: fix incorrect type for ret
Date: Mon, 22 Sep 2025 21:29:04 +0200
Message-ID: <20250922192404.586990440@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 78aa3bc51586e..5f8f72ca2769c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1273,7 +1273,7 @@ drv_get_ftm_responder_stats(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata,
 			    struct cfg80211_ftm_responder_stats *ftm_stats)
 {
-	u32 ret = -EOPNOTSUPP;
+	int ret = -EOPNOTSUPP;
 
 	if (local->ops->get_ftm_responder_stats)
 		ret = local->ops->get_ftm_responder_stats(&local->hw,
-- 
2.51.0



