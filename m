Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051149;
	b=ARnztYQNmrW8QjCQ1TeP16Q/kr28E+943l4n9/DabAamwbaOV/ZGPfs+ULMMn09YnJ2R
	 OZU8kbhL4HPoeD9FLB1PN1so0xAac3m4srKnSpgD7cKv47V0zkF+McsqShVqR/stMd87M
	 qp/tM1UAS0478uimi17ZbRiPMhj7RhWYnksk+DWhMn3F0rMOjPnCLoszVD0nSL0NQvm/V
	 rhq4GwozCzwJSgxm0i+lP2HXLghLKJef0n9o+mGDolwpjGoBw234XjyDkR6JJ3KNRbcb+
	 gHm5F3A7cOz+9fXxZrKM/RiMWg3dHpOBL8Sd5b5MFqMqFV8+Ttx8sEgBmAbEF+AubSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QUb+DuHPnrYoKf8eWn7R8eynd0nqIBa60tUzvKoPCPw=;
	b=jWXtduyHCyp6W7IOjYm9T8nHc/ARS9wdbZrOayu63j8TtNTbcrmAYvRyJAkoImaoiCk5
	 /xETK1DPchVTqQS17Zo/4rYVv/OiLRa7UKpodmvMRy+C1Zx/lxYRhfYnJ6raQ2858TqPU
	 KbkYofqAkmDXDU2KmMPZd5Y+F3VPUMhwvXym4Q0PqaeViTHQF8/uR04JXVobdO72GUL5p
	 lz07OafwPGKheaJd2c38dH2C6yftwSWF1hbV7b6/t1gcdbYmNAntd4pe8rs6e0AtFlDxO
	 3uW5IDIRWeWVhAoa70/gglk1v/13wv6kAj+AOx8JnDDrGNA+0Rwm9RuffdiJfrWGe0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OrB9jFV3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B48606A332;
	Thu, 19 Nov 2026 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OrB9jFV3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AE61F000C4;
	Thu, 19 Nov 2026 01:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051149;
	bh=QUb+DuHPnrYoKf8eWn7R8eynd0nqIBa60tUzvKoPCPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrB9jFV3G8quS3GDj0JXD8XbyqRAO1b0abdSAO809T8dF2lLklDkcWEN1OWQFxVMq
	 PK6N4SdHMRHlfusYwtpLoXIJOk642EKIpvymylskK6fXNhmjgs81Yw1HPbvLGWzUS5
	 XGXpAIUpxr2ON3Onmuko7Lh72sZui+Bjcc+oqsrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0106/2214] misc: genwqe: handle a first DMA address of zero
Date: Wed, 18 Nov 2026 15:29:42 +0100
Message-ID: <20261118150014.158569201@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit d401772a9e18e837631450844f835229354528a4 ]

genwqe_setup_sgl() uses zero as the initial previous DMA address. DMA
address zero is valid, so a first entry at that address enters the
merge path before last_s has been assigned and dereferences NULL.

Only merge adjacent mappings after an SGL data entry has been created.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260630104923.53827-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 039b923d1d60a..95eba283fce57 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -413,7 +413,7 @@ int genwqe_setup_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 			size -= size_to_map;
 			map_offs = 0;
 
-			if (prev_daddr == daddr) {
+			if (last_s && prev_daddr == daddr) {
 				u32 prev_len = be32_to_cpu(last_s->len);
 
 				/* pr_info("daddr combining: "
-- 
2.53.0



