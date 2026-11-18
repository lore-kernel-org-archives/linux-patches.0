Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033777;
	b=z9e+sYz+S2Vcgralz6ayBF0Zy0UfCFejqWEJZUi+BRrn1bv4kkOphzpKWYugQtvDD+tg
	 t53QK3DMmXXcmTC9qIkIP8vaIMza8rFcHvDMeYBMVTR4T2dtHZqSmAna2oRgCnwhWeQX+
	 Po7syWnRcpGDmkr0p7kqEOYp7oZ48DMuYu/MTr1mYPU8WUbc9FX7fQ/ZQ7+3b3RH3Mmkc
	 oh5xeT5yCqehT8xE9IpA5Sa3g1Y3G6mfWolB2ao80D5kAiiAGK941n2ZedYbE/fLiXpeb
	 FyNpJvdQ6QM1ySLYHZT0B76GpX/31DIG9DbKJDWg1nBzvMx/AfvcUKmqOOKAduNAXIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vCDdqNj+w1WXBs7+yppozyWPHJ3w3XrTE8o3i5qydVg=;
	b=2dnO/ZomVLkjeyGLKxPxS72RWb9qo5bYp8rddU1egpxmnpmu6uCRJDtflAR3qEAfKsRg
	 9O+ccS+j8m9bL61kFo/4Z16O047I6u448WFJMjvjfrTLGgWLZfP4S9tsif2pHEAw/sKIQ
	 Htal6B/GyUtszCfrhDEdVMb7mIPpFspiJL9LK8GKM4SbiObY/ODNETLwEGKcfGfWfm0Kw
	 vINgZXyt+EEfvqm5YbCEbYmgEGPv6pFMcHk0FWmSFfZkkPDi2UTjKComR9dwHaRj224fr
	 A0z0bO9mALLgISToQJ8Pjn3WSF0wK+MU7/dUUgaH4LrK19oZOzSRMfyyUxguh8K1SSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PL9lMFkr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F07606A31C;
	Wed, 18 Nov 2026 20:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PL9lMFkr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039F91F000C4;
	Wed, 18 Nov 2026 20:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033777;
	bh=vCDdqNj+w1WXBs7+yppozyWPHJ3w3XrTE8o3i5qydVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PL9lMFkr49f2YnFiwlWvHgAuvBSeowQKa6xuZwnFE9fsLKJdZU1giB9O8lZuxYiOB
	 WXZyMLoVhMqw/wOc5R4nnMc9VI4hKQPtUSktdwq3nTj1Dkc2vvtmScA/26T0Ts8uFu
	 vJm653JkimOb/qBOxIotdFbtvNdC9STC9kTW8lNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0135/3318] misc: hpilo: validate device queue entries before use
Date: Wed, 18 Nov 2026 15:12:37 +0100
Message-ID: <20261118150318.470977514@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 7bf6940d7cf41f1f0330a9bae4b7a886e18fd8e3 ]

ilo_pkt_dequeue() trusts descriptor IDs and lengths read from the shared
FIFO entry. A bad entry can select a descriptor outside the allocated
queue memory or report a packet length larger than one descriptor.

Reject entries whose descriptor index or packet length exceeds the queue
layout before deriving the packet pointer returned to read and write
paths.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624190919.3432-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/hpilo.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index f1b74d3f89586..55cbf5c65280b 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -160,11 +160,16 @@ static int ilo_pkt_dequeue(struct ilo_hwinfo *hw, struct ccb *ccb,
 
 	ret = fifo_dequeue(hw, fifobar, &entry);
 	if (ret) {
+		int pkt_len;
+
 		pkt_id = get_entry_id(entry);
+		pkt_len = get_entry_len(entry);
+		if (pkt_id >= NR_QENTRY || pkt_len > desc_mem_sz(1))
+			return 0;
 		if (id)
 			*id = pkt_id;
 		if (len)
-			*len = get_entry_len(entry);
+			*len = pkt_len;
 		if (pkt)
 			*pkt = (void *)(desc + desc_mem_sz(pkt_id));
 	}
-- 
2.53.0



