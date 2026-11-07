Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063949;
	b=IfpGsm05fTxUStaITweiQ5UmzheJ3Qb702u6IKiu87R86rnDipdVAUb2DuS2QL7BFQdn
	 BhiCcgngg6r5tCljb0APP/HtpR7Brp1yNiW4ddVqQrIOonLDP61DixwGzIBzGVixYXKox
	 xTWpBYbz3Uox6SBHPrpfTB4tFzj0OOIfyQ73rsPsoDdNbfNViuJ0rYJ5vwstw+I4B2Kn6
	 6m+T9iR4xI89GPTCjNWrVVkLQUdVJ3kQ8U+trPqmAzypybxxGvoaLvluMAC9IhMcwUrkK
	 pXRnZfO7Mwvz2h3Fot36t1mDpGWYx19JTcqM+30WbCK/AhIkUgjk8yufsm9EBZVbd8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AlHe0iFQB/kdqeA2KMd+FC+z5lAoZW1rNwrjP3YVnEU=;
	b=aDRQ1taECjIvw94V/XgsFML2B0hZZOMG/pahcAHqKXNmyC/OGCzh2QJuT9Bm5Gem2CuH
	 RLeJtc/p3fx2Qce8JNSAopXm9DSbv+XbsvuUDpruI+A/4Dk1ZQ2zArWZf+Crak6ZdQ3Wf
	 PcudT3M9elTm0JXBs8urLqT5ZmTQMUjBHxXPhWuMD4ArUY5i804CKg4NVERuZL1k0+b9Z
	 C41S0uAyjlAHGw+oiMG59xkMqX/GM7BJhOZR/HQw9xj6wlwtXHpIVbx5jNT/ymyUajs+I
	 U/9LcumIfWPccnmOugEQ6ctBNAn1E/mijCUMRKwCCoFLRibNi7v4ZY48YwWWmxbHEGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8v6xNXf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C557B606D829;
	Sat,  7 Nov 2026 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8v6xNXf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ACC1F0089F;
	Sat,  7 Nov 2026 15:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063948;
	bh=AlHe0iFQB/kdqeA2KMd+FC+z5lAoZW1rNwrjP3YVnEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8v6xNXfLjSjNvyBWtpPW/0yOn9gaMuKCcLDeWoJGonpO6OVWXDC/9v4VNmuWCoV6
	 mrkBFZp/FVdZA8pihxHnTJycBUzO25w5V94z2mb8iXY8Pra/UDZ+nCeHoNYsEh91SI
	 f1wYiIU0/Kw/wj7aoIX/1/3Ghn6+jwPbGBoCf1o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0140/1257] PCI: rzg3s: Propagate platform_get_irq_byname() errors
Date: Sat,  7 Nov 2026 08:40:36 -0500
Message-ID: <20261107134943.176505134@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 49daf16c881bc91a55355a3e7f03471c2b213255 ]

platform_get_irq_byname() may return specific error codes such as
-EPROBE_DEFER, but rzg3s_pcie_init_irqdomain() replaces all failures
with -EINVAL.

This breaks probe deferral by preventing the driver core from retrying
probe once the interrupt provider becomes available.

Propagate the original error code instead.

Fixes: 7ef502fb35b28 ("PCI: Add Renesas RZ/G3S host controller driver")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260811200013.185956-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rzg3s-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rzg3s-host.c b/drivers/pci/controller/pcie-rzg3s-host.c
index 01488660ab081..f51b5d7c19983 100644
--- a/drivers/pci/controller/pcie-rzg3s-host.c
+++ b/drivers/pci/controller/pcie-rzg3s-host.c
@@ -1019,7 +1019,7 @@ static int rzg3s_pcie_init_irqdomain(struct rzg3s_pcie_host *host)
 
 		irq = platform_get_irq_byname(pdev, irq_name);
 		if (irq < 0)
-			return dev_err_probe(dev, -EINVAL,
+			return dev_err_probe(dev, irq,
 					     "Failed to parse and map INT%c IRQ\n",
 					     'A' + i);
 
-- 
2.53.0



