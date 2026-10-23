Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773890;
	b=yTs67MAwTG7LiUjEIS4yGnHpj2/5FlLU32IBIhuwrFAuI4muD1Y67oOx7ACLvZX2uVud
	 GPUDGLwX78uh0lRjbV9XRpK+VUAtG1GUfgvbxLbBDTQZAUCC3UTCHgF6RbIdId512Ge6h
	 nhWVF7OZIsHk1pk4dllMTdEVRjpHxZpu+oRdJ3thU4014oJLe11BY4TxiFVEBk3uKPUj4
	 o/XxPpFukdGtPOLH8b+B7CuZIklFqsTp+N3oYq0BvuTGt1CopGeAtgreL69bluC3Ve9Kk
	 WFfE6avU7kYzdoE3gVgOmiaLQXLTHfQ4OlI6WpQHRagUQehLEJfb+xV63ypTfQNB7gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xyc2FT8zuPukfJ1oEGrEePj8ZvkFJvIBCvQ3WsyPlaU=;
	b=ye2Z87nudmz2NvyBg9dXkFLf9X4tymDt8O2y/mMaQ/MoDrDYGOEyh7qIUa2D4KXeOoUj
	 4oRePk8lBMZJr6NFfmDzQcDGUG1JzKE15iyHssZYGM/VSmrMTMbGj62a/KbOewd+l78SU
	 qNkFgE462R9WIWmkAd8jqxHOlqRcpwxaWgacK3TfCLe7cvj9zXq/OAzkvskOhBOG/AvGv
	 zQ91dV+zLc1gh4Rc7qrYSi4gI82St3ZcAzfd2tkYrA2Nx3GcsLtzLPNX66+v5+QOvu4yP
	 VUH0owxZFkrsxaNH5+ALxO6cNwgKLQoy9vNAAsGK9pV1SuYF3ck19pDwQagTob1tHoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Wsn5D/aX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B487A606A31F;
	Fri, 23 Oct 2026 16:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wsn5D/aX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BBD1F01825;
	Fri, 23 Oct 2026 16:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773889;
	bh=Xyc2FT8zuPukfJ1oEGrEePj8ZvkFJvIBCvQ3WsyPlaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wsn5D/aXL8bke8w3Dfmq3QpG+0dqn6A9VVN3RI8B1cBIvKo2MqbyxalaMwYdASLH5
	 uHVHK9RqEob7qw/bRKKtt75z7PQl+K/kcY9lF4pCcLLV2h1pz4N19+yAqvvygKX+pO
	 4DWfOpfR7UQSJg7S42eJqFWY0H7qA7/PE7vrteCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/193] nios2: fix __wsum type degradation in csum_fold()
Date: Fri, 23 Oct 2026 18:35:26 +0200
Message-ID: <20261023163715.367211041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b963f2345fa20417401c51a69dedb6a58eea33a9 ]

csum_fold() shifts a bitwise __wsum type, which sparse reports as
"restricted __wsum degrades to integer". Sparse only checks the body of
a static inline once something instantiates it, so this went unnoticed
until a recent block layer change added the first csum_fold() caller to
a file built on this architecture.

Force cast to a __u32 for the shift, as the other architectures do.

Fixes: eea9507a69d6 ("nios2: Library functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609222053.5gjiJjtb-lkp@intel.com/
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/include/asm/checksum.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/include/asm/checksum.h b/arch/nios2/include/asm/checksum.h
index 69004e07a1ba3..b6b415ae17a08 100644
--- a/arch/nios2/include/asm/checksum.h
+++ b/arch/nios2/include/asm/checksum.h
@@ -27,7 +27,7 @@ static inline __sum16 csum_fold(__wsum sum)
 		"add	%0, %0, r8\n"
 		"nor	%0, %0, %0\n"
 		: "=r" (sum)
-		: "r" (sum << 16), "0" (sum)
+		: "r" ((__force u32)sum << 16), "0" (sum)
 		: "r8");
 	return (__force __sum16) sum;
 }
-- 
2.53.0



