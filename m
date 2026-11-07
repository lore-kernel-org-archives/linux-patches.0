Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064095;
	b=YMsBg2UM5cGuHG1aepvuwvqnGafNtHHJjRyD9FuQOWuNxS4w0sglby9FgMkTBedw/rlD
	 IaTVff2FsH28JCrzbVrPxrt62HGiTtyhTZoISZM9kny9BjZ3Ow5gOscFD1buMYMiVuGGH
	 on2DAuuKSlSg9uP3n+MTj5Z5P2xWPog2e1m6U7PZdGxnhQ/Qw3g5Us+MCbv8SEQdYALMl
	 GaCumCiqZsunorRH4E+dkvAeRUluoWwgZUAntIxS+phF82mGTxpUAR571g7rUrWyGgkN3
	 dKLbvQeo3XkSjrFkEfGIGKb42Y/b/g6ZwHTQwdMGCNasaLvTTWnBY4CPQER9Vazjxeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q7tMH2tHuPM7WogLQ0Zv8siEZaB+Pr5MV09tnbBflYo=;
	b=l/trkyHIj6LU0JEtt5NU9tzGGDO5WmEybTdU4Um6dbHMc/RUX3yAKBJEOMc8QEEKA28q
	 BzP6YmAkLqwzHcEGwFm98K5j00hM/QCEQa138Ek59pz0GpgmL/PTgXyL1ajc8vhJQSwuc
	 FPRvqkKn6yBVk3WCPCed1tc3ed1dX65F2MUBdxA9KD8YGrTawqVGjhVqZ/NyyNI8OFTOA
	 ZFHRE7LJDkWW5efIVQAYW3gUAIYNNmZNcbQaN5X9N+PO4/Te4/7DIMXhXabzukuLjBKSP
	 3Gc1UKz3MKFx3FWX7wxsTsmzIA8YYLQz6Zxl4/WsQbDcbFab0r1+0lQEINwHchsVWWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9U6YVed;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D29606CE56;
	Sat,  7 Nov 2026 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9U6YVed
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354EE1F0089F;
	Sat,  7 Nov 2026 15:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064095;
	bh=Q7tMH2tHuPM7WogLQ0Zv8siEZaB+Pr5MV09tnbBflYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9U6YVedVlGBNlrv9MsXmsOBOHC8IPJR3K9m+5JPYGcWWAV7jCXHDs8pO2KnUzZzw
	 yDwnGhGplHePMT7DW58qLBIpZ2FTGqDcUv8V+mwBa5MgFx9sAX7UBGs34yzBj9CGem
	 LshpcCmBbH/ZM8uGjnRj+Y8yCHB1hjJM+HyzQTpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qzhuo@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0249/1257] EDAC/i10nm: Fix mdev reference leak in i10nm_get_ddr_munits()
Date: Sat,  7 Nov 2026 08:42:25 -0500
Message-ID: <20261107134946.384853740@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit f0d8c34b3b5e845113581d7d3b24ddaa61bce1f0 ]

In i10nm_get_ddr_munits(), get_ddr_munit() returns a PCI device with
its reference count incremented.  If ioremap() fails to map the MMIO
space of the memory controller, the function returns -ENODEV without
putting the reference held by mdev, leaking it.

Put the device reference before returning on the ioremap failure path.

[Tony: Dropped the Cc: stable tag]

Fixes: c545f5e41225 ("EDAC/i10nm: Skip the absent memory controllers")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qzhuo@nvidia.com>
Link: https://patch.msgid.link/20260916091251.1997522-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index fa1853f252b06..12e1949fcf44f 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -634,6 +634,7 @@ static int i10nm_get_ddr_munits(void)
 
 			mbase = ioremap(base + off, size);
 			if (!mbase) {
+				pci_dev_put(mdev);
 				i10nm_printk(KERN_ERR, "Failed to ioremap 0x%llx\n",
 					     base + off);
 				return -ENODEV;
-- 
2.53.0



