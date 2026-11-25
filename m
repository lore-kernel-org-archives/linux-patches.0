Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618710;
	b=aUqXuLe9IDrUZCQVnqiV7mG3Vw8aV2Va7n1I2J7pgThtjcuzlWMxke6QmmPLs53nhi0N
	 q0/oS8Q9QYT5X6mgQVvgWYqNtPSREty704hmhMlmFlLFhOp5www4zUV1nbPdRZnf6ioh2
	 q+XEVNqlUj0FFWBJdGIRRtzpKIt4JEKumU9Zsw5jxqgyqGZBOM0WD8Kq4ke3+TE+zMxyC
	 BDYxmZPf7m737V5sJ2V5A6SeYEw7Qb3Cdkzv+0wtnYfFjX7yKVXAo7vhFEOUUBoyk+LD4
	 Zyf0zSM7IeE1/v18qYHn/CUljRYi1eyUA5xBJ+wFzaZM1Emrz+1TAQapW2ImwnDX/ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=12yDxsAUPHHtThA4atV+8o+DQVA3/sAO71s2mspYuM4=;
	b=mq7j7pAeWp/+7uDdrjrg+d/6N0V6gM8AKHvkSHOi2TVoOJtoi4djsQOVQszUnNvPovUp
	 /RJyy5d6AxhtCURrbzKUh7DT7qITr4FxDsgk5apwz3KCIfTcRbmzCZf/1sbab/YKcuq8K
	 rf0uzYgXI7+eyT/Kl0pkrbW4pzaUfKI7rlgya3ScW8YGAnrGaSKpH7aY0HDfhhdBQ59gm
	 gB/+Nag4YFGETYe5aNuSslFQ8g/aPERyP2sS2aNXJ3h+VJuPvgTQfwhSP3J8QT1VbSTyO
	 1pXCl8e7I0Muc147+KA5L3w8SdIR50d/6O2KdBmjz2dxiHMYqdqPwWVwpVdcmpCEgew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z83s9qgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B11606A329;
	Wed, 25 Nov 2026 14:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z83s9qgB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B5C1F000C0;
	Wed, 25 Nov 2026 14:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618710;
	bh=12yDxsAUPHHtThA4atV+8o+DQVA3/sAO71s2mspYuM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z83s9qgB3d8Ae5H5IVDZrUhDUf7Vi6IUO4MbyzB1t4AVISZK5YnbfJZZXfNAFIUtQ
	 XCcM5MTTm5spZlwWVzXDZhPXrC75m90qeDUbIR/1OM3TGcBh+GNOu5DTnkX/TW6dnP
	 PWHL022Rrqje0CVaJMQ+djJgdN/7RfaxsXyJWjoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0358/1005] iommu/amd: Clear amd_iommu_snp_en if snp_rmptable_init() fails
Date: Wed, 25 Nov 2026 15:28:16 +0100
Message-ID: <20261125143830.120631220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index cfc061a4247a2..8b924d084ab72 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3493,6 +3493,7 @@ static __init void iommu_snp_enable(void)
 	return;
 
 disable_snp:
+	amd_iommu_snp_en = false;
 	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
 #endif
 }
-- 
2.53.0



