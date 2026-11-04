Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831929;
	b=BqTRXloYgMgzvEez8XWWIqNkMwOrk58hXWcBDMs912BAYwAcIiu8JxRZx9ljHo39miKw
	 dLrvhtQodCoqAc9iL632GkHsicE/ATr+d+YoMdkrz1UXMdwSLMPT8uvIbZbUov5FwgsQA
	 bTDjNS9HEnfGnh4oaJEWRjvuez1ud5subRF0VQekIqHlX/SzPxQ+mcd5FOwihz48AY6tH
	 s2Qvume/xHoc1apZmrQxOFaKMLVQ5Mo0foS2kYyUfAxwOTXFSbIB9beV/r+tSMkl09h7O
	 A6NZDdxaDWrxroUk15AqGQmRK1GRDiZXmwINVcjauwxGg6qjr3gRhtUmjaTyD7l4prA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e1JoBrBuHlb7klzFUlFkr11iS6d6DtpUXbrB0svIbak=;
	b=YY6aAuQYyZQgCbOKgDT+g6LydHr3M7Wm0un7wYOQyz6H5CrH2m4wtJvP/rzB0JkoHGV/
	 JUh9453sZU0WyzKuLEn3pvexRMm9tc+NCc5RBY+Y3H/btrdlfw+uTkaWy9fSaolSfzYzJ
	 LfVsJ40w+8/9YC/i9ksaQztD5EpNApaKuRxIrBkrhZLssKVKtxN8bhKj3uDqvUUEGlkHc
	 qIT/i5DTiJf0T90RRqsWMJX4wtaERAGaGkZDyJkHII0GubDShGsUUHRk5Zen8gLqZLkm6
	 pP++aMjCBJBb20n0FC9iN7jA1jjGpOCte3F85OJUi7WlcJRGw3IVXGoXskcvQ62kJ2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1kJkU6zk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931D8606A326;
	Wed,  4 Nov 2026 22:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1kJkU6zk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64B51F000C1;
	Wed,  4 Nov 2026 22:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831929;
	bh=e1JoBrBuHlb7klzFUlFkr11iS6d6DtpUXbrB0svIbak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1kJkU6zkzqBMPJvlyQL2Z2N9ifbzsybuUQDHPskwVb7dC79bNxjPjhvnBcsI4pL2f
	 5TFbxSnlJpoy5qVs8ZXkfk9BDhyntCbiihIpKUEcFdfctSl+rTBUQ3CTfpH+8cLhCV
	 z/MtdTZv0r9yc25z3+9ZaZMvc23idcHW5JTkWykI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0996/1005] media: ipu-bridge: Fix use-after-free in IVSC error path
Date: Wed,  4 Nov 2026 16:12:09 -0500
Message-ID: <20261104211110.931215042@linuxfoundation.org>
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

From: Yibo Tan <lhfff@tju.edu.cn>

[ Upstream commit 3d42d1c82717f0853379b516a7fab54b636e09cc ]

ipu_bridge_get_ivsc_acpi_dev() returns an ACPI device with a reference
held. If no matching CSI device is found, ipu_bridge_check_ivsc_dev()
drops that reference before passing the device to dev_err(). Concurrent
CSI device and ACPI namespace removal can drop the other references,
making this the final put. dev_err() then reads the freed struct
acpi_device and its kobject name.

This was reproduced without kprobes by racing normal CSI platform-device
unregistration and ACPI configfs table removal against the production
ipu_bridge_init() entry. KASAN reported the final free through
device_release(), followed by invalid reads through _dev_err().

Emit the error message while the lookup reference is still held, then
drop the reference as before.

Source reproducers and vulnerable/fixed serial logs, with only the build
hostname redacted, are available at:
https://github.com/kimaiden1984-boop/linux-ipu-bridge-acpi-uaf-reproducer

The fixed target builds with W=1 on x86-64. This was not tested on
physical IPU hardware. The tests establish runtime reachability but do
not measure occurrence frequency on shipping systems or establish
exploitability.

Fixes: c66821f381ae ("media: pci: intel: Add IVSC support for IPU bridge driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[ sashal: Retained the existing "MEI CSI dev" diagnostic because CVS support is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu-bridge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -191,8 +191,8 @@ static int ipu_bridge_check_ivsc_dev(str
 	if (adev) {
 		csi_dev = ipu_bridge_get_ivsc_csi_dev(adev);
 		if (!csi_dev) {
-			acpi_dev_put(adev);
 			dev_err(ADEV_DEV(adev), "Failed to find MEI CSI dev\n");
+			acpi_dev_put(adev);
 			return -ENODEV;
 		}
 


