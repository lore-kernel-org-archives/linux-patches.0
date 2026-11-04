Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830886;
	b=tAPe/hoQgJvEXdN9ObJnu5dg0sVdwmDi0eYAlHrrgWgansGF2CKkjySEYK04ak69HDvh
	 x1b2rpWPswve8mB/YfyLSDbdJWypagl9GDKlYm1/fV7FoAkGlXUNqgmXPyW1eVCY/P7vi
	 UxTYvqJiOwK7a3duh4eJ0znyTrT/PLb0znfxdHfexEhBNiYUb5klzxmZygYYBNLrMra5x
	 +lJ0Xrtj5y/z9jUptiNSs8mrNDwxRJw+P2D9CdR9LI5qLVIxy3hXv5L23tAisU4owfHMU
	 H6NLe1rGNkoeOKAAD+dvEGo9fTRD5cJQKRSkYS/lNpxg/WCHx/olKwzb9inv0ZygQlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=57fscZ9Rp9V987RNG4hQYpLbpvC9rMRJdru+MmTp4dE=;
	b=oCAKTArwIq3tSB+I8gY+iOuO2vOqZ4RIeFdsBlkRRgvpk9OSYyhxiZsfAtTtBqBLNQMa
	 EgfHZ9QuIcRq1/9jbh3VoZn81LF33yzqnhn8Kvlnxmif5aD5RNxkHmBthTJNKIC8138cc
	 h60RXYkC+x+iF4+3xWNJOYh1adZIajqi6cnx72PsRGHPsLhbfDzkdIf1PXSggBVXEluVc
	 MD2zMEN8wZHtnwLjZCG+/AEp5Ag5OcOBGPg/BfMOCv9BrOS1pQHVVDxYrijK+Jzy07Zle
	 ddETwhyjl5Rur/lH4o3g7BvNVr5Tso1X5Iwn8O3/zl1uid6PKnxVfj0lfilUIlz0PWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MHLJmGxU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62B9606EE8D;
	Wed,  4 Nov 2026 22:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MHLJmGxU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCC01F00A17;
	Wed,  4 Nov 2026 22:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830885;
	bh=57fscZ9Rp9V987RNG4hQYpLbpvC9rMRJdru+MmTp4dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHLJmGxU1dhjFeLlIcnN8+8hB6V7vDtoafSI3tkactvN76mU/SetEu5QfwINXnbGE
	 s1ATv2J+pFYdo9/YR0K6zRbATn9/uSlYNSd5xZwbzX+4nGdR13AGrTXuu+jlWSSgpA
	 V9yZzJUOoD4WH68R01KE0gG4f/yTbECqiY4guibQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0348/1005] Bluetooth: btnxpuart: Fix use-after-free in probe error path
Date: Wed,  4 Nov 2026 16:01:21 -0500
Message-ID: <20261104211053.726752592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

[ Upstream commit a2b3b4f00403a3a40c5627d1bf537c8fb166e221 ]

In nxp_serdev_probe(), if hci_register_dev() succeeds but ps_setup()
fails, the error path jumps to 'probe_fail' which only calls
hci_free_dev() and asserts the reset GPIO, but does NOT call
hci_unregister_dev() first.

This leaves the HCI device registered in the system with its backing
memory freed, leading to a use-after-free when userspace subsequently
accesses the device (e.g. via hciconfig or bluetoothd).

Fix by adding a 'probe_fail_unregister' label that calls
hci_unregister_dev() before falling through to the existing
'probe_fail' label. The original 'probe_fail' label is preserved
for the case where hci_register_dev() itself fails (device was
never registered, so no unregister is needed).

Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Reviewed-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index c7acf6c7efcf6..870ce16ad40b1 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1924,13 +1924,15 @@ static int nxp_serdev_probe(struct serdev_device *serdev)
 	}
 
 	if (ps_setup(hdev))
-		goto probe_fail;
+		goto probe_fail_unregister;
 
 	hci_devcd_register(hdev, nxp_coredump, nxp_coredump_hdr,
 			   nxp_coredump_notify);
 
 	return 0;
 
+probe_fail_unregister:
+	hci_unregister_dev(hdev);
 probe_fail:
 	reset_control_assert(nxpdev->pdn);
 	hci_free_dev(hdev);
-- 
2.53.0



