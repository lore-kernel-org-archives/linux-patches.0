Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E684B1C6881;
	Tue, 27 Aug 2024 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772813; cv=none; b=qE4j8KrbHaBQu4yY1XhkW8608TZm6mPuH+LtKN1G9sg9R6qSMLHZ1vBvvUM5IzVlu3BERofhtUWyunnOZbdiQdB9QG3mas9DfZtai5ELfSc+5PcOIVX8zyJLN0X0NazQnrjTQO7G4OHS1PJ97CAkopqOQIbF+z7UGT02cVihrQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772813; c=relaxed/simple;
	bh=2qtbzOXbyITtVG5OmkK0xLp/pQ8Nt04H4+J27xFUJDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Peu4F2N8XaNXd03055dVQf9NaPpsC6oD5rIeYe8XovToLO9mrTt2gTc1z8HI8RyPSaq9hZOJjoXx99AthGVo812lT28zyyc5iXwJK6XWcHxHzx8bZtIrzRCUXx7+VdOh7wLjGC+iVZBrR6zDht0upQx/1W00/MFnLK13D1TOZYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHCMz/mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHCMz/mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559D7C61050;
	Tue, 27 Aug 2024 15:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772812;
	bh=2qtbzOXbyITtVG5OmkK0xLp/pQ8Nt04H4+J27xFUJDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHCMz/mjIxZChfM7ki69yC3Sg9baQy+eguTNDtcSnLisJ+ZDMbaqMFF45mp1nQMgd
	 57FFBJgHrFQpQU110BJhRxTTdsuwAW7kHRBJ24JCS+qD7jH2P4WponMuyIJ+dcX+AB
	 Azg2K1346S28XbVihVO7qYpAu+y5x1Ns3N6hzPIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 309/321] wifi: mac80211: drop bogus static keywords in A-MSDU rx
Date: Tue, 27 Aug 2024 16:40:17 +0200
Message-ID: <20240827143850.019243665@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

commit 4d78e032fee5d532e189cdb2c3c76112094e9751 upstream.

These were unintentional copy&paste mistakes.

Cc: stable@vger.kernel.org
Fixes: 986e43b19ae9 ("wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230330090001.60750-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2904,7 +2904,7 @@ __ieee80211_rx_h_amsdu(struct ieee80211_
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
 	struct sk_buff_head frame_list;
-	static ieee80211_rx_result res;
+	ieee80211_rx_result res;
 	struct ethhdr ethhdr;
 	const u8 *check_da = ethhdr.h_dest, *check_sa = ethhdr.h_source;
 
@@ -3045,7 +3045,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	__le16 fc = hdr->frame_control;
-	static ieee80211_rx_result res;
+	ieee80211_rx_result res;
 	bool port_control;
 	int err;
 


