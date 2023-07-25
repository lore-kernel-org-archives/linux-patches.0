Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DF21ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C74DC433C8;
	Tue, 25 Jul 2023 11:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284955;
	bh=GEcaT8s0i/6RrhTANooKP3g61nMFEdcuojfO7me/7A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wy2ukCGXkZ+KvkaVWbpy2dKnf/7+gmDgzKBeAz0rttgY4U5K9qF1EmygbiPgNzjG
	 44J0cr+hj01IP4wiilGotvLy4uJi2QIu55hL+c2U7O0TG0gqYpVY7kmSu0IVRxq+wP
	 7C3r+grU+Zy6BtDTGVODP6nYm7mrky5b7R1OZnPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 008/313] drm/amdgpu: Validate VM ioctl flags.
Date: Tue, 25 Jul 2023 12:42:41 +0200
Message-ID: <20230725104521.547233723@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit a2b308044dcaca8d3e580959a4f867a1d5c37fac upstream.

None have been defined yet, so reject anybody setting any. Mesa sets
it to 0 anyway.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -3076,6 +3076,10 @@ int amdgpu_vm_ioctl(struct drm_device *d
 	struct amdgpu_fpriv *fpriv = filp->driver_priv;
 	int r;
 
+	/* No valid flags defined yet */
+	if (args->in.flags)
+		return -EINVAL;
+
 	switch (args->in.op) {
 	case AMDGPU_VM_OP_RESERVE_VMID:
 		/* current, we only have requirement to reserve vmid from gfxhub */


