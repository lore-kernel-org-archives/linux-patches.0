Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061863;
	b=sKgHk0hvAkCEIc43KwvDSX1uABJaJWbjrXWwaD8Gw7Ac3eHQPoU5vRBe79pIe13EsEzM
	 urFnRvRz2KYFsXaNBVMMcCXiaYWrllgnG5sAAc8cJ1vSIn88kEQ7sqXPNjvoc+hE1RLoB
	 OdQPIUfpeeRJDpwC30cmHlkB/r2LnP9NiDeKP8FQlYk+IUhMncXFJBEBrlBfQyJfCC+PV
	 uQLNmp4OaDHshY1uXXYbzfA4CfgaZ/elGgQKKx6SgLmx7SEz1E1c6QfnxPelD00RIOc5J
	 hm4YhTdWTmPSDHIZHDtIqztN0VhjO650q2vi3Q/25X1BDDy1WXbXiHrOcmY52AITGWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sdeKcw2Lu9CUU91xAkZ/zAm37NPlrfap0brGq3HHYBI=;
	b=UMbB0Ee7nSFP6/REmHoBAta5kOu3IEPH0+HIT7jAf8g7kxSFpej1I+O3g1ROyiExlQJ0
	 hRJAp5b4+IUrKdbim8muK6zrcKSCFzuK0P2bsAxufl0pEFnc+vMa/mmZyFvIZiyt47Jvz
	 kp7hhVxPA20jOaOH3Qrb/KenpGzLVHEtrzZaXPlw1CkrsOB9LgDqwyG5+skYooob06tqP
	 tvflg9aqM2TIElKdxp+eSvy+uHKy3cE27qkt2pBgjl4TYmAHDfmqxYJmcNMNXXG0PlHtY
	 hXL4Fzg8YaUfQ+cZ2/w4cirSCvPclwSZnBuxHoFUSwjseGTGBPkmSznOy/GAnvJvJwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2YsmrNi/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F778606A326;
	Sat,  7 Nov 2026 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2YsmrNi/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD661F0089F;
	Sat,  7 Nov 2026 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061863;
	bh=sdeKcw2Lu9CUU91xAkZ/zAm37NPlrfap0brGq3HHYBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YsmrNi/fzWJ8e+PPJhJBFEuX+oc7+Ci9v4XrcHFZ0uDSZ0VR4TwKxyAohysB7TmI
	 42zarmSX6HNV8RpYFgPKA7SGh+C3cYQM8vmIV2ybtKoc7kEw6BoCPuPrlZtVTwGCmc
	 TMOCrvd/XJMhUciC89HAYjHLas1Zkp2faYaqrYL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0880/1536] media: ipu-bridge: Fix use-after-free in IVSC error path
Date: Sat,  7 Nov 2026 08:48:16 -0500
Message-ID: <20261107135022.342860979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
[ sashal: adjusted context for the error message that mentions only MEI instead of MEI or CVS ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu-bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu-bridge.c b/drivers/media/pci/intel/ipu-bridge.c
index 4e921c7516293..faa7e538bc2f2 100644
--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -191,8 +191,8 @@ static int ipu_bridge_check_ivsc_dev(struct ipu_sensor *sensor,
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



