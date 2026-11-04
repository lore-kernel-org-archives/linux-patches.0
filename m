Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829336;
	b=AA1ySsK99AVgXudZr3z7UT/UH6Lz8iP12Mn/kpKebYT6M4kIOViRmWUIgLPQi5PlsJ1t
	 qMhAeHofyCS6thWt2yFYrV3oDsVlCB6PgFF/kBtMXZk274PMnbzI6D23eiOIHd8/aAdpu
	 DpIW1m1/ymAAUPBhOn2xs1LueTML6zLi13AUL3zB8507OH6x3dxhFRfm7gC8loTso20DF
	 OQRMsN0AO9PPyPwNpbP2bBZQqlnR5WtECcjH1ZuRhNx9Nvz6xXeSTQ0UMYAJOLHIfYfiR
	 vNXlxwO3f2YZ46hwV0gU2Hay7Pqj66OHNEj4aaZIrYyt1F+6yEp9cYpKfjQz33cO1TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aMhccLSum7jHVY4v97OR1PSNzTPXzDPnJIxG4gMlCs4=;
	b=X6S8FNcFVuHOzxgS642CFIx2RYdomoKW7moLO70EZ2REUgoeGWZDNY/GxSwh8QWBmYbA
	 JGPL0WQfWHC9ZmHK9xXgIJPAfmX+r/qFmvSMH9TpxhGX6YYvi7zDNznEchYv4e97s6dFu
	 w6Khh9XXoLwELEQT74CD8phKDMNK7j0/inCnMLJXX/1Fo18uz1oBMJ+omwt9rThXLQBON
	 MHgzxpdF1VX0yA74R1bUqYLVeTNyz2xvY4HWLGU2SbD2yNXDX+TUb+r3ZEe8jHUSXl1CV
	 D8sgtDC+NCYbGCL6fKqZVJQ7E6lPCBG89qXgTuPaOIc/0bIdnnDeuoRNqmDM+d5kRUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oeCyI3Mk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD3860A3834;
	Wed,  4 Nov 2026 21:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oeCyI3Mk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCC21F000C1;
	Wed,  4 Nov 2026 21:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829335;
	bh=aMhccLSum7jHVY4v97OR1PSNzTPXzDPnJIxG4gMlCs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oeCyI3MkKYDQs+Cshdo9EX5y446P2UlriQcl3CdbUgj6NKvtu9PzZrhIiMBT7xP6+
	 Fwek5cst3oGTgmJOQt+wujRQG8XHDftXLyaa+EiIMc6UXJQpIKTeNpFgz+QiAzx5B+
	 hmupIsF345aD1fp/JadBHspb1aJLsCMpUV8JMQEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0062/1005] drm/amdgpu: Validate ATPX buffer length before use
Date: Wed,  4 Nov 2026 15:56:35 -0500
Message-ID: <20261104211045.335426563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 916867cd75dbbc383aa6cb724556de769912157a ]

Add amdgpu_atpx_buffer_validate() to check that the returned ACPI
buffer is of type ACPI_TYPE_BUFFER, is large enough to hold the u16
size field, and that the BIOS-reported size does not exceed the actual
allocation length or fall below the minimum required by the caller.
Use it in VERIFY_INTERFACE and GET_PX_PARAMETERS callers.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Assisted-by: Claude Sonnet (Cursor AI)
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c  | 33 ++++++++++++-------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c
index 3893e6fc2f037..e2a4644896ca8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c
@@ -89,6 +89,15 @@ bool amdgpu_is_atpx_hybrid(void)
 	return amdgpu_atpx_priv.atpx.is_hybrid;
 }
 
+static bool amdgpu_atpx_buffer_validate(const union acpi_object *obj,
+					size_t min_size)
+{
+	return obj && obj->type == ACPI_TYPE_BUFFER &&
+	       obj->buffer.length >= sizeof(u16) &&
+	       obj->buffer.length >= *(u16 *)obj->buffer.pointer &&
+	       *(u16 *)obj->buffer.pointer >= min_size;
+}
+
 /**
  * amdgpu_atpx_call - call an ATPX method
  *
@@ -179,15 +188,15 @@ static int amdgpu_atpx_validate(struct amdgpu_atpx *atpx)
 		if (!info)
 			return -EIO;
 
-		memset(&output, 0, sizeof(output));
-
-		size = *(u16 *) info->buffer.pointer;
-		if (size < 10) {
-			pr_err("ATPX buffer is too small: %zu\n", size);
+		if (!amdgpu_atpx_buffer_validate(info, sizeof(output))) {
+			pr_err("Invalid ATPX GET_PX_PARAMETERS response\n");
 			kfree(info);
 			return -EINVAL;
 		}
-		size = min(sizeof(output), size);
+
+		memset(&output, 0, sizeof(output));
+
+		size = min(sizeof(output), (size_t)*(u16 *)info->buffer.pointer);
 
 		memcpy(&output, info->buffer.pointer, size);
 
@@ -258,15 +267,15 @@ static int amdgpu_atpx_verify_interface(struct amdgpu_atpx *atpx)
 	if (!info)
 		return -EIO;
 
-	memset(&output, 0, sizeof(output));
-
-	size = *(u16 *) info->buffer.pointer;
-	if (size < 8) {
-		pr_err("ATPX buffer is too small: %zu\n", size);
+	if (!amdgpu_atpx_buffer_validate(info, sizeof(output))) {
+		pr_err("Invalid ATPX VERIFY_INTERFACE response\n");
 		err = -EINVAL;
 		goto out;
 	}
-	size = min(sizeof(output), size);
+
+	memset(&output, 0, sizeof(output));
+
+	size = min(sizeof(output), (size_t)*(u16 *)info->buffer.pointer);
 
 	memcpy(&output, info->buffer.pointer, size);
 
-- 
2.53.0



