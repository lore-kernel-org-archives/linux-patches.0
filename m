Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7223451CC;
	Wed, 20 May 2026 16:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295104; cv=none; b=LgDohFzulW4AMV4FxmC5Uj5qFqbc7Gdf5HSzVw+ISHphT0pKJy1xj+5XR0gN7uEqxJ0PnU760drOiItPczltiwOxl92U+N16AsA91NKQgZyIentBBFIYwjaA2mOY6pdGgr+6w1vMiK6nBUUp/dZVRo2WViuvKYIjLfziBvzkzR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295104; c=relaxed/simple;
	bh=nemYUtHdLehWnwQF6n7K65O2zGO9fAFSyn1Cutm9hBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORDS1jMj2yC4B0eG2mpaCYniYtqIQSpsoHXXC0XWaIpYmEZ0NbtBonnwsOeIPvYIxLKlEwL/PxerqY4HmbxYZstlNWDABNILsKWttje6oUvi6fmvm+iDe2u0snaSJq6nRJJ06mmticPKibV/ZNkOPxt2fmPmhuDPZa2IbKavw7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pi/w4OVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pi/w4OVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D420C1F000E9;
	Wed, 20 May 2026 16:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295103;
	bh=jdI7jbEz32GmJvdqmx2zPHZHo1Xq9kQ5Zjhp7J4mMRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pi/w4OVCPvAtlaFu+zxRJJX8aQWW8F/D4vdtRgrSBwxSC7ZKlnC69urWauZ+8ZiuW
	 CZ0JWeUVgpUv/fEZaAsDtKeu09pqb38lMcHehC5n2K8Kyf2RTpJiJ1/OdDoQ/QZ3+1
	 8yyw1OkicSe57Q7GxpdygFNeJ2E5zGsxWmhBspDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Chen <vincent.chen@sifive.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0291/1146] iommu/riscv: Add missing GENERIC_MSI_IRQ
Date: Wed, 20 May 2026 18:09:01 +0200
Message-ID: <20260520162154.801580157@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit c70d20b25ca30d68b377b9363a2adca6eb2538e3 ]

The commit below added MSI related calls to the driver that depends on
GENERIC_MSI_IRQ. It is possible to build RISC-V without this selected.

This is also necessary to make the driver COMPILE_TEST.

Fixes: d5f88acdd6ff ("iommu/riscv: Add support for platform msi")
Tested-by: Vincent Chen <vincent.chen@sifive.com>
Tested-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/riscv/Kconfig b/drivers/iommu/riscv/Kconfig
index c071816f59a67..fb8e217edc3d3 100644
--- a/drivers/iommu/riscv/Kconfig
+++ b/drivers/iommu/riscv/Kconfig
@@ -4,6 +4,7 @@
 config RISCV_IOMMU
 	bool "RISC-V IOMMU Support"
 	depends on RISCV && 64BIT
+	depends on GENERIC_MSI_IRQ
 	default y
 	select IOMMU_API
 	help
-- 
2.53.0



