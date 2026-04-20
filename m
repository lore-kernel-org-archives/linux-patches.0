Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D43FBEC6;
	Mon, 20 Apr 2026 13:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691584; cv=none; b=GYyPUrRIuC0UsKtzYsoGNh6wzcUmN965oYGHAdH4MoMfepMwkuC8PsEB4qm4JXpP/0H9Wl4GxFnMPFj66eXr3nzBEAu6YX3Q4h988nifE3MHRtHnSSSgBVPoaYyxL/ymAz9aLkusvKn7zuGyNb3Wv6k8Z1qZkPJvge3Y2EXdb/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691584; c=relaxed/simple;
	bh=8Kl05HiBHwEfwHH9YuoTloJnfPUUgtClPJq6PnUcMgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnRGEnj83IUzjkRHoG+LcvXFyhcgJ1BfTYO5l0Xhzfnf6xRN33qxt8DR4Mkubf947FU4MNrDtSO+ktGpQ0H7QO+i8qkyptVGf8Q1NkN6V+u8dPMDj4XkQ23UdTd16ng04TWPML8Ooy6DskNI7eZRJUc048+NB+GnpvfIUK2Hcw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJFzNkeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJFzNkeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7FDC2BCB6;
	Mon, 20 Apr 2026 13:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691584;
	bh=8Kl05HiBHwEfwHH9YuoTloJnfPUUgtClPJq6PnUcMgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJFzNkeH1V3dUWuTuBYf9hscK/qVfiligYe7r2jwLC1+pS/xU/9rKiM4XaTM4YoGi
	 y9bwSYvbPt7nE+KzU1Gx/jvQ8tEKI2Z7f2uN8RBZrR7NiZFqyuPTMKsuDnXYlepiTL
	 29ZORmVwEToWLZGafvyipKf0kDcTds65H8Lnn6PanERarp3xmNKfTzqy22iK1XzFIz
	 xQbMlhXkBj8vXAeZ28xzAUWb+2HEGve879aTX91DIX00K9It14cctrq0X5z0r/W6GG
	 4WYz1aeK5v9Sc35ro7pw9Wyov2T2p8N6lRxdLZAv/aVZII3W0ZsO8T/ViWmOcHnQni
	 tCtMIpT+hDbng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: wl1251: validate packet IDs before indexing tx_frames
Date: Mon, 20 Apr 2026 09:18:29 -0400
Message-ID: <20260420132314.1023554-115-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0fd56fad9c56356e7fa7a7c52e7ecbf807a44eb0 ]

wl1251_tx_packet_cb() uses the firmware completion ID directly to index
the fixed 16-entry wl->tx_frames[] array. The ID is a raw u8 from the
completion block, and the callback does not currently verify that it
fits the array before dereferencing it.

Reject completion IDs that fall outside wl->tx_frames[] and keep the
existing NULL check in the same guard. This keeps the fix local to the
trust boundary and avoids touching the rest of the completion flow.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260323080845.40033-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/wireless/ti/wl1251/tx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index adb4840b04893..c264d83e71d9c 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -402,12 +402,14 @@ static void wl1251_tx_packet_cb(struct wl1251 *wl,
 	int hdrlen;
 	u8 *frame;
 
-	skb = wl->tx_frames[result->id];
-	if (skb == NULL) {
-		wl1251_error("SKB for packet %d is NULL", result->id);
+	if (unlikely(result->id >= ARRAY_SIZE(wl->tx_frames) ||
+		     wl->tx_frames[result->id] == NULL)) {
+		wl1251_error("invalid packet id %u", result->id);
 		return;
 	}
 
+	skb = wl->tx_frames[result->id];
+
 	info = IEEE80211_SKB_CB(skb);
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-- 
2.53.0

