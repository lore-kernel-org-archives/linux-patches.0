Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035671;
	b=dn+wfbaW7xz5LH6ASHRV5PcoAy4VLYlugexoLu1jzhvo5wInMKuq7j5n39jrnb3/+KUR
	 0MMCMTgsrO+JhhXbKnqVi7maEztbeVO98zYoHdYj9d6HK4RfyC71z6a6MD7QmerXC0QzI
	 a0Yms0BdXtbqLbnM3DS01SPfqHU3j5Yz8XCDSsNCTaUV55VggJz4zRY/2De+JvgP5SIHj
	 Qpv8HeyhmmyiJ/6q2F2bzVQZAL7wHhfK0tCKw34Ls+DVpjO3hj1NssFJeTxzAOr3ciVa9
	 MmtcDhNNqkN3QjljEYDaT2bHbgPfqA4VURvtJgFoihHVIGe43fx0sjH1cYgVopqJWZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hM5mKmK3Bdqw7wTt3qKv5MaMSEcaUJSXq/bfSyJuVHQ=;
	b=eTvXO40zywFfuxF49G+6eCZUJB2PxIC/LrXWNXZZ2gtve3ddSWysgzU5wCMTI6P17Tnc
	 BxIG4Lr+tKcSn1gyuTx4EWVyMO/yFHFA3EdPyMwLAbVX3AJUkSjgcEz7OUvYzpvyb0L5u
	 oBtG5hOeUt9cCgpBMPEOTNPmT3WTkohsJHvIw1f++Uhe/07cWmbVPy2UqqKXH7yhtU0DK
	 yQBQ5v/atXMFbxZ0xTPniNWaszEYWvKXOjJTd3d1Em5dLw22jRrGRZgskkDkXhxDxQkV4
	 U98k8lZYFbq7PW2b/G7yH9LO/G7RUbRgq6fmD1qyEEEoW7ZRXHaQEzy/UZECsGHiClA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1UdhLpD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB37606A334;
	Wed, 18 Nov 2026 21:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1UdhLpD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F531F000C4;
	Wed, 18 Nov 2026 21:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035671;
	bh=hM5mKmK3Bdqw7wTt3qKv5MaMSEcaUJSXq/bfSyJuVHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1UdhLpDCOY1HUD1FCt0jcXnEd0I5ws9rFSpyMlv69BdOoFiz++Hm5FwnhbVLOdq+
	 MNscKCPJkiKoQ2cWiM9vFOypr0oc4xZKRtFSRDVPeDttTf0YY+C/sHL7xd0t0VWneg
	 wSAsfzxEL/4mjRFPbLA+faa4fOs/OhSKKAx+Douo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0784/3318] media: ipu-bridge: Fix use-after-free in IVSC error path
Date: Wed, 18 Nov 2026 15:23:26 +0100
Message-ID: <20261118150342.360761119@linuxfoundation.org>
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
[ sashal: adjusted context to match the existing MEI-only error message ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu-bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu-bridge.c b/drivers/media/pci/intel/ipu-bridge.c
index bd58adb4c2b45..1835f861eb5f3 100644
--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -168,8 +168,8 @@ static int ipu_bridge_check_ivsc_dev(struct ipu_sensor *sensor,
 	if (adev) {
 		csi_dev = ipu_bridge_get_ivsc_csi_dev(adev);
 		if (!csi_dev) {
-			acpi_dev_put(adev);
 			dev_err(ADEV_DEV(adev), "Failed to find MEI CSI dev\n");
+			acpi_dev_put(adev);
 			return -ENODEV;
 		}
 
-- 
2.53.0



