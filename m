Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016718;
	b=fpMcV3jZvh2CeK483WOATNZty3RlHO1f+gWjNaG2hFQts8WnfQ7B+Exkc1IBXaSCfcGf
	 qoPy1F5iC78HPg10JWB6dFFKZNPvMSeo87JCVDoL9Nz4sq/ZR2gBJOEZdHkpltPH3XU1K
	 dsad9utGxNbCUNn/uoA17WJHpPfF1LIo1PPLCsqOuyi5lDnJyVaLK5ZMMe2aTYmZM891s
	 Q0WhammeGgyA2IjZsZ8ycccKIe3mCMj3asHkVTfTN3LRhgmyoUnODWeD6/aJxjRpR88Km
	 BCukFGWwf1LP3lFEU4TJ66BOrRpajmeT/wgGnGh4SVJ2iLMGjqM1qjvxuuxEmpd2o4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VjhyYuKltHg7+qreAfmcBTyCw4sJRx1yLtF0N4D6LZg=;
	b=QKArcxBIrREiZ4WP1/kHPX9pMNz0KoD6xc77JtKeMyro6cyqidV2m0UmdDLfmWLXNawz
	 /N/Sg7N9F3TuvHWIzIn3SRnwzAc6DNyNDBZJW+GgMpWMbMBFii5AFPgK+mhobWTkTvqQE
	 IBNbNewv21xL/yxnhS80g2cma/q24J0Z++kMwj/LQI9npx7xF5C2s6/9xq/iXX69ps+le
	 l6sh3kqKM6bosrvJiq3BNZ2xGY0bkUmBdrm6sh4+kMfvX+oJSwF/cz7BQC1iMLXsYgwu+
	 4zODgqxLdj6ZkljfYzFX4HXRncmCxY/UG1rqSV6ATOrP36PX+DrNAN+jBNqZypPxK5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2532oJu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9942C606A325;
	Wed, 18 Nov 2026 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2532oJu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2611F000C6;
	Wed, 18 Nov 2026 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016718;
	bh=VjhyYuKltHg7+qreAfmcBTyCw4sJRx1yLtF0N4D6LZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2532oJuSrJ3ndwQREmQUK3dq/oZfktAdIKD/Yir6EGeRiF5T9jBFLSV/7dGHPv3E
	 3GhlpVOEsxyV46klDV20nWqbMQRJLIBBy/gllwzkF5dDD8na75xbwGNSFXe4UD3qiK
	 8K12bXmkZvAuFQ6qEHZ8UYvka0hfLY0loazJVCDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0628/2651] pstore: reject persistent RAM zones too small for the buffer header
Date: Wed, 18 Nov 2026 15:31:08 +0100
Message-ID: <20261118150310.298695225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 1b30df8662ac85a6759be4332f3bec7e3cb28efc ]

persistent_ram_buffer_map() computes

	prz->buffer_size = size - sizeof(struct persistent_ram_buffer);

without checking that size is large enough to hold the header.  A
ramoops zone configured with a tiny size (e.g. ramoops.pmsg_size=1)
underflows buffer_size to a huge value, which defeats every bounds
check in persistent_ram_write() and persistent_ram_write_user(); a
write to /dev/pmsg0 then copies user data far past the end of the zone
and corrupts kernel memory.

Reject zones that are not larger than the buffer header.

Fixes: 404a6043385de ("staging: android: persistent_ram: handle reserving and mapping memory")
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260921202317.70595-3-parri.andrea@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index b4ec8009b8dc9..ae941777037b8 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -505,6 +505,12 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 	prz->paddr = start;
 	prz->size = size;
 
+	if (size <= sizeof(struct persistent_ram_buffer)) {
+		pr_err("%s: persistent ram zone too small (%#llx bytes)\n",
+		       prz->label, (unsigned long long)size);
+		return -EINVAL;
+	}
+
 	if (pfn_valid(start >> PAGE_SHIFT))
 		prz->vaddr = persistent_ram_vmap(start, size, memtype);
 	else
-- 
2.53.0



