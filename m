Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216317;
	b=n5dGolNjvTXZ+TcPA5x2ncSCKV+BcR658dOvvx7lvQYeetJZt1wKOefeUYQhjifSrnQh
	 vJA7acks5ZLxH21chcChSeqfvTVXnyqHyahu//7uRZERR/9F4uWaVVDm3xZigmVxwErh1
	 q8P8wXg1Reg+aVm8NiGbAWIP6fjP2elE4rTi22fInhD0AY0AwuSdl3MCd01MbD7raQDAU
	 WIW3vgqdFVdjxbzt8n8Txmom7ck8QpnxhC3y5+NeobuBsT/Sq2xw9ZbMcJ+aVMw/CALgD
	 TKyKw2TNH4cwbymupmmFIWyocbSRMT/hzDTrhT6gTRPvtx5zTQqxHAdiifcCac5Oywg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wbcT9kLq/a9YmYKl317IgEmhv6gVEUjHcNzYA15kOSY=;
	b=NdtEGwFqbYbbTxqsyb+VwjNCLhyS+YDAerZWm0+GRJ2gttGWpr9whKdq3dJwuAqUaSOs
	 QvMdmG67zsbJMDRGnIfm32ls93im1yYcHEFaztTnBduHQa9bv7B/3AKOZb6If9jPsYPTR
	 GpzXXC2r5tp8uYMjUPqGu519KWXW3Mj1QCQYb+KH4z56UlhxiFkXkUono+3BiD2hUOqdY
	 l6tza44fefcbyJZ8SulyBQFAaZ9hms2RvxakUNDdbW185oRfxb8OTMa67IRWjoHgYx+J7
	 kZ0aQLS0GtIYhtH5hVuHQIjaUjUds78J0v0QbA6uiGxgDiAWknA6pug24tGooraRACg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sc/KSCv7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CC7606A324;
	Wed, 28 Oct 2026 19:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sc/KSCv7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0341F01825;
	Wed, 28 Oct 2026 19:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216316;
	bh=wbcT9kLq/a9YmYKl317IgEmhv6gVEUjHcNzYA15kOSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sc/KSCv7y7KgFn4uts461Ri9vvAtQ0Qgs+aNLpLcS3/edXhPOPTtgZPAB+BfYSTOR
	 gR9bpfrX93tD7dYCQWKq2yemMIa115BGKL4T+3+a1W/PTWw2lqFV/UdRaXFAfrfhGA
	 eiMNZ8F92BdKqRztqry4AKWfbQaxtU42qsew/QHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Easwar Hariharan <easwar.hariharan@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1517/1887] Drivers: hv: vmbus: Skip VMBus module cleanup for non-nested root partition
Date: Wed, 28 Oct 2026 18:00:13 +0100
Message-ID: <20261028170533.984432550@linuxfoundation.org>
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

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit cee0d90bceae1dee3bcc70f8d6b2ceb5b87deb42 ]

The VMBus module initialization function, hv_acpi_init(), currently
does nothing when running in the root partition and root is not nested
in another VM. But the initialization function reports success, so the
VMBus module is indeed loaded. VMBus functionality is not actually
needed, but the VMBus module must be loaded so that hv_vmbus_exists()
can answer correctly. Furthermore, the mshv_root dependency on the
VMBus module is needed as described in the commit message for
840b740a35bf ("mshv: Add conditional VMBus dependency").

Loading the VMBus module without actually initializing it causes
failures if the module should later be unloaded. The module unload code
tries to clean up things that were never initialized, resulting in
memory faults and a panic.

Fix this by having VMBus module exit function perform the same
check for non-nested root partition, and do nothing in such a
case, just like hv_acpi_init().

In the long run, the code that manages the Hyper-V provided SynIC
should be refactored to better coordinate the requirements of
root partition scenarios and normal VM scenarios, and to hopefully
remove the hv_vmbus_exists() dependnecy between mshv_root and
VMBus modules. Preventing the current unload failure scenario is
an expediency until such a refactoring is done.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hyperv/20260721154943.A09BD1F00A3D@smtp.kernel.org/
Fixes: 7e279d78664aa ("Drivers: hv: vmbus: skip VMBus initialization if Linux is root")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Easwar Hariharan <easwar.hariharan@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 8aa775c9382bf..fe9a1e1ad0c2d 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2594,6 +2594,13 @@ static int __init hv_acpi_init(void)
 		return -ENODEV;
 
 	if (hv_root_partition)
+		/*
+		 * A non-nested root partition does not need VMBus client
+		 * functionality. However, the mshv_root module may have
+		 * a dependency on the VMBus module as described in
+		 * commit 840b740a35bf. Return success so the module
+		 * loads even though no VMBus initialization is done.
+		 */
 		return 0;
 
 	/*
@@ -2643,6 +2650,14 @@ static void __exit vmbus_exit(void)
 {
 	int cpu;
 
+	if (hv_root_partition)
+		/*
+		 * If a non-nested root partition loaded the VMBus module,
+		 * hv_acpi_init() did not do any VMBus initialization.
+		 * There's nothing to clean up, so just return.
+		 */
+		return;
+
 	unregister_syscore_ops(&hv_synic_syscore_ops);
 
 	hv_remove_kexec_handler();
-- 
2.53.0



