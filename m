Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016095;
	b=zNMbjns3iZJJf18WsejLQWef+u5NCUJU2ebnxJSLThEp7Y5IjuO8HqyydPy9WaEsdQRM
	 m3GyKvIuIMAY5Fp+EeuFd1k7A8347ZshCO7tFnXjNdYcupD+TZ11uS0QfBYGSaKRcoKrM
	 rdWYuzQr6me0hvVn2Zg7/kWa1P/MRbnuDjGpjTzeADJuyQU9oxo2mLK7yDEqLF9gOV4A2
	 8yehBT84U8idfoyNgXFkNTj/h5QTrImIaDqpT1TsHUCwkKJ7DObxlHjl6OSj+kcAKTCdF
	 YyyUc5Jjw8RKv2P7NbYRKXq6Mbyks6LhE8ls8dcY9qBl4fssEUCxV3KYxL8ny8v78Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CWDymRTAYN/8aP2nQEv4oFtdJl65qhP9J3qhiYee1+M=;
	b=Y8P9W8RWbyuxzdgFXHPzOKlgMr1i1SVo91t4cQTGvl4jTALUnxiKasZOqMTMd5MC16Wq
	 HXc93Nz4Enm9S6wp3N7y8ys/yTquXJfRmC87MkjDTcjBa0IYJgRI678VCg2Ows5ZbyPtX
	 EPHdoOSQgBdBCSkyaZVsL6IBRA73fe25g485xtA+Q4Q63QErNumdPD9cyIsZ+svvphB2F
	 V/jLQtNwS+scftuiGChiLnrk2bVdLo4/VwSRsX0m0vEZJYZ/c2bCNQTktHrhfwu6FtLev
	 ms/jJfLK3hB0qer4chQMV6jMdg7H+X3+/AOEtwIiWGch+wfW0+EjWTNSulmfNHyHB0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlPabnch;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB66606A33A;
	Wed, 18 Nov 2026 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlPabnch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3981F000C4;
	Wed, 18 Nov 2026 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016095;
	bh=CWDymRTAYN/8aP2nQEv4oFtdJl65qhP9J3qhiYee1+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlPabnchpjIq0+wvenmgO9PVUU26ZG+XATHuNRN6sPikVpGX0btfAKRrskehJc3Ge
	 SxBWJYXI61MdGXaMAhcbK8AENyrwPRUIfGZRP5icHer4lRpkUnVZFeOgp5vkE5H+yz
	 YiQa8JeHe6/vyaetGNOvdr9SSF/eqMTy6unDudIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0407/2651] firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kernel-doc
Date: Wed, 18 Nov 2026 15:27:27 +0100
Message-ID: <20261118150302.484616623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 05e3aa8fa8bcb..4f83d6babc921 100644
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



