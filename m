Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFFC1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5F9C433C8;
	Tue, 25 Jul 2023 11:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283472;
	bh=oz7/QPtMuVOwe2yBxSsqCPaxyc3ao3wWGv+i6Kv+yH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbPCv6knt8bkufHUTbWQpCb73M9wD4RsATdNMPSfvc5Vi+/VwF9Zuf1cw4PQzz24e
	 SGchMAJt/wGeG6G3UH9oKT8XqBr8t7wzR2XZ3TKkS31thsGFtCs9ZIuZC8N1d8HC92
	 KwUnZRdzlIKX0TXvNh/aPTAkv8pK5/aq7AHzgiFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 010/509] drm/amdgpu: Validate VM ioctl flags.
Date: Tue, 25 Jul 2023 12:39:09 +0200
Message-ID: <20230725104554.111141285@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
@@ -3252,6 +3252,10 @@ int amdgpu_vm_ioctl(struct drm_device *d
 	long timeout = msecs_to_jiffies(2000);
 	int r;
 
+	/* No valid flags defined yet */
+	if (args->in.flags)
+		return -EINVAL;
+
 	switch (args->in.op) {
 	case AMDGPU_VM_OP_RESERVE_VMID:
 		/* We only have requirement to reserve vmid from gfxhub */


