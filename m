Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590439;
	b=ot6Gu8r9Om5lU3a8vrqfP5fCbM/tegtj0IB5qb8xW23REyRH/SZ+FqjNRdeuXBv1ZrI+
	 Jq3V2vRrA0VVJ5Gcxs7AVPqaEghmr3Sm5JLaFGye+y4NJoYRC+XrIYZDqXW3ySD6T/hcO
	 uU7QdLykypMSaJYAO8z+KpGw60CICPtqli67LmwB/iFzmYQXe/RUdUkMJ/gh2kvbCKLhy
	 SwjzURtejD8+jw/9a+HVZKq1A0cRe44/VN+MawvxxGYu/o0T9vboohOqJwVQpKX9eb+Jh
	 N2sq0hqpY0VHqMathWMDPFYbvYCV49M0BQvgkHQhijh2FGfU1Yv0zU5FvOEBk9Hqljw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9y89AtlWB9cMKv+7nbrIRuXES0F/TZhOnd3uM8FXEqI=;
	b=gxPoNOr+gWjJ+M08AaBAWG0y9XnJF4yThGkHjIfxSlcLyaZeStir0ZQyh8kJNlg9IXN6
	 gzRDdQRugtcpXkjHWlRguaFhk5RXLlDHnME1FrZy/b3AZVzSICY2aLMGqBwKznGfpVdMZ
	 U4t0pDw4KOzaFk/tQ3nFD4eqCueX+UGWPLtC4PHIpSRrKt3DoT/9eo6ybDPtjkea7FNSk
	 A7TWWwEZg9027d3bxirps5z9fK5XeKo4Xls7VjLVtTFpr5rMXIjSNZNqL2uMbMc2MTQcL
	 OAdjY/1WaclxPjKZ90lXqZ0teGibN70iTbkBCnpzWiT1s/z48xgA/jM2vIUzF+gf9Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lE+zrw1I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2394D60703D0;
	Fri, 13 Nov 2026 17:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lE+zrw1I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D811F000C7;
	Fri, 13 Nov 2026 17:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590439;
	bh=9y89AtlWB9cMKv+7nbrIRuXES0F/TZhOnd3uM8FXEqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lE+zrw1Ijxbvxd1kvDMab/qDw3f/wuwje7rMHzJ5BF1qYBySyOSz8iZzhU27v1MJ+
	 Tax6WokML+fYSGiZ5RoQmtBedvE18eJvscUvl/lkAOFCvzGgZAqOdi/fgcC/prKfj8
	 0yCqSlzFze6Ks3IdVqu+khOmCY5XgP2NOes87Lqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 398/686] drm/amdgpu: Check cs flags.
Date: Fri, 13 Nov 2026 10:48:51 -0500
Message-ID: <20261113153834.482099560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

[ Upstream commit f5ea64f9fcd921bc4e2307a262e19450b8a58524 ]

Had no validation before. libdrm_amdgpu memsets this, even
for the raw/raw2 functions.

We have a lot of functions touching the ioctl struct, no
strong opinion on where this is placed, but I thought
early would be good.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d01e15e76358f60ef6734462d2b6d9972b9dfbc)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index efcd2322afa61..6e15b759ef135 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -205,6 +205,9 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 	int ret;
 	int i;
 
+	if (cs->in.flags)
+		return -EINVAL;
+
 	chunk_array = memdup_array_user(u64_to_user_ptr(cs->in.chunks),
 					cs->in.num_chunks,
 					sizeof(uint64_t));
-- 
2.53.0



