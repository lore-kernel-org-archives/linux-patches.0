Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029478;
	b=e/KON8Pmk0M2kB8Q2ZQqzBC0jIW9jP8Y47PyJG+Xs/TPKPlu6ErURvD3Yj99HRZMWAQs
	 oqUvxQITPHqZmFjNfsqfZV5ponH46jFiLUw2RseaG/0bcmWnYfAwmFFHQLkl0x2rlYgH4
	 sB79+sIkPGbwf8GBCXPC11hFpUWaWGAKPHCWBAgJy5Drl+Kuoo3BLdPWCbBV3mLRKoAHA
	 tO+aN4rPEgp07blRAgMbxBRm6HnCtKPF2o0U+xMWul7cBiMAOcGwUxTvxQhJ6NkFPkttZ
	 0fO/fgvSe6e6Y9z/VDXt4u5MyyXaHLMR0Jp/r7/uDfKj59RRHdW2XLbQ1nJNamH3MSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SwyQWt2wSp9aiO7yqpIkvzww4jKMZK84Szx8V4Wyjwo=;
	b=zZepNIBY8t/OG/3YmEb3Lh4bDolHtoyuEdA0tYdRofwoyD8Yke+SGRJBSjx4ao/VxcAc
	 BJ0+neEPeopczBgDDcg0P2mojD8b9khCV95wc3ylpPvlKxNl9DUeUV4ipWkf2516UbOXV
	 Wy0Af/6S6Df+2M3Ed9I+3uJKoHjZ/GE3H2MWNQLlbxTt0RLPKkGz5oyFhBY5HxtDrm9Al
	 PEmbLmW+4xEsOZVFb0E+KcJIYWhXpyvTbzaKVr3xqC2MhXXDWpp3sGpWUyb81++cPuPBc
	 PddAqlZGdKTawSAn7nyjUaEMFE7vOxdhvEHgEh1qIRQxL3azIvTXl7NdHNfZgVzG7yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNEGBcrl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE4C606A32A;
	Wed, 18 Nov 2026 19:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNEGBcrl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E511F000C4;
	Wed, 18 Nov 2026 19:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029477;
	bh=SwyQWt2wSp9aiO7yqpIkvzww4jKMZK84Szx8V4Wyjwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNEGBcrlnnACysX8hQ1Bbfs6jyU8Oi69ooMNIRCi/uWbl9j3b38eTDyrbxfj+HlNj
	 FMpxFPBd0btB3aee4vuWWabODCqnzB/gWmgyoWOR/JtSjTZGSKINXTLoH81i6N5QgV
	 YGWnHNISIFk0OrwkieJnxooEzBZNszpVRZ13mx3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0362/1756] firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kernel-doc
Date: Wed, 18 Nov 2026 15:41:29 +0100
Message-ID: <20261118150022.729933232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



