Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BA644AB84;
	Thu, 30 Jul 2026 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427926; cv=none; b=tR4UR+zazDdFVG03R140ufpfOI4zLpW+F45ileD4GnbEpXVYT5p/NEB6U/5w823WIFsifOa9k3eFZu9A5SXkEGuXhkounIhZ01S/DqZHiygxY9HyicME2JyXAQ1M/nNizhZAsJ1tdxWmiumehEopAglKqGDbDGF4dDGlsJHDpUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427926; c=relaxed/simple;
	bh=cp0Rdc+oeeg3Q5p6alC2M2jfzvemdkLrg/KZqMc+3Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UM2rNWYuTv7JpwXnAXuFNSGrwocK3KP8iO3w4TcpyLtyVz6UtDNZBgtIbhtUX7nI9IPjUoktJrMFeZOKWdWrPK3hgXDjqjeYNyqLeC8Aa70gKNQuKWqfliAhA7GitYPXWkWaMvVLJ+UC3G8saOfbJlpH74iX2bDJEigmiumsQB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7yiB2xY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7yiB2xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8BC1F000E9;
	Thu, 30 Jul 2026 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427925;
	bh=NXr9jGYAaSyfTYR2SXHhXyAhNXSFLZyfyUuePNZhx6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7yiB2xY2OtD908LXaCoJMfW5h1qQZ56rWa5Ye3RNAI2dmLa1bIZl8mFe/eDTQgON
	 C5ZRWjcZGCImwe+XGaUVRiuX8kcM5cAZZE8YslvCUifcX8TZpxkcWyWr9e90uPQgoF
	 1YCiRuwQ1BtRZxuzQuXR3t1EaqjtF44YvYuMko8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 342/484] drm/amdgpu/sdma4.4.2: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:13:59 +0200
Message-ID: <20260730141430.910755142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 40cdbe9fa424cc6264a7aed93a04bd7d69109d9e upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fa4f86a148271e325e95287630a3a15a9cd35fdc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -393,7 +393,7 @@ static void sdma_v4_4_2_ring_emit_fence(
 	/* write the fence */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -403,7 +403,7 @@ static void sdma_v4_4_2_ring_emit_fence(
 		addr += 4;
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


