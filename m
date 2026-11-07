Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064137;
	b=dJbPfwVOYs+Sp3+q93Jxj0bhYZB4CrJJ5LllZzz5OaNJ0BBuc+4CBxkYVE1q6k+jePWa
	 aC7g2Pf3hhpeVzf9kaWJboQ/kUL8laVhJBLqVyGdoIrk8MO3NhPDUOHnWNIzUgK+arhQe
	 LdnqR3kWZ3wSQVDGe+1NjaxPtcmhrg7c6eI9orR9E9bSLApF5q3GO/u1IxNZbKQSdVnGd
	 8nSdcr3WF+Hj9hpeHH5uEog77SBtQsJgBqnwfIlbJ9OKAGNI1RGY8iIZru59XARoOXYYW
	 T6VsJMtHnn6QBEmxDs+QvLlxVamBYoSJ4tKj9M1EAc8LBoAHu42zzceFusgGnGqQUcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yFF/MGn1xU9Ic3eg9zqYjp3feFi3x8JCHJulH5cBLt4=;
	b=b5tHbd/4svZJRiZez5dTOsUsxynL2+zxg71uVP1HKhANyVrL/U/1y0CtvlDogv4ok6Ly
	 E35JLIlUcvItvQ8UAb2sXA7IxPbj6zPcbDuwKw48LphbhNb79DR+j7Q7IOaFGtrglWH5K
	 To46BZzvMGKCPeATgOWQaIAxw8MNXSU3KzT7jgsuAdy6iM8BP3GmS8sulWxnYsDLXcYMa
	 iEL2DRm57VmCjWOxE4LyguK5NAAUIyvNYqAlBr1cXJDciH766ji1EKg5x2DT/jqHjexQr
	 1iARgZ01Ow9hi2kHV3NGK/YoWCUXZSDcRrUM59wV88ji8VHLGyX4fItiZeSDIXnXORQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIPoEaBd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5652606A33F;
	Sat,  7 Nov 2026 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIPoEaBd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A3E1F0089F;
	Sat,  7 Nov 2026 15:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064136;
	bh=yFF/MGn1xU9Ic3eg9zqYjp3feFi3x8JCHJulH5cBLt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIPoEaBdeRhlD5gMgvh+sm7bhP6eLu5Vhqe2KqB6/Wn0mZy1UoGSORqmp3tJNQpUj
	 yvkfKJSBJNPqQOxirom/iQSP/lWx0U8mQpAD8lyUk+yX8xKfn8HfSjG4jf67g/JRY7
	 8iXyempwcEotmY7b+oodS3Xc/lTWAsxmKWxN5IbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Wang <wanglin@open-hieco.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0287/1257] hwmon: (k10temp) Stop matching Hygon devices
Date: Sat,  7 Nov 2026 08:43:03 -0500
Message-ID: <20261107134947.398074508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Lin Wang <wanglin@open-hieco.net>

[ Upstream commit 08e6615c909b2504a5862764f3a7fca00c7ab066 ]

k10temp matches the Hygon F3 device, but derives the node passed to
amd_smn_read() from the F3 PCI slot using the AMD fixed-slot mapping
(slot - 0x18). Hygon PCI slots do not encode DF node identity, and
their SMN roots are grouped by socket.

The derived node number therefore cannot identify a valid Hygon SMN
target or provide usable temperature monitoring. Removing the match
does not disable a working monitoring path.

Remove the Hygon PCI match and Family 0x18 branch. Hygon temperature
monitoring will use the Hygon node and SMN interfaces in a separate
series.

Fixes: d93217d84c6c ("hwmon: (k10temp) Add Hygon Dhyana support")
Cc: stable@vger.kernel.org
Signed-off-by: Lin Wang <wanglin@open-hieco.net>
Link: https://patch.msgid.link/20260921055603.25112-6-wanglin@open-hieco.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/k10temp.rst | 8 +++-----
 drivers/hwmon/k10temp.c         | 5 ++---
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/Documentation/hwmon/k10temp.rst b/Documentation/hwmon/k10temp.rst
index 91b99adc6c487..9680c4f3383c3 100644
--- a/Documentation/hwmon/k10temp.rst
+++ b/Documentation/hwmon/k10temp.rst
@@ -28,8 +28,6 @@ Supported chips:
 
 * AMD Family 17h processors: "Zen", "Zen 2"
 
-* AMD Family 18h processors: "Hygon Dhyana"
-
 * AMD Family 19h processors: "Zen 3"
 
   Prefix: 'k10temp'
@@ -128,7 +126,7 @@ it.
 Models from 17h family report relative temperature, the driver aims to
 compensate and report the real temperature.
 
-On Family 17h and Family 18h CPUs, additional temperature sensors may report
-Core Complex Die (CCD) temperatures. Up to 8 such temperatures are reported
-as temp{3..10}_input, labeled Tccd{1..8}. Actual support depends on the CPU
+On Family 17h CPUs, additional temperature sensors may report Core Complex
+Die (CCD) temperatures. Up to 8 such temperatures are reported as
+temp{3..10}_input, labeled Tccd{1..8}. Actual support depends on the CPU
 variant.
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index 3e7e63edc6a30..e0a7211a513ca 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -64,7 +64,7 @@ MODULE_PARM_DESC(force, "force loading on processors with erratum 319");
 #define F15H_M60H_HARDWARE_TEMP_CTRL_OFFSET	0xd8200c64
 #define F15H_M60H_REPORTED_TEMP_CTRL_OFFSET	0xd8200ca4
 
-/* Common for Zen CPU families (Family 17h and 18h and 19h and 1Ah) */
+/* Common for Zen CPU families (Family 17h, 19h and 1Ah) */
 #define ZEN_REPORTED_TEMP_CTRL_BASE		0x00059800
 
 #define ZEN_CCD_TEMP(offset, x)			(ZEN_REPORTED_TEMP_CTRL_BASE + \
@@ -475,7 +475,7 @@ static int k10temp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		data->read_tempreg = read_tempreg_pci;
 	}
 
-	if (boot_cpu_data.x86 == 0x17 || boot_cpu_data.x86 == 0x18) {
+	if (boot_cpu_data.x86 == 0x17) {
 		switch (boot_cpu_data.x86_model) {
 		case 0x1:	/* Zen */
 		case 0x8:	/* Zen+ */
@@ -583,7 +583,6 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M70H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M90H_DF_F3) },
-	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, k10temp_id_table);
-- 
2.53.0



