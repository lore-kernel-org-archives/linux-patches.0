Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050918;
	b=VsSMOFxHxGHGI6vmh1IgLvVLfCXuEeOe7/Mig+3i3wbKsVLLeURDk7sn1/nU3XaR9qjw
	 8y02k4um42yI190Ppv6OQrh2Ub2ISN67Jbgn8YJ8C51639rf5xKT6qTuTwR2QEmL2Gllt
	 06a5TkuAvmvqr+UA/gnlZc5IYIfFAc/OjdwAuopOIpFWFtZEzLBvAmulShy/cTWJ72+9f
	 oUgfzwhB0H7YMio8CgtwngwFG612Ra3iwDH1KdcAX91jq5begPoVcqYNYejvo0o7qrkqH
	 OStwQw8VPM4Xl7kkX1MQ2osQaoajpu8RtxPAuTvFcd4KqkqlazUwCHOMQu+bbI2z3pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxR4gUnfR3CKdKATtXMvbdUdCQFqXMl9o5uTKlC5qjA=;
	b=1ITTXwJtA1a9fCK0h28Eg00La32WcQGcezRnbz/vpKpzyYGDD7R85l3a4ZJ/HM8/BsWs
	 +Y/hnjKwSZOrolumcvomukk3h8O/mwwbu8OJlaQBOI5koW/o4YduaNiUMh45Y/srjlUVp
	 VFBD0qiTYsSeSc2cCQyTA7EoyXgduKAbHeOxFOwPaxA7qzZ1qBRyiuX4yRPiGWxT8hTqM
	 AyclKsJY0du9PqOV6ni1R82JrChM2uZOM3hdkvXePVmhPMU0EjY62FxqLC3RCab5TDGlW
	 Eyc6/dudHoYffjb7ZjRe+FNBMwauXEJO0FRwzlge8fCtgJOfk9+e+8Y9cWLbhCbyqvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Saa5MOcQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9155B606A31C;
	Thu, 19 Nov 2026 01:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Saa5MOcQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8961F000C4;
	Thu, 19 Nov 2026 01:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050918;
	bh=nxR4gUnfR3CKdKATtXMvbdUdCQFqXMl9o5uTKlC5qjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Saa5MOcQQzfChOESiNmBQmWzP0QI5CuYI8LFAf68urLWWBMe9yerjH17jFChccHix
	 N7ul7m3THxzacSlpespGSSwhd527d+JoYdURP2JUisQMFsmH9Lg9cMSeEm6EsUyU0N
	 SEqgm9D0W7Fn1BDuChXKvU3OXgXEYU1fFVi+vtms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 0024/2214] dmaengine: dw-edma-pcie: Reject devices without driver data
Date: Wed, 18 Nov 2026 15:28:20 +0100
Message-ID: <20261118150011.085905006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

commit 11d7cfe0c119691b2dafbb699bbca90258c678aa upstream.

dw_edma_pcie_probe() treats the PCI device ID driver_data as the
template for the controller layout and copies it unconditionally. A
device bound dynamically via sysfs can match the driver without that
data, which leads to a NULL pointer dereference.

Reject such matches before enabling the device.

Fixes: 41aaff2a2ac0 ("dmaengine: Add Synopsys eDMA IP PCIe glue-logic")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260521142153.2957432-3-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-pcie.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/dma/dw-edma/dw-edma-pcie.c
+++ b/drivers/dma/dw-edma/dw-edma-pcie.c
@@ -151,6 +151,9 @@ static int dw_edma_pcie_probe(struct pci
 	int err, nr_irqs;
 	int i, mask;
 
+	if (!pdata)
+		return -ENODEV;
+
 	/* Enable PCI device */
 	err = pcim_enable_device(pdev);
 	if (err) {


