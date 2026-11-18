Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042942;
	b=Zqw4e8EOOkO7ot3zakLpcpRAY9W0EyZYW5nxWH+Tl8sGk9Ug/oddcaX3XwxMovdAYIVH
	 y02Ef+SG5XO+0C/I1NBFEAWBVtnsUv1vn/50a8FTI+aNjUODj5OI0hnAxvc3hULclpkLg
	 kP29mr7rgErDfxRN1eKH1b97RWrsYJ3jrj2uK+sguuQfsmGsimfJn0VaYneOQ1qe45Nl5
	 O/isoDf7PUNAXAg3ErXQrBkPU88yauf6CSxpJsP4hsPEZM1i0wH0IZnZxBkqdT47jXjz2
	 gvcHsMdeLplqWBUxV0WOuJzalgvJTQlEReJRcnRRRriXZ4v1lMkCLM21u9aevomczGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n9aNYs+5fBu1YN3jtnMahAsG+5kUNgeM18lxtZytfN0=;
	b=NYR13Qdw9PqNCJ/gzBYP0et2U+SMUjGPP2YH/9ktu/u7kLSU3SRtBsSZuv+PJsT3wbQg
	 kpZW2Jc8pH3MOR3Ry5AkbQRQ0jVXtHEFltejntNbnBIcc0QHNOZNzOEmPnZEKdkOHJTMX
	 ZbfU235XbuklNwBAe7mVA4vrfmMp8p9dh+wFJ8FtxJUaiYCJLFpmkcRx4jKAzydO3I2E1
	 A44peq82NWet7vSkxiE4XEEgQMR6K94LpF9HOIqkqNT9/EZDboBwq/MtIp0gd9ri9SlPW
	 BAxePUDKS5fR95AVZ8MJFdkXTVr9kc0rGonq7IP+dhBRfj3fRM4bahE2nPNzruPKPCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xK0nnl/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E911A606A31C;
	Wed, 18 Nov 2026 23:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xK0nnl/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A771F000C4;
	Wed, 18 Nov 2026 23:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042941;
	bh=n9aNYs+5fBu1YN3jtnMahAsG+5kUNgeM18lxtZytfN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xK0nnl/CedHNNnXidjrYHnWDS7WkhDvqvFTJhmW+tZcqJn2hnE0foAzC9tER0x9+n
	 R0yay1WwR18y9oLc8H0wg8nDclutjPbUQzJVwXH4h3P5hiJmHsE6/h/q4NNrMSuC+T
	 TtOX+bbFGIVRK7Dxp57E6peLxMWW9NA9MyMFnJ7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0034/2857] drm/amdgpu: Add checks to vbios fetch through ATRM
Date: Wed, 18 Nov 2026 15:17:48 +0100
Message-ID: <20261118150202.565507912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 8c3fcfc14fc1320a1155acb2dd7656fce7003bc0 ]

Check if a valid buffer object is returned after ATRM call. Also, match
the buffer length against requested size before copying.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 1b783bb58ea07..649e6624309f6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -278,8 +278,14 @@ static int amdgpu_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
 	}
 
 	obj = (union acpi_object *)buffer.pointer;
-	memcpy(bios+offset, obj->buffer.pointer, obj->buffer.length);
-	len = obj->buffer.length;
+	if (!obj || obj->type != ACPI_TYPE_BUFFER) {
+		DRM_ERROR("ATRM returned an invalid object\n");
+		kfree(buffer.pointer);
+		return -EINVAL;
+	}
+
+	len = min_t(size_t, obj->buffer.length, len);
+	memcpy(bios+offset, obj->buffer.pointer, len);
 	kfree(buffer.pointer);
 	return len;
 }
-- 
2.53.0



