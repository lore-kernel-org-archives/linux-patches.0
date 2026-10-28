Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216580;
	b=IdsLTJshvT5E9YAL2VwwS9SWDvVKwBwDVQXjJ5HIMen26oKnztSPZI0Y4ObtCI2MA8LC
	 VmwyGCBnqMYpalCBDVd0RD/1mSFzJuwZWwUHZOHBi+VqduSTmHexQgJYO2U2517bjfD2Z
	 fNWSeKj6heCg5AOcWTD0s3WGtnhfcOnSKZqycb/TjqmF1HSwJdb/1nO1K6c38wbG8mUaL
	 HNcYiAPCIb25OIugeZSqbV44iTNANVvkKShsuXJAKpFj3THqgryUHWP8O9zVudUEHEbn/
	 h48e7g17uF/0ADyspQIwHsyooF2TmMD9eVPT8NopD9zxLFKKaybsY9Xz7EXzPkXud0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oD3c7yjLHstiARpaqG1PVbIOtK32JBpFHqXz0CGhz3E=;
	b=lg90s/umBUFzfGpRfKgImKSGho/7IU9WEIdbFs3woAKP+iPG5vjw4hiWd1RqdnublVGz
	 HZJ5lfkbO27so+Hf6yZjSyVYTRlah3e656t5JDEkCeQgU1i3JmKA1DRR1cCL42e5Dy5ju
	 0P3F0yUpzueLyAGQNP+/yxlcv6MUsvC6byfRIJIDLtmWk7QPeD69vzQr1/iVTFKDi54DP
	 6cedlktZkafWH46e6NfMvq06uYss66KPaBkU+42yX3owsdSydtEP/G7uAc1r7a9k3drG5
	 XUWqsDCOJV0INbZYCpJwGo3X+By8CQLY9OQtn3fDzBsWrZawy/kOF5uNlBcod+2wxiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eACCQEup;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C183606A31F;
	Wed, 28 Oct 2026 19:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eACCQEup
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE64D1F01825;
	Wed, 28 Oct 2026 19:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216580;
	bh=oD3c7yjLHstiARpaqG1PVbIOtK32JBpFHqXz0CGhz3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eACCQEup6a/7JkiIHAmJJc9nXUllxX/nKKLdFaFfGf6RXNhMYL2mhXQDxtDHhB0cn
	 sc9X9nor6syseVrPu6Wq8L6bnHts43CEMs4rELx+aDAd+63JKe5vg+xdmXdB8SicUY
	 MNh4xILBq2+mEcC9j0MdQxCWj/g6Ip0KwUtKRd0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1607/1887] PCI: Initialize temporary device in new_id_store()
Date: Wed, 28 Oct 2026 18:01:43 +0100
Message-ID: <20261028170536.037178175@linuxfoundation.org>
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

From: Samiullah Khawaja <skhawaja@google.com>

[ Upstream commit f45a49a2380a47332817b7248c61a0ebbc6f0d00 ]

When setting new_id of a PCI device driver using sysfs a lockdep splat
occurs. This is because new_id_store() builds a temporary pci_dev for
pci_match_device(), which calls device_match_driver_override().  That
depends on the driver_override.lock added by cb3d1049f4ea ("driver core:
generalize driver_override in struct device").

The new driver_override.lock was not initialized in the temporary pci_dev,
resulting in this lockdep splat.

Initialize the temporary pci_dev to fix this.

Repro:

  Build with CONFIG_LOCKDEP=y, boot with QEMU, and add a new ID:

  # echo "8086 10f5" > /sys/bus/pci/drivers/e1000e/new_id

  INFO: trying to register non-static key.
  The code is fine but needs lockdep annotation, or maybe
  you didn't initialize this object before use?
  turning off the locking correctness validator.
  CPU: 2 UID: 0 PID: 177 Comm: liveupdate-iomm Not tainted 7.0.0+ #9 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   register_lock_class+0x77e/0x790
   lock_acquire+0xbf/0x2e0
   pci_match_device+0x24/0x180
   new_id_store+0x189/0x1d0
   kernfs_fop_write_iter+0x14f/0x210
   vfs_write+0x263/0x5e0
   ksys_write+0x79/0xf0
   do_syscall_64+0x117/0xf80

Fixes: 10a4206a2401 ("PCI: use generic driver_override infrastructure")
Fixes: 8895d3bcb8ba ("PCI: Fail new_id for vendor/device values already built into driver")
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
[bhelgaas: add commit log details and repro, trim backtrace]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20260505234327.716630-1-skhawaja@google.com
Stable-dep-of: 3ffc4c9690c3 ("PCI: Fix UAF when probe runs concurrent to dyn ID removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index fa3165e5b921b..9cbef46dc1af5 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -177,6 +177,11 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	return NULL;
 }
 
+static void _pci_free_device(struct device *dev)
+{
+	kfree(to_pci_dev(dev));
+}
+
 /**
  * new_id_store - sysfs frontend to pci_add_dynid()
  * @driver: target device driver
@@ -212,11 +217,13 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
 		pdev->subsystem_vendor = subvendor;
 		pdev->subsystem_device = subdevice;
 		pdev->class = class;
+		pdev->dev.release = _pci_free_device;
 
+		device_initialize(&pdev->dev);
 		if (pci_match_device(pdrv, pdev))
 			retval = -EEXIST;
 
-		kfree(pdev);
+		put_device(&pdev->dev);
 
 		if (retval)
 			return retval;
-- 
2.53.0



