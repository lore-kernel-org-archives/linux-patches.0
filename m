Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96671C0DE7;
	Tue, 27 Aug 2024 14:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769828; cv=none; b=ryzBp+PfM31eBkblhwx+sncvvKuvP8gx6pM3SVr54MJAy++N4RMPW5IUo387tcoWdcESnWxv7yq+/QBsCCUfFHD4hpAqdU0JKZLShaeKO+DX+hHEVoFAph1KL4MsVLm7V2Gc8pNsnLswotAkFK1h5mpjQHh1s2K0w/zT90tBWOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769828; c=relaxed/simple;
	bh=5anuDyGmlKWe0TuGnxuAMCOIFG3+Z6a6tJcj3cl7gdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WThbIa9GMx5oHMwzcLMEv6uD4RghT1QlOZSr7Fjuyfk2aNbJ5Jh17w5psskU4GvZVjeNb3auwRZ0FU1MkUx6G98fkivLPBoV9jTL14NiK5zLHZPROaoFQQdNrlyxEBZ8RSorV2vEOs9dZ9LtAcD7PfVQfS+fXvt8E5K4JYOOBuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkf+j4FD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkf+j4FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29481C61053;
	Tue, 27 Aug 2024 14:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769828;
	bh=5anuDyGmlKWe0TuGnxuAMCOIFG3+Z6a6tJcj3cl7gdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkf+j4FD7rMgv1LsnXIoVNhn0FauNK03A9nPWljAqHADKCao5QbRmyfwF9xl9bzMd
	 aGY5/yZ14j7xgtfadfDFbmwmNe7YO1xrQKZ6PsUOLcZxUb/mSpJS46CJQkS5+1dO6E
	 WeiackcVy4D3FhXKdxP/htejWcBnmj9A0yGBCo4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 046/341] drm/amdgpu/jpeg4: properly set atomics vmid field
Date: Tue, 27 Aug 2024 16:34:37 +0200
Message-ID: <20240827143845.168355519@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit e6c6bd6253e792cee6c5c065e106e87b9f0d9ae9 upstream.

This needs to be set as well if the IB uses atomics.

Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c6c2e8b6a427d4fecc7c36cffccb908185afcab2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -769,11 +769,11 @@ static void jpeg_v4_0_3_dec_ring_emit_ib
 
 	amdgpu_ring_write(ring, PACKETJ(regUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring, PACKETJ(regUVD_LMI_JPEG_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring,	PACKETJ(regUVD_LMI_JRBC_IB_64BIT_BAR_LOW_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));


