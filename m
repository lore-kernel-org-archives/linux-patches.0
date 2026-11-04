Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831287;
	b=sUholR1dJwHgj35C8czAxcLIK/vxKH/7hmtg5CxSMkM99OQ58DuUON7VoialfxakLk8I
	 B/pTuKR+v9krOc2SYgzvgBNMM/aP4b+KmfNFYpSWuWj9W1qTDcxmpNO1YKzzjeNeE9Grw
	 p+SvhcpI8cJBCqehbudb9ZwliUkHIhy4MDIhot7xr2FSjfKpCOBN4J0FheN7NyAn/EJV9
	 m6KGGneRkgaWseDh0YsvbkBrcszEMHgJ41+kojWV+nwoy3/mfJkufzuFD5AE0AoIoNqSO
	 PZhZQeELqEndsGNF/THRJHxpPKwfhqKcCQDxmzIiUhJ+U8Uh/3AmG3JOiZEYao2YzZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zQL9zEMfoQOhArd6YemxIizKNMKCG41Was7icYG7QXs=;
	b=Jz5JSzRTjdwkzQidtdKzl5kEUkx3Z5eBLDukGCiACfe1hMF9H9I7XIjmMRa0XRH/Yj1m
	 8DvQ5CZEwGBpbvrzXFeof2c4LG2aTf0JURNgzNZeBBV4juJIN0HxzKxj9eZoIbCyBpoRr
	 Oq6U2kMtQltExvuI293qjD147aiHGcN2Cr5bopwdcVRfrszJk7y9MXIjIhZjfYC7mnxki
	 k31ju5bRlBpW1iam5qYu7zFqUqbRuJDfku3NnFHpz4E7z8qsZ8m4erZUc3X0K858n1Rax
	 01opBdzh65bvStM7lUJHLUrBxDEZlWTebSUOBQyTHdnzjo6cgtjRcProt69ditUzvjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGDmKc2V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB1D606A335;
	Wed,  4 Nov 2026 22:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGDmKc2V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E861F00919;
	Wed,  4 Nov 2026 22:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831287;
	bh=zQL9zEMfoQOhArd6YemxIizKNMKCG41Was7icYG7QXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGDmKc2VUcudUJqnhLmYL0vtkgUPTkcbY27pqsAJ+BwZ23WD8ZYWCM8G/es1Yd4iQ
	 qLkxEWQND6E6c+g8p3eL0HH0FLttQeS2+cYeYfp9s6BPyfDv4xHUisG0CjyOyQ2ZPi
	 iR+NfmddyHnkECmn5Kxfh+OdSvJ9B2FUrF6JUlCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0612/1005] drm/amdgpu/gmc12: properly pass flush_type to gmc_v12_0_flush_vm_hub()
Date: Wed,  4 Nov 2026 16:05:45 -0500
Message-ID: <20261104211100.986574728@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 0bfb1bfc82e8fa386d4fad1caa5812b6afafa626 ]

In gmc_v12_0_flush_gpu_tlb(), flush_type was not properly
passed to gmc_v12_0_flush_vm_hub().  This only affected
the MMIO path.  In most cases the flush would go through
MES.

Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6498e33f22a12fdc759a0c78bfe0547819277a36)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
index f22b4197a1c96..7b326d502e6ab 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
@@ -339,7 +339,7 @@ static void gmc_v12_0_flush_gpu_tlb(struct amdgpu_device *adev, uint32_t vmid,
 		return;
 	}
 
-	gmc_v12_0_flush_vm_hub(adev, vmid, vmhub, 0);
+	gmc_v12_0_flush_vm_hub(adev, vmid, vmhub, flush_type);
 	return;
 }
 
-- 
2.53.0



