Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215445;
	b=mwuxLZt8r9FzMtEBpasR4mehFTCq41dzze/2AEdtB/AXxkvGhH7Ghh3acoD1or5ElV3v
	 nRtvM7BVxL1XRSE057bqttC6MOUT6Npz3q6C6lW3rwampK3ln9Vh88Bx78hCQYm8K4g0y
	 IcWQh2rpBN3j8v2996gOCTmhcTtIMXzU8xXgKWezjqGxPhZp5DlsYezXf3m8fwTCBUcMF
	 LLsL9B3S6cDnagb1GcCpyIdPCldQAG8Imo8YegZvqHGaf5W2HDk8d6c2Uwt+DC6SooghQ
	 n8UywQfHA8BhxAk3qUzmBVM/CvKM3bmxKIt79buIZyALkrV4Y/aaJmfPQQQXF/Apn5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pePZbi/EKytw+C0UGOS82yvUMO0gsoK/M3T48zTBZfs=;
	b=QuYH9ZeOjGjRPWHyM1sz3RR5CtFAJViMd68RgSltDg5Vpxj2o1UzGSWq8Wfh2MZzZP5a
	 TGEytU4E1MNzxsJRiq1+gK+EeCVOHM1/z9Dfmbg2Ujvjbt2A46Jc5XKwVJ993psRs7Rth
	 WiawWmrLUaryvg1VTsCWVxqi7H98clwpTvwnrx3EJJWVfqUkgYTWeoETxLJHqxoiDLmnV
	 rdbxtSrxROFUCycwwMrBUyvCH3G/1qwFN8xWNVFVWleFn6ke3iEoNIhaQCjHESbJcnaIW
	 01WaPjfKVMM/0wqzv13VlBSIsYPf2LlCPBtuasXKyWqmZFZxXXUV91LdwWQ7YREIE9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K68EA+Fb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CAB606A31C;
	Wed, 28 Oct 2026 19:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K68EA+Fb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CB71F01825;
	Wed, 28 Oct 2026 19:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215445;
	bh=pePZbi/EKytw+C0UGOS82yvUMO0gsoK/M3T48zTBZfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K68EA+Fb67rJTk1zpn+XfzHNjxoTocSvcw2gJTKA0oqpE+jcWJNnBCNE2B+5qQMWK
	 J4QRn462LcLSR8XLfQ2b3l1nwvyX/OuViGSVWiEeKIiE61wqwC2kttrr5e84tK2Fvd
	 uG6OBCzJLLLZT4xJ1YK7t9nOxqOy9y4nd7i6RkFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1212/1887] dmaengine: dw-edma-pcie: Reject devices without driver data
Date: Wed, 28 Oct 2026 17:55:08 +0100
Message-ID: <20261028170526.991401221@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 11d7cfe0c119691b2dafbb699bbca90258c678aa ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-pcie.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/dw-edma/dw-edma-pcie.c b/drivers/dma/dw-edma/dw-edma-pcie.c
index d6b5e24638847..e149575a6127b 100644
--- a/drivers/dma/dw-edma/dw-edma-pcie.c
+++ b/drivers/dma/dw-edma/dw-edma-pcie.c
@@ -151,6 +151,9 @@ static int dw_edma_pcie_probe(struct pci_dev *pdev,
 	int err, nr_irqs;
 	int i, mask;
 
+	if (!pdata)
+		return -ENODEV;
+
 	/* Enable PCI device */
 	err = pcim_enable_device(pdev);
 	if (err) {
-- 
2.53.0



