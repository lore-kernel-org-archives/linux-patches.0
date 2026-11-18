Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060542;
	b=i/RTbWGtaNuiI15DswyDkS0NRg/LRs6rjtm5jJAFBt0lLA+vQfIoa2lgBXJ3TxEXDG9X
	 K5TTpecg/bViqQSzcrP8Zw/k9mfvFgStiweKFASLYcLez8pKCbi0miPEIHHHMuJgQRKe6
	 +c4GrI3/hnlQjy0n8ecQLE10oFgkf9zIqF8LkQp2Kfk6LBVFadLl02xqosd1mgLlP4K28
	 M4PxwbPyMD9xQQHdbNXol4YcbyUzlv7SC72nvel28hNtQdmjVsAq2/xtDUFwhAbboZJOJ
	 t9CcplTbEN6GlhSK3iZrcJ3+IgE013///VKJIetQWl9cQVS0mPXIJNaC0Zka7UntKQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VxpjLbHzkfdGKRgiK3ckQjlRMAQE6yALYGtUdflmP1s=;
	b=bBqm3amfrSAGvP/K0wbJtX7qk6Mz1VWARno5pqkKFZZVubbj+cYCQYNFBShhVnWTxgSK
	 Ie2xlI9JWyKO78I8CHXYaGJ9CucwItm7REckjddSs0Yi+KCwEBZH/PTB8QqN16/ODwqBJ
	 cOw4AgYi70/MnIsftMu+PSllNpwdAN4E3FlbL/kTSblvmrdWxrpA5+39A9ZLXM4P52K0w
	 d89LK+7cLQW/OAz1ghQjC+p/HwMq+Ih0wPFXLjVIdnLhDlYLZA8JMxmp85e41V0DufuJF
	 cqqyeH/6MmdaH7jMam9PJQbc/bBH1ctpgLgkfnxEC8+QsCWxbP8wvyuIB3bqRzF02Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u2TiB/5o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABED606A32A;
	Thu, 19 Nov 2026 03:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u2TiB/5o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F401F000C5;
	Thu, 19 Nov 2026 03:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060542;
	bh=VxpjLbHzkfdGKRgiK3ckQjlRMAQE6yALYGtUdflmP1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u2TiB/5o016K64XIZF94tT/d9r+UNNNt1nWAo/bRryp7+9sfCSSaaLR4YMd8gAFh3
	 cf+K3pv17ifmKRpyhxbtFFm1dDNfGRxP9dm+c5HV8m3oKWWSfAu7g+6lMmmOpPMcDD
	 a7FbP+iMKJHggYGGVDh4D53x6UgarD1CqoqJPaOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1234/1848] firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kernel-doc
Date: Wed, 18 Nov 2026 15:54:32 +0100
Message-ID: <20261118150011.531057320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7e5b5c10a49c9..6eb666be0f916 100644
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



