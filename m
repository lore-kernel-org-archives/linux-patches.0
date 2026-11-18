Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048314;
	b=eVHU9SOl2hVFCYeNboPyIVldp+axHj0eOkLyExMFFXphyPT6T4bwX4hEYoyWhjF+iiT9
	 ai1lgpwUC/7/aJ+3wtpKK/U6RMPixBtsHliBoX4SIU9SGqhh2hKLnIojUS34F1kSbmvJn
	 0Ax/WKYDT0r5dnsn/XiAeiFvweqRsTB1AfTZxhN5+sQxdq/iYLTK4yN1K46Nknj11BPGN
	 ddMaUwd4xhhH6trVqRQX3k3CNB5/B8/FBfHgFuz9hSYI+H45rMN1zoisUPiG2bI49JUc6
	 cvalZFKlKIt56oWrx+DulhUqa13T9kJkKWAlBAvxcrL434LRVM5UALEHok7acLaHnsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xHQ1FDfjOgqQZiaznE6yFI+0r1kPpm5GlV01z4ey/3Q=;
	b=UQxlg4bXj2wpAgsW9Bah0cPKiANI+Qb2jnK5S/Ic8085vk9Md/vDmk5vAl4gG6Ano0kW
	 /ll1rNyq8aVUypEOtqlIbtqcRUMSiDR8zGVVbdwhUYf1TeDSCb3dn47oNSFxq+HaN9PO7
	 aY+dqhZOA1KGrKo926O36C9FTEtLe9EECVrDTzz+PR1eF1sd/7lyJ8bcgyBJisovBfOAF
	 MNGoF28Pw8JPMRuGVzNlS8n7nJfV1SAAs7j3dIQZrbBs1SpNiAqa5lJkEL41PZgs2NHH2
	 7keWTfq1LUYWMX3a73CpPslzayQarzOiT6xq0gBNA6SLbRa4+QIuGSza5DZnq5TabSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syTTJmod;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013CF606A32F;
	Thu, 19 Nov 2026 00:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syTTJmod
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B191F000C4;
	Thu, 19 Nov 2026 00:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048313;
	bh=xHQ1FDfjOgqQZiaznE6yFI+0r1kPpm5GlV01z4ey/3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syTTJmodm0xDLeUUnu3K0OxLjL2SQBta3KBey1CzNZQmQtgw6ex681q1cWvSDz8BO
	 DUxNrhHRuYaNWOOTZOBDVh8VMvzA+3Ra2GnicW6P0JCTP5e3hFr8oWmD2gi50v/aKn
	 /gjXgCTMOiT6B3lPH4PT23MMt+J56a8AhZ9T/4Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1899/2857] firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kernel-doc
Date: Wed, 18 Nov 2026 15:48:53 +0100
Message-ID: <20261118150309.615119503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 0a6cf2b7adcbd362039e9d282f73aff3f24022ca ]

The fw_cdev_event_iso_interrupt and fw_cdev_event_iso_interrupt_mc
comments refer to FW_CDEV_CREATE_ISO_CONTEXT, but the ioctl is named
FW_CDEV_IOC_CREATE_ISO_CONTEXT.

Correct both references. The misspellings were introduced separately
with the userspace interface documentation and multichannel reception
support.

Fixes: 7ada60e36764 ("firewire: Document userspace ioctl interface.")
Fixes: 872e330e3880 ("firewire: add isochronous multichannel reception")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260911222807.7673-1-kmehltretter@gmail.com
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/firewire-cdev.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/firewire-cdev.h b/include/uapi/linux/firewire-cdev.h
index 92be3ea3c6e0b..0d7870249ab55 100644
--- a/include/uapi/linux/firewire-cdev.h
+++ b/include/uapi/linux/firewire-cdev.h
@@ -211,7 +211,7 @@ struct fw_cdev_event_request2 {
 /**
  * struct fw_cdev_event_iso_interrupt - Sent when an iso packet was completed
  * @closure:	See &fw_cdev_event_common;
- *		set by %FW_CDEV_CREATE_ISO_CONTEXT ioctl
+ *		set by %FW_CDEV_IOC_CREATE_ISO_CONTEXT ioctl
  * @type:	See &fw_cdev_event_common; always %FW_CDEV_EVENT_ISO_INTERRUPT
  * @cycle:	Cycle counter of the last completed packet
  * @header_length: Total length of following headers, in bytes
@@ -271,7 +271,7 @@ struct fw_cdev_event_iso_interrupt {
 /**
  * struct fw_cdev_event_iso_interrupt_mc - An iso buffer chunk was completed
  * @closure:	See &fw_cdev_event_common;
- *		set by %FW_CDEV_CREATE_ISO_CONTEXT ioctl
+ *		set by %FW_CDEV_IOC_CREATE_ISO_CONTEXT ioctl
  * @type:	%FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL
  * @completed:	Offset into the receive buffer; data before this offset is valid
  *
-- 
2.53.0



