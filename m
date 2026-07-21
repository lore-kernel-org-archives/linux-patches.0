Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF9544AB62;
	Tue, 21 Jul 2026 21:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669054; cv=none; b=hRm9YFGUVpckyN4g+Y1B/ZN26wRt+MiKXmTw96YOEV7Wf1SIjwVqwVwUT8jKoZfA+OAR4N9JuA5avnzZKZRulFDixPNcSyMvf17xNafJo9zssstLXMiLv1pt2+iaDoaIK0iCO9LFOnTAjh6fQZzfu41WUg3EEH6CroXonIbmBos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669054; c=relaxed/simple;
	bh=RNgHzDStoW7115/SW/ww6BJiqbbk2EGbgmW+E4P9q1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFfUZ3ZJcCCoZTfmQfPpxydsFb+LbptwXsMbUbYDqk7SGnvmwf4ECeNAr1F3K/9o86lXfgGddCtAMQgPWXFKVjzshAhKkFJx/+aaqVNtOsV+ElRccRuJc2vN/hi4LOkjf8JVuw8z5XrJac9RXR60JxDyLsP14fYAaUXlrfxVDsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6hIDX07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6hIDX07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9061F000E9;
	Tue, 21 Jul 2026 21:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669053;
	bh=16xUYEq21mlxM8iscj7SxM+uDgl47IcHuj5ULTZF+o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6hIDX07PbChWX4nfjB6aYwJpuCIgTHG14MArAasChtajRzhwprXuMPtKP9FLNdb3
	 UOg9Xsn0lHpvbEdeniO9ise6csdpzFw5jHN+Cn8CAb/i+DjdMhRavKroJB6T0M3YTb
	 3kur8TDLn6VngPlxj3DR5empe8mgjmIRpf/UCWSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bjoern A. Zeeb" <bz@FreeBSD.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0408/1067] wifi: mt76: fix argument to ieee80211_is_first_frag()
Date: Tue, 21 Jul 2026 17:16:49 +0200
Message-ID: <20260721152433.757096384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Bjoern A. Zeeb <bz@FreeBSD.org>

[ Upstream commit 5832743279da8c6ae72f715bad2f7141eca6f4b8 ]

ieee80211_is_first_frag() operates on the seq_ctrl not the frame_control
header field. Pass the correct one in; otherwise the results may vary.

Sponsored by: The FreeBSD Foundation
Fixes: 30ce7f4456ae4 ("mt76: validate rx CCMP PN")
Link: https://cgit.freebsd.org/src/commit/sys/contrib/dev/mediatek/mt76/mac80211.c?id=c67fd35e58c6ee1e19877a7fe5998885683abedc
Signed-off-by: Bjoern A. Zeeb <bz@FreeBSD.org>
Link: https://patch.msgid.link/83s4psnr-popo-8789-757o-npr2n9n7rs2o@SerrOFQ.bet
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 82fce4b1d581be..5bcb2837efaa98 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1060,7 +1060,7 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 		 * All further fragments will be validated by mac80211 only.
 		 */
 		if (ieee80211_is_frag(hdr) &&
-		    !ieee80211_is_first_frag(hdr->frame_control))
+		    !ieee80211_is_first_frag(hdr->seq_ctrl))
 			return;
 	}
 
-- 
2.53.0



