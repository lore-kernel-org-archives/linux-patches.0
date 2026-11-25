Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624659;
	b=qkkKFSlyn/zY9BrTMxo+efZe/4YPQsjrxpWOf5qy91+M0WkePiU73y0b4BOt1PYaa5iR
	 ed4xQAADyK6MuMCDqDscbStsHtyjWnJJd/39+pM7aD4jKV7hLtgobzthXoqYhRARbP3JN
	 b2R+0dhUTu2V873XjevYC7mKumYYGayhu+NBPAbl/YgONeUljvIt+mM0+dX+ib/G408gk
	 IMY2NSHKRJ021wPnaEJOIKZD2xKt3ev5oHNjcQHechWC7NFLtPTeOLPoITkTTq+Jt3ELQ
	 lT58Vao0BRaIwwO+qmDf4FPzhGexHEB/t5T6/jItw8i5dWcL7xePNW4Hff510BtXbMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mDbYrmxEQ4T8inMgA2Iva6LBSyjBj38HbGKn6x6+gZA=;
	b=kVOSt6oqZ2Dt4D3ki674p/+5Dh5Yjx89t8aLmVwawN931pdG5Ronal578IbEGkpTfH3n
	 PhG0j5ZEmdCcSmro38FeIkKjDicLdfpev/U2tVia5K5b6zVvOcnq/47jnYl2nWcd3gKqa
	 sVM6LWsoCr5Hw7KPB+mkKk0wae/ZPQBTk8IBbqwvtwsamRBzhbaKMn/FKkNtI0r5b722a
	 qt/Lv8MCFXIHsdLaLSRUPB6NKtIGBOh4GqkrO5fLqleDikqL/wJGvdHhYR7qwhvB8fmAj
	 n3/uVXLW7JFgo0P/6T7x2WMriTZ2P1SJJEGH5F+ZFoK4ZUzX2q4IQrH4fsld7j3a4Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gU2+KlS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B700D606A33B;
	Wed, 25 Nov 2026 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gU2+KlS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121001F000C4;
	Wed, 25 Nov 2026 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624659;
	bh=mDbYrmxEQ4T8inMgA2Iva6LBSyjBj38HbGKn6x6+gZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gU2+KlS4eGfkMPtvxQ07nIStxwE1CPmvq+p77D4aE8JcgkIDWrYivptx9pKtCZ0hm
	 IbEEz4enDWeF1IP4DGy7YOkKBNtXVTd9OPnF3IyYd4e1Df/XmjyrV0K/jI0on2ZYX5
	 sSzI6Alp1oML5UZ0vAw4bZAFeU6PwaBPdFT95KRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/816] iommu/amd: Clear amd_iommu_snp_en if snp_rmptable_init() fails
Date: Wed, 25 Nov 2026 15:30:11 +0100
Message-ID: <20261125143855.296741513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>

[ Upstream commit ec91bb159dc24eefe144ef8867937f4a055dd0e2 ]

iommu_snp_enable() checks that the IOMMU can support SNP and sets
amd_iommu_snp_en, then calls snp_rmptable_init() to map the RMP table.
If that call fails, CC_ATTR_HOST_SEV_SNP is cleared but amd_iommu_snp_en
is left set. Later IOMMU initialization uses amd_iommu_snp_en to
configure the IOMMU for SNP, on the assumption that RMP setup succeeded.

Clear amd_iommu_snp_en along with CC_ATTR_HOST_SEV_SNP.

Fixes: 409f45387c93 ("x86/sev: Fix broken SNP support with KVM module built-in")
Signed-off-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 835b24524aa8d..b415a6fecd32e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3324,6 +3324,7 @@ static __init void iommu_snp_enable(void)
 	return;
 
 disable_snp:
+	amd_iommu_snp_en = false;
 	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 #endif
 }
-- 
2.53.0



