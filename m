Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023501;
	b=a2IyNiOauRlp2CiaPA5MGWV1cocx1I4N606LXW67yjAoGAOIvDNRFqEPxlG4U/MMQ4QX
	 M4XTkwL5gobsir2UjZpna74ViLaOTprKxTan1VukYKB+p7cdVgKsYba6UhffzJG43ytVM
	 ZTDcK92z/GAWqR4kReda2o+tGF1ahW8fzQNZt1cgryMy5nb8dQ63HC7d0y4G8E6pEqAyO
	 +IuSnsHekoDl/9xJJw03TtedRCZ9GtrbZIq99M67ifAwpgMVbhcdqvyPi3TQliVy3YVsl
	 xzGWJbhfyfZIZmy/Gbvxqas4IvA0kyOWq/sQbCU6yXTLh8jZI5Z9w+wrt7GwrEkVK0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G/puEVfCiRX0DXQhhMSXtOF2azLj958UfD912Ivufp0=;
	b=Tciuke6itGnblgE6sHDT7Dy3dG7tKbm4D9pZXQZDzDD8SB2YISjdyCRAG7vubswjyde3
	 1W/2NA3QXWb525HBSi+iWx18ScoViZ7SEE/QZFtycbgRQssV6poW8uB4/P3KALvPoBZpm
	 q5EiMPc/1/FlbO7M7NnVT9TNiu5qxTuaSfensavzB73Jdb6VLxUPxCtaMQce+f8rKamat
	 xbbg0mIWkudzHbhXUI32Eu97NYs7TFEOHi9CaJ6XzPEb6oFXGg9ZqovtdfdKoZE30n2g4
	 IQlbSs+YGVeuq0qYJIpRtiV5Szo9eaUZxXxO9s6UTKUNDHNUUryOcP8Z8EJLwp7yMfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZpnvI9yu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDB760A2613;
	Wed, 18 Nov 2026 17:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZpnvI9yu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6201F000CC;
	Wed, 18 Nov 2026 17:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023501;
	bh=G/puEVfCiRX0DXQhhMSXtOF2azLj958UfD912Ivufp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpnvI9yurtpAJF64fXQlbd2vJe5VqV87Yu5RYZHDqQEhd6sNl0ZSJR1iFuv2rl+/u
	 wdKPLr+lu64MWfsMgm/lrmesJw8ou0Cj0Ta2/Jx99/uuxMxILezd6TQRAPxv+I+8IS
	 EArStRfTeEAle9O+H1vEQ0kD0QDbbYKP1b+AF8bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0393/2151] firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kernel-doc
Date: Wed, 18 Nov 2026 15:35:28 +0100
Message-ID: <20261118150136.381861145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



