Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9BA391836;
	Thu, 30 Jul 2026 15:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424425; cv=none; b=JE6lPKZgWYotJ6MbO3yS7V0WlBboJ6mE4pUODHN2qsNZtfYb+50Kahz9w8T6dT6Iay6TGOqhi9lYwILZpsAUbReDYsXsqwZRuCCt2RcprHImv2p7ry1bHivEann/KgY0LCvDYMwPBNWKAG5D9cSPXjL75RxST4dYMWRwslmOdO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424425; c=relaxed/simple;
	bh=cjK/KYjw4Ow9RUCoCLvVi9Q5wngwhQRcrkrd+nI7z6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmh9lLp2KPF46PtP2dq9K7haCSpSVdyUYtEOrW2iL5urCOtjy+ZPnU5QtjSj2EyMJ5NsThmE9ZatYm+8TBctfYynK/K0iQLJvE/UqbH8DIZC8nqiFnuSi0zaaATs/mcHjJP+CNNsNN24mjr+Scgq57LVbJEVziRj1VLzfOfykdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbxKK53x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbxKK53x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957261F000E9;
	Thu, 30 Jul 2026 15:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424424;
	bh=/+OnSiXuWZw+gSpeMm8NE8MMrf4lmUDlgkgH/us3Ymw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbxKK53xoQAm29Iu+Yg4W8AyjglRu59aPD7cjvgGqHbMdAjfXgxDM8sVsiEdvWah5
	 Ywh5Qz8Ioq2sdSN2Uz7ktOEzWOwlrZC/n7hVNksuQnU5XwrnJDuLtO6oYYlyJZ2jZ1
	 5p++EdEEK3IMtRQwpx3LveNyoWBWzMrJG8Ryfx+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 362/675] drm/amdgpu/sdma6.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:32 +0200
Message-ID: <20260730141452.824968533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ec42c96c322e5cc48099ab5e67b5cbe236cb1949 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c17a508a7d652da3728f8bbc481bfffe96d65a87)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
@@ -360,7 +360,7 @@ static void sdma_v6_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -371,7 +371,7 @@ static void sdma_v6_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


