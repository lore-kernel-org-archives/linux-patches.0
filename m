Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DEE1A072D;
	Tue, 27 Aug 2024 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769825; cv=none; b=tERrjILqlPGaiQ/2JQ/59D5bbRAZfWsgf7uYLi93FRwqjBcg5Qolmolnwn9HbqaZRb+b9H0faFDOGF1n0eugrmLvXLo5IVm+0jLdk9WonvtYidLbAq7OypaW/HKJNd+C4ac+7fjTuAv8ZjLU0cwEkDlimGkUuL0jDmZevpawJPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769825; c=relaxed/simple;
	bh=JoK40JZ9p5ZeT0hLX2+Gx/DhletrsDQNOxAQEeJHGPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4kiel9jL2nzamyipXbbhNe/jcJwvREDbXaehaoGh7DzJNhmI23QCLFP5Z1s2AlDxgB8Q0JDkIjT4SoTaCA3YuacI5YaNQ+dRIuhvVWFMN+vVeBGn/+2u1qvd9FkzdqsRRgkTwtX4PcE1VUpixkuVOmIHEXUyhkGyx9NZsk4/fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTIzrS7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTIzrS7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F14BC6105A;
	Tue, 27 Aug 2024 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769825;
	bh=JoK40JZ9p5ZeT0hLX2+Gx/DhletrsDQNOxAQEeJHGPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTIzrS7TqKbpIvhrtk4rGtBTaPif0YQUIl4PvdAx2ip/IRdtNnCZAJLKqgOoXaaPy
	 gmPksF0gWSruxPQo0nS1AmTZ4i99Y3WHn0BBfH73ZUEPjPn7isz7VIOrb5WUKYTdhS
	 FeE/3qLmxS8NnPTCyLYhiWLm3CsUbDeAJwrYzA3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 045/341] drm/amdgpu/jpeg2: properly set atomics vmid field
Date: Tue, 27 Aug 2024 16:34:36 +0200
Message-ID: <20240827143845.130427331@linuxfoundation.org>
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

commit e414a304f2c5368a84f03ad34d29b89f965a33c9 upstream.

This needs to be set as well if the IB uses atomics.

Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 35c628774e50b3784c59e8ca7973f03bcb067132)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -543,11 +543,11 @@ void jpeg_v2_0_dec_ring_emit_ib(struct a
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JPEG_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
-	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
+	amdgpu_ring_write(ring, (vmid | (vmid << 4) | (vmid << 8)));
 
 	amdgpu_ring_write(ring,	PACKETJ(mmUVD_LMI_JRBC_IB_64BIT_BAR_LOW_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));


