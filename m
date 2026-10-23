Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774590;
	b=erU2CliqX1PrQoor2tme9b9TpfwXhNTwjbgyEzvmV+DMHwSmvhvNuRM6a+X3hfR8B4Ol
	 gWKutVSBdqJmyERqxKTg3Zk36LPI4kxbM4+bIk1PLpOE1UrXeAuGjLt5x/RUwjrzRz5ii
	 8/fsLOBCnjSyikSj6dcd6g1hQvQCErubbe6E0Z8Y7APWGssujM4F6agTXXMmhrtJzEV6z
	 c9rTrY+n76Plie/nqMDYlDI9BIe3amqohPRiCTQDoUzIGtwLZwE+vR5Rhcv0eAaZml74F
	 uNRhbw9pQErQyfBHXBcZLf/0HZXc8ZakEdEfdCIn0aSACBjuI2SN981zxL5l93w1/+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RXwdKGf9+YFDn+L0OBWSczsLDaNwcVc26ut0bLy5pRY=;
	b=XU7EJ8O/KL+48gVBURFDBRCMDN9A3cjaCT5LI/llGm1XRafgXVGrYsNzc7oABWRUAgmw
	 Arl86ykp2P9/RpZwY7nQXoiMu4yjCXK9nnK9b0fgCkL5CieixKdQ+R3az/UrTOqvAtXEC
	 QARfp+19NW2JsoH3jssWrt682AzA2lshsAvWWxwEP9Q0RNcWdfx+v5tal8O+PVxSGfK/T
	 3ma2PhPQkI/f8jY402XTVVf9JlgoyQOGaPCkAOZmhQEetuJIS1DhBiY6BM0/StgpXBJBt
	 /cyhr8GonX6/epfimI7KAmaJCmxcH/3g4GWkO5g7M+CyYJIfX6zN3OBCljZHJl2FJEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EN37df9U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901D9606A31A;
	Fri, 23 Oct 2026 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EN37df9U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF74F1F01825;
	Fri, 23 Oct 2026 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774590;
	bh=RXwdKGf9+YFDn+L0OBWSczsLDaNwcVc26ut0bLy5pRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EN37df9UrvGJ+Bv5jMgnPGIN3/O3rPXrMJ1p2XGhVs2/diau3V9EqlAVw73LKvu/o
	 1ZXWJZmGGJL3tnaaPmvxiSsT3UsDscVKWVfcxLt/7LfeFYCRvOo49vRl8pbqcBsz26
	 wH3Eu096+ob2P1NEqx92O0AdB2g67AGgUwIRO1+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 054/242] iommupt/kunit: Use if_changed_rule for the kunit
Date: Fri, 23 Oct 2026 18:38:16 +0200
Message-ID: <20261023163715.057157976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 4bcfe29021993cb167fd9bbdb849f7d7247a166f ]

Use if_changed_rule so rule_cc_o_c runs cmd_save_c_flags for the kunit
objects. Without the saved flags CONFIG_LTO_CLANG_THIN_DIST runs the
ThinLTO backend with no --target and generates x86_64 code from arm64
bitcode.

Fixes: 1dd4187f53c3 ("iommupt: Add a kunit test for Generic Page Table")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610110841.120JzAJG-lkp@intel.com/
Assisted-by: LLM
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/generic_pt/fmt/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index ea024d582594e..e308760d02b7d 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -25,6 +25,6 @@ $(eval $(foreach fmt,$(iommu_pt_fmt-m),$(call create_format,$(fmt),m)))
 # with -DGENERIC_PT_KUNIT
 $(obj)/kunit_iommu_%.o: $(src)/iommu_%.c FORCE
 	$(call rule_mkdir)
-	$(call if_changed_dep,cc_o_c)
+	$(call if_changed_rule,cc_o_c)
 
 obj-$(CONFIG_IOMMU_PT_KUNIT_TEST) += $(IOMMU_PT_KUNIT_TEST)
-- 
2.53.0



