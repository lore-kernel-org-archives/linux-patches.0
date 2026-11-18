Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039648;
	b=VgasPY3RJklf6eyqscPoczO3Dv+fSw4NLnaZgfikEsVzVuTNROPqdoWBnxQFgPs+Z5l7
	 5mHjUnHiPErXdiFMG2TnUuuRBIEgEMitpjC6YiU2rowjUxxcvGbNf8iCB9kIPzbmR26va
	 B4Qj6q8UPWj5RtEVvIyqdkGuXphg0lsJp2LJcOO5xK9ymdxEWwMoRYJsLKxYKyg3Gm339
	 62xhwexC5MnST7xPomjKNgKUT0Knu8M2dVk1JspJQJ2rSqkPTU3j0Gl4ZRhPeJ7wytkNl
	 LbPMJ03/2+h2EAV+IDUXx7l/msrauJbHjimHhdtbbeZ13hQoZwzv7qcWx2KyF0r2pag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZwnpJX+qlQedEF7xAIQ6SaR61sUNtFhbl8+8++cqZg8=;
	b=GvWMSRF6aCLvS3ZFAxuSQPylof4SqXxXH5z8hNqKoN7czqmLLtAO1r37UT6tvBIZTS6c
	 6OJ/VwBjJ6heWKNVJCVxdjBkD4PYtuydhP1qQB4tSy6/iAMbIjmpQ8CrO6hvznN2BEnPi
	 WLAVMio02uQYoU8hM/NSlllWnk4X5LtseZDfWVnpUuzjGpJ2Fn3ljWy7bbPtecj8zDO1D
	 wgCskNjdD+2hvzuIDJiV2XjPltm6SYF8LXyim3lrtWMfULIeqXJ78aGOkunzlUe5QA9rj
	 Sr298TIEsCBrWL00el+apfq0zirmeIbkzYlDNR+pgXnEu4U5lEXWZ2RFd2Zjum7FtIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuQ+RQDL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F34606A320;
	Wed, 18 Nov 2026 22:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuQ+RQDL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1D61F000C4;
	Wed, 18 Nov 2026 22:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039648;
	bh=ZwnpJX+qlQedEF7xAIQ6SaR61sUNtFhbl8+8++cqZg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuQ+RQDLJGMFQ7CKfsen3clE59nDAcpP4aixjdSIg72x8xb1jYIHtGD948zPyJRRO
	 9zrb+mtK1d0WaUL5KRwh6uVt398aIhevUjW5XkJCpjXu3s0oeC1Ig9TigxoApgRzFp
	 EfCdA6JBar0r+08STh795R2EhRpm3B70WVfPGkyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2174/3318] firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kernel-doc
Date: Wed, 18 Nov 2026 15:46:36 +0100
Message-ID: <20261118150427.198462057@linuxfoundation.org>
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
index 1f2c9469f9214..48dd3619adaa7 100644
--- a/include/uapi/linux/firewire-cdev.h
+++ b/include/uapi/linux/firewire-cdev.h
@@ -293,7 +293,7 @@ struct fw_cdev_event_request3 {
 /**
  * struct fw_cdev_event_iso_interrupt - Sent when an iso packet was completed
  * @closure:	See &fw_cdev_event_common;
- *		set by %FW_CDEV_CREATE_ISO_CONTEXT ioctl
+ *		set by %FW_CDEV_IOC_CREATE_ISO_CONTEXT ioctl
  * @type:	See &fw_cdev_event_common; always %FW_CDEV_EVENT_ISO_INTERRUPT
  * @cycle:	Cycle counter of the last completed packet
  * @header_length: Total length of following headers, in bytes
@@ -353,7 +353,7 @@ struct fw_cdev_event_iso_interrupt {
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



