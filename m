Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621738;
	b=gLWOB0NprRmtnpfDtEO1Q2PYrvFEo7qTboysPe7HUKpCF2pRCiL7167qjk+tZiTkr1yh
	 y6pHvTLZvRvmt3wO4tDdxvl2kOZKjcEBu2O6eoExI2hYIa+4v0swplFVUMlnQRzdGJCY+
	 SQyw0GyNFzF+b3yjyYPqxLMq3WGLnfdyYrLa9GfzxcyoKUI92bIZAZCl/ULQR4+GuxQvL
	 dr4jMs3fsIgU1dvJmZ9JUvltM0Pcd9/pXMwtUfuakZjBytX1l9uTCGMlvNhwz/q7ta/7R
	 ErqsxE0cXnVKkP8E6DWQBCY6NglWyBO/IXb7ofIAyLViz281ECfzrXFD2xBU+k0/dvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQLW5BEQAhtskbmgPsGCuTWfVlMMGjsdf0RnfUmU2Rk=;
	b=1FNU034CYdANeifcs8oWnl8WaOVfyAupwZoiVbPkbTg1dtr3gBLTCnpdRM3MRKJFFhhx
	 xmJLREJTNzKjQkHKH6Ji8LlfVPUlo1p9BEFF731jpme0I4g4uEGq4+Y+fnkM6O3GwR0Wi
	 17CCMDkpHoyNtinryqGe7F/F5xewx2RmhVyLoPu8Ymy74p1C7sEz3j0tkixFHk2IkxquO
	 ok6ebWSb0H2t0ZXar0TZzk7NDD+AGm1aO1U3m05LZu87Ky1jF8vWQf2eKjOf3BNjHl/Yg
	 Vs3u/U9Vq7O4wLRNFntTasLDUwe6PFTU8iMPs37rcyC5+UfZA63RHSKlkZy5yPV71sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmsFkSV4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4091E606A321;
	Wed, 25 Nov 2026 15:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmsFkSV4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8858F1F000CF;
	Wed, 25 Nov 2026 15:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621738;
	bh=QQLW5BEQAhtskbmgPsGCuTWfVlMMGjsdf0RnfUmU2Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmsFkSV4SEQwvh3IzBhp/nb4AVGm9JCOIq819RklhSIW/4lNVAAdrZQZSGqyrvMgJ
	 7+ABcBbJelcvz8Hxkx1wf+GQ9FXCBCWgFMnaI2KVUhlj8EfXLsVFh3qWCoLKTufQk3
	 wYacpSiDpOP77O/kluID3l8YIhKu32SCJn2b0+l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 322/990] iommu/amd: Clear amd_iommu_snp_en if snp_rmptable_init() fails
Date: Wed, 25 Nov 2026 15:28:09 +0100
Message-ID: <20261125143829.631033656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c4694ff364dbf..3768be55b8e67 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3486,6 +3486,7 @@ static __init void iommu_snp_enable(void)
 	return;
 
 disable_snp:
+	amd_iommu_snp_en = false;
 	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 #endif
 }
-- 
2.53.0



