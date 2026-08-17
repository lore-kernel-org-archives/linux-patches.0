Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8744143BDA4;
	Mon, 17 Aug 2026 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975894; cv=none; b=gKyJLuTTi3bi2eR7UzxTa8vFk6fElOHkbZ+vfRutI0azNkpelcyWXoBe0XyPx5ewy8Eb1BG+s/56lLYuiaiC+WNgjyr1FsW1KTfIFH6OtphigNg/hgwLsctM3DPmHgFJ2W9dDIPemZfeQx8VpALqZgqfn1hOcIH56xMFU0SA76U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975894; c=relaxed/simple;
	bh=+EiCx84RhWomtxsnbElHY9wBKdvek5YRi0ey+hP3xIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku/u4+nJSuG0TlXFM8gagdRWgtuvxfUZsKPd7LICxcwW/io7piq11t9zvBlB5pIgxUgWoyptQpjakTyViW1kuuHOhMH0UU57IPWt+M/7k0J6F9c7XowXnCKzrkOI5tMV1NkCKqsyXU1hQol8uC2cZDuT23tQUGF1tWDVlPsqVr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2Gn45Ya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2Gn45Ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07651F000E9;
	Mon, 17 Aug 2026 14:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975893;
	bh=+9XtwNodlLY3CoBb0KNrmXdw+Bqkc9NReLeOKtFOp3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2Gn45YaJ+0hyJkSF05iTOnNY+qxUWBeR7IrC7sFlBbQdPxFtBTgy1GO9RXcK1SOo
	 ovWhuB7veCpdqPutoIiBxPjrOPWKoJG6G7FG9kcHnaGjTmOCVdaxCnj6vn1T0LT2VZ
	 SjuC4CU8GKoZEnEHG1jRGezeGXZCSrEgFZSLGqvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 184/389] drm/amdgpu/gfx8: drop unecessary BUG_ON()
Date: Mon, 17 Aug 2026 15:30:23 +0200
Message-ID: <20260817132546.359643625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 84a1a8a952ab4b8c23c5dd1f2eea4049cb4914f5 upstream.

There's no need to crash the kernel for this case.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d7c25208ca612b754f3bf39e9f16e725b828891)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -6292,9 +6292,6 @@ static void gfx_v8_0_ring_emit_fence_com
 static void gfx_v8_0_ring_emit_fence_kiq(struct amdgpu_ring *ring, u64 addr,
 					 u64 seq, unsigned int flags)
 {
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


