Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B2F4D8CE;
	Tue, 30 Sep 2025 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243944; cv=none; b=Qxw/MKecY6STH6urkpusceYp6Xe7UiASJ+cRoxRALWZMFzHPMsuaSseYPH47ThSUClYfq4tmU0eLXxAfzIviOOssYIONjuNRDrD6gjiPOu2qtotpPwOxMHvnw1upjrVHc0mDidVEVof05OdqgwER1oCk4BdxuvbsGEuhqE8Zrns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243944; c=relaxed/simple;
	bh=bB1gNbTGSDBx4H84/l6Q4a9As6pGuFR8iQASBZYsuPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQJAtOdEHR4sBHce4qd96+b1snnyKdMFnnJAlT2nIybu0FE6M1IVgzv73shX5MQ8iLTvcIMfp6l2KtOzJQBy1xlz05AihPbUVBmXvH+O95vNRF7USbO9tEnbBadNcSQCe8q2dlWgIkPzjfI23AHxtV8UmlE+cH+DhpLqa/Q/qR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GP0Gabj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GP0Gabj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD946C113D0;
	Tue, 30 Sep 2025 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243944;
	bh=bB1gNbTGSDBx4H84/l6Q4a9As6pGuFR8iQASBZYsuPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GP0Gabj4ZgNpTTivRiYckCg5xvLzd/W9jVrx62E+G8xQhhWKYnPac8FRVurnihTBS
	 6Cy4S4V5IUt9zzIwof4CHhuJXLxtcwiHEZGI01UdouFzahmLqocDWYFIKGzL0vIT/s
	 ssYhYVoiEO5eNo5ITqC8alxg89zsENMaJSBw7zZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/81] wifi: mac80211: fix incorrect type for ret
Date: Tue, 30 Sep 2025 16:46:34 +0200
Message-ID: <20250930143821.010465576@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f4c7e0af896b1..ce902f8a08942 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1237,7 +1237,7 @@ drv_get_ftm_responder_stats(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata,
 			    struct cfg80211_ftm_responder_stats *ftm_stats)
 {
-	u32 ret = -EOPNOTSUPP;
+	int ret = -EOPNOTSUPP;
 
 	if (local->ops->get_ftm_responder_stats)
 		ret = local->ops->get_ftm_responder_stats(&local->hw,
-- 
2.51.0



