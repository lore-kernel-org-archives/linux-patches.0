Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212766;
	b=ZWPg0oIop4SiV/zuEGnpeZ2fsI1O1FXInasu3gUz7tKkUL2p2097srJTN1LNHxV5McwY
	 8hj3lBJyGBeTIgG3Suac2ewkGxokidtYeb0pnMsEaL8/w9tmp8lWCl2lSoj4Bd126fYLX
	 Rsn1vTgxkUjo1zWksskXnqkQd9XrBcimRrg1ndH/5EOrWjXBI7bNo8q/eJ7e9cZN4BfdH
	 WgjFEVQqsHgof3MNmErH8Xtw+qkktObthMiXltwQg97UulK6EmdOgiOQtqp3ZN3CGAz4h
	 9cvBcyFYCZ8smdofZ0We0efUs35s0OVkFlZRTpQ2DgDG0HlRQWYX+5OqhxZpwvbWWRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9mXvs/JVdzO6t8t/rIO79ts1xPJH8FeJlErq/ISxJho=;
	b=AvPeyX7BJiNtd8Q1REC2UuHWsCAfHB3Mm44Mtbwy6HZWxGEtIRoRoUFsN+ToSOQBPT3N
	 Q75yJ4pVvcXOVibTC2XqaK3IBII2d9rNEHprAKXjQvwMLLLGIfCdqDeXdX9m1CMF7Ma33
	 aK8aW87VBtJixHTibNeIDJtBkXGsExFgG11XjczGApVAYOYpL9N6GAY2A5JR8GY905HF/
	 IoOdj4XYmxoOPj3q6nt/ij/s8Q991USERLmTVu4PNvUTYX6kStqN6QZs5tlzm4cOj6MzV
	 ZhXDx+5a/XNWiThuIan9bsE0+vY/zGUzHNhDoExlPqjtVD/00nRr+zv8MNlFw8dcG3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFi+RCgH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719DE606A322;
	Wed, 28 Oct 2026 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFi+RCgH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C401F01828;
	Wed, 28 Oct 2026 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212766;
	bh=9mXvs/JVdzO6t8t/rIO79ts1xPJH8FeJlErq/ISxJho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFi+RCgHzgeNHsnE7cLA0shsiRVcYe0CTx7MqzoTTKrLC/AnjbDNVPqgzd872nIdG
	 ksHShUGMNcfEezqAjfvOGRm6zRPRacCqXrvrofN1d8gp9ZsnTLMGij5LCfGxHvlXwz
	 ZUJCrWkj6jWQ54tPuitJGQE218Ig0nofOJOKxKps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
Subject: [PATCH 6.1 0269/1887] usb: storage: sierra_ms: reject short SWoC info transfers
Date: Wed, 28 Oct 2026 17:39:25 +0100
Message-ID: <20261028170505.351855835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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


