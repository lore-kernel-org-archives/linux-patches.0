Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050893;
	b=qkZQEohxjV91PYttkQgJWgInIIIPAShncl9eOu66wsb4V1bvQaVwchhfd3NvOyhtW3LY
	 dZUa9lyLAf3A0fAsFEowM1rFDbyiND06HYCqM8IiQfkEvEYdnebV4JYiPa+zvgiZYQt/Z
	 46omO/tr9MBxhRFvQC0WVe1LJAMfkBFRCVtJUiwBoibYbMXQFtzCu36SrHZ0HXaL+QT5h
	 v6CbN+SSMAabINbz7tszp6fBevOm8wGkn+kY7LU/lx7VsJ9+fH0bQt5xw4sQMYvf5wBAO
	 SY/G+27utEYjCFdxTnb2PyiD3ZnIaQjNcJeADeXaBvnKctUM3RsYSEGMApVqArkPuhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ysi+20G+lHWN3XQ4d2bpvBmLvBcv+CLhys2a1bQbw2Q=;
	b=uNJFux/UhPZaAriXzKdvK6uYV5LfMvXR1gDRD3YZ+gosOdzVWl5NPu8pvfA8uZSTAOL3
	 Quebq5sUt2hbfyXleNeC2U0F02GzuOnZkJngPK+ISFZr8sPyAZU0izAfh+teNKn3e0kjj
	 lQ/Cod8WCdD+ZZdNbQfj0ulbjyn6fu4h+ZRCSSFnB1tL2IHKveE2teVuhNMCclUf6ImZV
	 F5a4IPRuAlQ85XbAUTaSyjmV/zX+U+QZF4eiBwYy+BcVqMFwWg6Ei+7HMfXWGCmZR+ALr
	 A2lM7ze3tE4kTANKbU7VcBsryJaO7YpZuZiRg2zIimjH/oSMcupk66NbK/CnHhiQSbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ddjg8cI2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD98606A31C;
	Thu, 19 Nov 2026 01:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ddjg8cI2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEBF1F000C4;
	Thu, 19 Nov 2026 01:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050893;
	bh=Ysi+20G+lHWN3XQ4d2bpvBmLvBcv+CLhys2a1bQbw2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ddjg8cI29O6YfckHj6WpyZLCm11avm/CRAqLpcGvcYzU49STQOhCznJZsqLyseVjC
	 1lGJzI89se0VTnxcR8nA9StnwVVoZJhLkYfRQ22l4wbbC9OgM9FmhoGkjfVGCiJ+MU
	 bX+UzHFxPkyqVn9J8G87kEsGXoNSuY/8rvCpIe/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 0016/2214] drm/amdgpu/vce: Prevent partial address patches
Date: Wed, 18 Nov 2026 15:28:12 +0100
Message-ID: <20261118150010.792380303@linuxfoundation.org>
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

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit de2a02cc28d6d5d37db07d00a9a684c754a5fd74 upstream.

In the case that only one of lo/hi is valid, the patching could result
in a bad address written to in FW.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
[ Roman: In 5.10/5.15, amdgpu_vce_cs_reloc() does not take a struct
amdgpu_ib *ib argument. The conversion was carried out by commit
cdc7893fc93f ("drm/amdgpu: use job and ib structures directly in CS
parsers"). Instead, the IB is obtained via p->job->ibs[ib_idx] ]
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -642,11 +642,15 @@ static int amdgpu_vce_validate_bo(struct
 static int amdgpu_vce_cs_reloc(struct amdgpu_cs_parser *p, uint32_t ib_idx,
 			       int lo, int hi, unsigned size, uint32_t index)
 {
+	struct amdgpu_ib *ib = &p->job->ibs[ib_idx];
 	struct amdgpu_bo_va_mapping *mapping;
 	struct amdgpu_bo *bo;
 	uint64_t addr;
 	int r;
 
+	if (lo >= ib->length_dw || hi >= ib->length_dw)
+		return -EINVAL;
+
 	if (index == 0xffffffff)
 		index = 0;
 


