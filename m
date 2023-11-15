Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4143EA72
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjJKCp/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455C4C433CA;
	Wed, 15 Nov 2023 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076377;
	bh=E+Z1iKroRfvOc0k1vB8igsBZzq6X9UNV0TlKDMOEb68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjJKCp/KTuPQCBReXDipurCwgRFr/DXzIMiuKoka1/8AGdZRjgL7nxbkXWudmP5co
	 hVcTFQhrcS3neLNJzqiU2bDKeWxQwzRWtMOCGPgmYjM7Ym9c7kJNLDInmfrvfbq3kh
	 oPR2Wncv7mj7APvQS789+cvOmtSs7MhrmDTLcOfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 229/550] drm/amdgpu: Increase IH soft ring size for GFX v9.4.3 dGPU
Date: Wed, 15 Nov 2023 14:13:33 -0500
Message-ID: <20231115191616.605830641@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit bcfb9cee61207b80f37663ffa08c135657a27ad5 ]

On GFX v9.4.3 dGPU, applications have random timeout failure when XNACK
on, dmesg log has "amdgpu: IH soft ring buffer overflow 0x900, 0x900",
because dGPU mode has 272 cam entries. After increasing IH soft ring
to 512 entries, no more IH soft ring overflow message and application
passed.

Fixes: bf80d34b6c58 ("drm/amdgpu: Increase soft IH ring size")
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ih.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.h
index 6c6184f0dbc17..508f02eb0cf8f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.h
@@ -28,7 +28,7 @@
 #define AMDGPU_IH_MAX_NUM_IVS	32
 
 #define IH_RING_SIZE	(256 * 1024)
-#define IH_SW_RING_SIZE	(8 * 1024)	/* enough for 256 CAM entries */
+#define IH_SW_RING_SIZE	(16 * 1024)	/* enough for 512 CAM entries */
 
 struct amdgpu_device;
 struct amdgpu_iv_entry;
-- 
2.42.0



