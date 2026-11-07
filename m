Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064443;
	b=gzNZ/BE4Pew10NZ6997NqxoJbLS5u2JM7/Z1Dt20QkW7SwB2zdPf5YGNLkA93wbqAWKK
	 uyqVa0rXGOfdQFaCN5vzLP+Si04z4I27mHsVjjGy20YY5zqMBa0awB2lyiw0n1EVl95MK
	 rQ2uTNHMYiq2g5mNKN0DfHZ6WA9+Y4LPCdINHQWQQwqoeEtFqe8gctb07dBvZ/J+Dlj9F
	 IIXrrBTp3GMq+iYZudICQdxxzyJZ+rFSwniaXa6GcHCBUTX8Zazb3jAlBHLX7Tn7m8qus
	 Br3f6V7r4eIDQiCD9QddNgBelqPEiu+0ywwbqz8FRHrfjB6oUxjLG9aoSsnnA6dWbcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YTYe8BuUU1193zvtbbvMNM5cBpM3/GyhNIMGNZCw+ks=;
	b=FiJ1TjXleVFbZLUr9587K+sI9ATiPpV55TIGd419a4Tst9yyra/yI0MyZ8lOtZMxy2Hc
	 HsgmBgxVw7y1Nm+ppeVc4j6yzFOD2SaIEyVHKg7Xi2jZHffTebE7ya8IkXdvD40jDN/Dq
	 lzoNl20Ac7sXhzq4ar2GPplylxjt/+dCfE4GPay26EbTzr9kNovtdgroonVO/wMh3cb+N
	 DYvamUzStfcw9OX9/81lp2sThs9qXWK3yT+4Mz5I2mZZOqlsX4DZhxrgYUryiEyRIfgdF
	 xyUh2Bmk5DYoZTR+7CSy+zoTg3AUnk+tw9TcvpRsxoHvPbn6ZDJTswJjKBWdhDXQU6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wv2QNabV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5616606EEA8;
	Sat,  7 Nov 2026 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wv2QNabV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A0E1F0089F;
	Sat,  7 Nov 2026 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064442;
	bh=YTYe8BuUU1193zvtbbvMNM5cBpM3/GyhNIMGNZCw+ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wv2QNabVFLaLJ4RufTcQpXYcVg6bkcPBMdNkuvaBrk8n+MH7Ary3DqTRAJsZRMwX5
	 YjSbW6VZaLXk3wUrvHUOsOY7uLtubeUjEpzhS090/n9yAezUxjdLwfAhTARZAA39Sy
	 vxc5/MX1toG1pi5BW4bHxzijyNK6UIlJ+glDl3P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0488/1257] PCI/AER: Fix memory leak in aer_recover_queue() on kfifo buffer overflow
Date: Sat,  7 Nov 2026 08:46:24 -0500
Message-ID: <20261107134952.921736917@linuxfoundation.org>
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

From: Priyank Rathod <rathodpriyank@google.com>

[ Upstream commit 07938f8a3cbf3e9cc27553b8982e2d56c15b354a ]

When ACPI APEI/GHES processes PCIe AER error records, it allocates memory
for aer_capability_regs (aer_regs) from ghes_estatus_pool and passes it to
aer_recover_queue() to be enqueued into aer_recover_ring.

If kfifo_in_spinlocked() fails due to a buffer overflow,
aer_recover_queue() logged an error message but returned without freeing
aer_regs. Because the entry was rejected and never inserted into the queue,
aer_recover_work_func() could never dequeue or free it, leaking the
allocated ghes_estatus_pool memory.

aer_recover_queue() returns void, so the caller ghes_handle_aer() cannot
free the buffer itself: ownership is transferred to the AER code, which
until now only released it on the success path.

Free aer_regs via ghes_estatus_pool_region_free() when
kfifo_in_spinlocked() fails on buffer overflow.

Fixes: e2abc47a5a1a ("ACPI: APEI: Fix AER info corruption when error status data has multiple sections")
Signed-off-by: Priyank Rathod <rathodpriyank@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928-b4-fix-aer-memleaks-v5-1-ba6b94c9c9a6@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 732f75a31760f..be332d3f106cb 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1426,11 +1426,14 @@ void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
 	};
 
 	if (kfifo_in_spinlocked(&aer_recover_ring, &entry, 1,
-				 &aer_recover_ring_lock))
+				 &aer_recover_ring_lock)) {
 		schedule_work(&aer_recover_work);
-	else
+	} else {
 		pr_err("buffer overflow in recovery for %04x:%02x:%02x.%x\n",
 		       domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
+		ghes_estatus_pool_region_free((unsigned long)aer_regs,
+					      sizeof(struct aer_capability_regs));
+	}
 }
 EXPORT_SYMBOL_GPL(aer_recover_queue);
 #endif
-- 
2.53.0



