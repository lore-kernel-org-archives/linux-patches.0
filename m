Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BECB79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52B4C433C1;
	Wed, 30 Nov 2022 18:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833767;
	bh=V0AqxIDOONoyXZEl5EDegsTa0xn50WpUOXCDtgye3TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkhLonbNSpI+UNU0sKWuDFH4tipKnrd7Csox0t3rFompqf2ZQBH7NmMRDWqlN1MAg
	 +oN2vtd7ZK4+I/dZvPCQk9OCLXNcJMedilt/nYh5UpS0WhIFt1EeJcYmagy163eitV
	 3ME/Q76GVgXIuCHHd/qeDNEYdHtAnQq1ZjvYN9Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramesh Errabolu <Ramesh.Errabolu@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 204/206] drm/amdgpu: Enable Aldebaran devices to report CU Occupancy
Date: Wed, 30 Nov 2022 19:24:16 +0100
Message-Id: <20221130180538.215070012@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
@@ -44,5 +44,6 @@ const struct kfd2kgd_calls aldebaran_kfd
 	.get_atc_vmid_pasid_mapping_info =
 				kgd_gfx_v9_get_atc_vmid_pasid_mapping_info,
 	.set_vm_context_page_table_base = kgd_gfx_v9_set_vm_context_page_table_base,
+	.get_cu_occupancy = kgd_gfx_v9_get_cu_occupancy,
 	.program_trap_handler_settings = kgd_gfx_v9_program_trap_handler_settings
 };


