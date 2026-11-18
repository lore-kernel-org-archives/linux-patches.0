Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039651;
	b=X3aABOoYuP37T7chPu/wggX4kxubXgrOHTuL1eZhD5DuZfB0yHHmXoZdtktBHiueGjdv
	 a77Jj8afCs90m58AlOzy/eNy2hvMCY2EZVMhCJvDzudOKPE7alyHNSqA/w+qr+HoU4bBU
	 P0cKBSfY4w3QHpmOgDEbiIuQcV0t13Lh3NsRK/Cbdr4PExEEhtcuIKMtyTsMozLMNZhMW
	 AV2AifP+cPrcYBCakrduiKOnTB1+T183Uu5t+iK1JK7WSXESSuXqsmIxwL92GcLFD4eB2
	 etSnQnt+k8OYK8TqKx98QrQNSKNu2IsxioV7fSWtFvN1Muvt044DvF+x6752NkPFT8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Txqb28Vu/cO4OSYFMZx16d8FZBhSZjmsEyrmrG9zC5c=;
	b=vWXkfoSVrU5N9vfP28zqcUWYw9gpn4kX2+9vF6pAcEd7xqs3SaBmoa9adZMSDXcGGHt2
	 6iNAg4PlFKHQCcDxs5DoAfjzbzfCcxSKeKyblnBhww1X584FeoUvyHW9rQv26ky8GPJOd
	 UBn7f+7DV9Nukihei72Uw4tXO7wgHP36Yu5HJbr0de2Rn0BxdHLsXB72eybXBnxQi4LAe
	 K+9kY65tO8gOYKJGX4Hq/gsRkbnFO6LXy25ChPnMVMQqJjvqLpmYHFH7Bg04CVwxNvskX
	 A9pWVkm8WsegD+T4N/UFeC/GppcEjKiI12Yh5f0ey8WeBmqYUPeW/yRJDoPVO2XJndA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxxr73I1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F6B606A31C;
	Wed, 18 Nov 2026 22:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxxr73I1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFB31F000C4;
	Wed, 18 Nov 2026 22:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039651;
	bh=Txqb28Vu/cO4OSYFMZx16d8FZBhSZjmsEyrmrG9zC5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxxr73I1eUyUskp3gWACsxLozN8bTS98dnwWc/CIGUJFgLX1yDqaE1LMBkoEupyDs
	 bgm8Ezxv0HPbQFPbTHkKMBWVwEEIZAlVf8dYRa/oRlDC+bLRCVbOT/AAk82b+wZfXq
	 sBceW6NcLO3ZNRl666gWQePVdqhR92pOZpKe3PvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2175/3318] firewire: core: remove unused link field in fw_packet structure
Date: Wed, 18 Nov 2026 15:46:37 +0100
Message-ID: <20261118150427.226374980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 00d4d31e4fdfe51312f0184f8d162b8d4de172dc ]

The link field in fw_packet structure has never been used since it was
added.

Fixes: 3038e353cfaf ("firewire: Add core firewire stack.")
Link: https://lore.kernel.org/r/20260911141602.3288806-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firewire.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index bd3fc75d4f146..6307d4409e2fb 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -310,7 +310,6 @@ struct fw_packet {
 	 */
 	fw_packet_callback_t callback;
 	int ack;
-	struct list_head link;
 	void *driver_data;
 };
 
-- 
2.53.0



