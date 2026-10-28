Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210933;
	b=4Sml5GzTz1rDejdnoV/UQVoapNNTFgfisanBJuEoRHutyFicRTjo2ViWuAzocQGN5CWr
	 oi9Ws6SSYdIcLw2oirI3svxljx1MT/zaPrxzK15x67NkpTBecPzTTL+XwkSKW8I+kguKO
	 QkttF/k/8M5ZCgLrvPzWNzd/Zyca/F7hE/j63cz8RQ54jSg+1GxmQkzX7tCAY0f6QZsZ7
	 OUS+jGl8BidVHPrDzTuwBmyEr5gEONuw+iH914uyCorUP5ZExjDinj+6xknZd1JSMmVwO
	 gND6erQa9ME0lpogZ6P/3vZnRUC2UqoEELWB4kFjBUo7mPQcsaLSRIC/TttFhtvrugQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N6lSs8NdZQsuUgmdvAf54Emf9SQFxpfduXJvRh9NdjI=;
	b=WGjVtM09+GoTWO8bYaiwJI6e5TG1AhLBUuEXQyB+wHkdl8rWp3cEpNxQHfCHd25V3DVz
	 F+3YfKlyQizMQs+EUPTearf8or98fOMh6Zi+ABVLbwYIWiy+lkQg9LOAJVvPB9C0ffmpQ
	 GTjSzyKjGYgotJ2j/G+h8WNpnl4Gg/YoNTel8QaINqAx2ACQaNJyLpHXr+sR1wrZV3IFX
	 h3KXaj1icn/SUx/qMckg7jHDOhT5SeYHC+KEOC6QL0aKR1iLhHhwKEpMgYJiknNDrxail
	 mz8tUXrAMuyD4kxeqf06QUE0VHRQwdoJgroP2xyzcll2tvwpdBGgYrXKT5H6yeDVbvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMjKwEQU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62984606A334;
	Wed, 28 Oct 2026 18:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMjKwEQU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39DA1F01828;
	Wed, 28 Oct 2026 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210933;
	bh=N6lSs8NdZQsuUgmdvAf54Emf9SQFxpfduXJvRh9NdjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMjKwEQUfzOa8fH5wRsHkgERTJCp8LGpu6+9kRkAZc5uyJMhkyhdxWgt/VPM6URuB
	 u1CUOTeKgngaMjB3iUuCgKY2FdCg4YmmITDmcWjvvEJJkxoAZvYYAUx4Apo7N6qO4N
	 EWHglA5Z5Gh09ccKRgAS3YRoVWGhtJJVMoOZpYUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
Subject: [PATCH 5.15 200/571] usb: storage: sierra_ms: reject short SWoC info transfers
Date: Wed, 28 Oct 2026 17:55:47 +0100
Message-ID: <20261028170012.753055154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>

commit 8a0200d14acd9db388b85cd016e68a4e60d900ec upstream.

sierra_get_swoc_info() requests sizeof(struct swoc_info) (60) bytes
from the device via usb_control_msg(), but its callers only treat a
negative return value as failure. A device that answers the
vendor-specific GetSwocInfo request with a short IN transfer is
therefore accepted, leaving the tail of the freshly allocated
(kmalloc(), non-zeroing) swoc_info buffer uninitialized.

truinst_show() subsequently prints swocInfo->rev, swocInfo->LinuxSKU
and swocInfo->LinuxVer from that buffer into the world-readable
(0444) "truinst" sysfs attribute. An emulated/malicious USB device
(VID 0x1199, PID 0x0fff) can exploit this to disclose up to 5 bytes
of stale kernel heap memory (kmalloc-64) to unprivileged userspace,
once per sysfs read, indefinitely. On kernels built without
init_on_alloc this leaks recently freed heap contents.

Only accept the transfer when the full structure was received.
sierra_ms_init() already retries failed queries, so well-behaved
devices are unaffected.

Fixes: 32fe5e393455 ("USB Storage Sierra: TRU-Install feature update")
Cc: stable <stable@kernel.org>
Signed-off-by: Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
Assisted-by: Kimi:K2 [Kimi Code CLI]
Link: https://patch.msgid.link/20260910140343.49371-1-syedlabeeq@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/sierra_ms.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/sierra_ms.c
+++ b/drivers/usb/storage/sierra_ms.c
@@ -77,6 +77,13 @@ static int sierra_get_swoc_info(struct u
 			sizeof(struct swoc_info),	/* __u16 size 	     */
 			USB_CTRL_SET_TIMEOUT);		/* int timeout 	     */
 
+	/*
+	 * A short IN transfer leaves the tail of swocInfo uninitialized;
+	 * only a full transfer is valid.
+	 */
+	if (result != sizeof(struct swoc_info))
+		return -EIO;
+
 	swocInfo->LinuxSKU = le16_to_cpu(swocInfo->LinuxSKU);
 	swocInfo->LinuxVer = le16_to_cpu(swocInfo->LinuxVer);
 	return result;


