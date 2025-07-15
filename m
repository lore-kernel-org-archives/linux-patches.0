Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8701F0E26;
	Tue, 15 Jul 2025 13:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585519; cv=none; b=WzxuFJ4lN6VixUYylG+Gm8DINGElY2gXm5QgpLsxNtzDNssP/KcZ4DA3+GVKHbpUhZ4pS9xV++kcY2GI12n16NJwSphCEdEyfEkyBhEuq+fV2ZHVOxEx+yK78x0Jm0ZVF2ELfPuaEBWTusRqn2mYBtO5HpzW7EuJ+NaCgbyMxC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585519; c=relaxed/simple;
	bh=an8/+5iYyOe+R/dccTJRxoBCyYNb8mx1VwzqLQ3KkaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf3Jz5APnqsK1kxzzovMiU5kV+iAaFfMBV6tWCo21fEWO9jTi0pzoRNBL/rK+Wxno5tVAWXjL6iAVM70Wvs9jaiRosUI8bZBKRLWZCMkogeBKPV7J30FVagvDDpepH1wCv9zlxTVNOdbfIHi1OVL3P7AZ3H0eFX1XWaZS/GtjrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRwzlsPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRwzlsPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E13C4CEE3;
	Tue, 15 Jul 2025 13:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585518;
	bh=an8/+5iYyOe+R/dccTJRxoBCyYNb8mx1VwzqLQ3KkaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRwzlsPboBjEfIzzAcK17PmUb/aTUXDxitd31Y3PqVqhQMNSia0qINm1EaT5fSTTe
	 3U4J3R58fWXr/XKGLsaMHZPSvNqqIAg7kM9wt13JKvRU1G2knBttTg1exBEUkVPfG9
	 XjrP11PYRFOylaR/i6BrXRnytpYTnDyKn4faAGrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 070/163] wifi: mt76: mt7925: fix the wrong config for tx interrupt
Date: Tue, 15 Jul 2025 15:12:18 +0200
Message-ID: <20250715130811.549523882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit d20de55332e92f9e614c34783c00bb6ce2fec067 upstream.

MT_INT_TX_DONE_MCU_WM may cause tx interrupt to be mishandled
during a reset failure, leading to the reset process failing.
By using MT_INT_TX_DONE_MCU instead of MT_INT_TX_DONE_MCU_WM,
the handling of tx interrupt is improved.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250612060931.135635-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/regs.h
@@ -58,7 +58,7 @@
 
 #define MT_INT_TX_DONE_MCU		(MT_INT_TX_DONE_MCU_WM |	\
 					 MT_INT_TX_DONE_FWDL)
-#define MT_INT_TX_DONE_ALL		(MT_INT_TX_DONE_MCU_WM |	\
+#define MT_INT_TX_DONE_ALL		(MT_INT_TX_DONE_MCU |	\
 					 MT_INT_TX_DONE_BAND0 |	\
 					GENMASK(18, 4))
 


