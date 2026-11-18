Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057107;
	b=Vc8as/UWWFdUzwawwoj6SSFrsUYxZpbtYBE8kEN+7kMGt8GprPtpstaXg4Oek3sZPDE/
	 Gqtilotd0qIy5XPWLv5YXvtFKUMMSUsCu5Iibrc4Js8d/I1a/UW9IhrL4mhlXOnjD56c/
	 ls8tjpesely32d8xV5bJyv6KjGEPM+7KdA/NtIgDU2k/HG26dP3DuySi3NOJk48k/j2/4
	 oF0oo3IYZstgSQ5uy+kig6U+9XIwuVNEf7iWwbZo9MAkaLvD1AW+ohqS2WH840A0FKs6y
	 ECdynzugXWWlqo/uOaB2h1weEh9vZpceR+ILKVQyvcsk1UA1uuO7tGDnjL+yXHQlitw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/hYzo+cY5QPoK2WrtxrON3oqbBrsN3SDcZukN/ZQlZs=;
	b=nxGjEpfDhc3o3n1nNefteLQ0UoIn5zIWHLWZqQXsVfCs9gt/9gd31q3IMyDrvS3FAfsO
	 bkjNwlA67Tyhlh4FWFwgKP8dAC+kB5g2mP1GbJINZ4NcjTVaLNljZu1X8QaHHC2t3i2FZ
	 /pJOih0nfgTbZU0w3hctmD+pgJ5lIBsi9vmHtFyvveTUPoLPCvxQemlUcrVUhykpNzwoF
	 lQjLwh4Jw+96MfCJPZVxOpE0UYtTq86CtBfBM6CvrECHS//aRLZ21KwcJm2j+F6523o02
	 KWhm1UTBCTZdNnb2GWW6QbbfKmXdbfDuAR2DJ0LKVvy884UYmootgk+gnIKCFErtNhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrWIEWHG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B97606A325;
	Thu, 19 Nov 2026 02:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrWIEWHG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC2F1F000C5;
	Thu, 19 Nov 2026 02:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057106;
	bh=/hYzo+cY5QPoK2WrtxrON3oqbBrsN3SDcZukN/ZQlZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrWIEWHGQ+sGEWD5AyjhlLcyWawNjnf4fOGkFt3b7cI744SBgjI1/ienOTnqONRyo
	 PSGYioAhMGIfSakNSTzfqzvrHLbpV7Zd3Qp4VjunkFXJyQ1Mu/m8IL14fsc7wGlhCg
	 3bvI8QT//5lwuJVBZImFlZSqkbANKo1JkOyN8bWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0015/1848] drm/amdgpu/vce: Prevent partial address patches
Date: Wed, 18 Nov 2026 15:34:13 +0100
Message-ID: <20261118145911.784478803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -634,11 +634,15 @@ static int amdgpu_vce_validate_bo(struct
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
 


