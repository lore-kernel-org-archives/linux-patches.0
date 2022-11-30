Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F7379C1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F3DC433D7;
	Wed, 30 Nov 2022 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834522;
	bh=uHHSGPzE4k2K2s3UvoZj95mnjpRNpL1UddUbRSLWg5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3C0yHPIJdVz01TJJV1Tx4sL+3f9ytrWHMcVnQAPysmYG7CgK23y44sfovsKR3ibC
	 k4j5LYvvZWxCRJqGBEb47ZlZ3Ue0/06KxzmqfGLDbiNbTR99BA5Sy8Rdv48h7PhnR2
	 qFnBPpxTnr8UyPomfUN10+Aerf6Mk6g8P+2pHmsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramesh Errabolu <Ramesh.Errabolu@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 284/289] drm/amdgpu: Enable Aldebaran devices to report CU Occupancy
Date: Wed, 30 Nov 2022 19:24:29 +0100
Message-Id: <20221130180550.541008982@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ramesh Errabolu <Ramesh.Errabolu@amd.com>

commit b9ab82da8804ec22c7e91ffd9d56c7a3abff0c8e upstream.

Allow user to know number of compute units (CU) that are in use at any
given moment. Enable access to the method kgd_gfx_v9_get_cu_occupancy
that computes CU occupancy.

Signed-off-by: Ramesh Errabolu <Ramesh.Errabolu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c
@@ -41,5 +41,6 @@ const struct kfd2kgd_calls aldebaran_kfd
 	.get_atc_vmid_pasid_mapping_info =
 				kgd_gfx_v9_get_atc_vmid_pasid_mapping_info,
 	.set_vm_context_page_table_base = kgd_gfx_v9_set_vm_context_page_table_base,
+	.get_cu_occupancy = kgd_gfx_v9_get_cu_occupancy,
 	.program_trap_handler_settings = kgd_gfx_v9_program_trap_handler_settings
 };


