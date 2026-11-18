Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034917;
	b=hFu0XlY2ja3R/cz7xo6IPqqv3ACqwvb3NT72TEyLRhI4jV/vx6Fd543vi+MROR/RIi3t
	 DiURqro/EWozreAToWmZstcDizGj9yDAEO4E5O3AYgJxqwSByI4bxMbDeKJVTZx19KeID
	 N48NTD5LLV7AULVDcsSCVGV+cPxUvEoKlWTx/ZrgCTUtzIZxcQTZ68BtA6X0fQPsHbGWc
	 w0FPW7XzJye7/IQMEPEJ7fms/1c7xIJyJOXqq3aZrG8Og3dh+9lROwdjhoHsEl3FPxs/A
	 4ZatidgFBl38cSjr1Nbkb3w1fUqQwNB0mtK8YQ2o/RrPj9XdJKZMlI+Amc/zYrKgKmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jPIpoWS/sENRLXu2j+xUXOBq9qTfBek24u48+k/FasA=;
	b=BrnFzZO54S3k+408MIJl97mvqda0q/qaKyJ4fS409OvdCY0/vJ6Xoy5R3R5bk+jmR5C+
	 1QAGFvzKuEJGDl3AIZCkN2wPwwST/wdN2uWHrr//MD1fycb4oArpkQqXebEEgkPNm1aZh
	 J6yLHbQQN/LFZ5Lf5paKZ6U2/mZb/47CEDyEPxJTYpyBYNXgTuaJ/ZDbT7jfWeIkH8dMJ
	 RaXnt8p6LFaotvITBFKQVDJuGxjBFfwu8YOkFmcKX3q9kGMCF08pHGlcaiH6IMbV83QSj
	 XMXoOa5oU6Ov9bklhbTG+MrEKQhmemj9qfkfA4gKkGod0jP/2PxKeGEz915qk4OF2nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUmx9kj4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCD7606A31C;
	Wed, 18 Nov 2026 20:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUmx9kj4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2651F000C4;
	Wed, 18 Nov 2026 20:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034917;
	bh=jPIpoWS/sENRLXu2j+xUXOBq9qTfBek24u48+k/FasA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUmx9kj4pUdFks/qELwv+o23u+fRUFouXZIMHg33l+cytkiZnZgUS9jTCYsQA6JvM
	 s1F4K5oiPOwOgavW/5hvXIQbbLD7eDA6f218W3XvEDABpPW2tMRTp9s53DN2EcZDgF
	 nQ1N9TZyb1pX1b9xkmsxwjwED/qRQHZtOm6Yn1Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengjun Yao <Chengjun.Yao@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0490/3318] drm/amdgpu: fix rmmio iounmap skipped on device removal
Date: Wed, 18 Nov 2026 15:18:32 +0100
Message-ID: <20261118150331.693074532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengjun Yao <Chengjun.Yao@amd.com>

[ Upstream commit 5155002b03b24ba3ef91c5c313b8cf0171b24904 ]

amdgpu_pci_remove() calls drm_dev_unplug() before fini_sw(), so
drm_dev_enter() is already false there and the iounmap() guarded by it
is skipped. This .remove path runs on both hot-unplug and plain rmmod,
so the register BAR ioremap mapping leaks one instance per unload.

Unmap rmmio unconditionally (guard only on non-NULL) and drop the now
unused idx.

Fixes: 62d5f9f7110a ("drm/amdgpu: Unmap MMIO mappings when device is not unplugged")
Signed-off-by: Chengjun Yao <Chengjun.Yao@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dd6f86a97260e5207d3329ad03aa89fdad61b1e6)
Cc: stable@vger.kernel.org
[ sashal: Kept int idx and the drm_dev_enter() guard around amdgpu_doorbell_fini() since this tree still uses them, applying the rmmio iounmap move only. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index b122e6aa474b8..513fe934453dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4184,10 +4184,12 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	if ((adev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
 		vga_client_unregister(adev->pdev);
 
-	if (drm_dev_enter(adev_to_drm(adev), &idx)) {
-
+	if (adev->rmmio) {
 		iounmap(adev->rmmio);
 		adev->rmmio = NULL;
+	}
+
+	if (drm_dev_enter(adev_to_drm(adev), &idx)) {
 		amdgpu_doorbell_fini(adev);
 		drm_dev_exit(idx);
 	}
-- 
2.53.0



