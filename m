Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A9615C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9802DC433C1;
	Mon,  5 Dec 2022 19:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269055;
	bh=oW7n+F9BfqLNZqA76H/dDUGydDslGaHF+qB0S3p9T2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/R8rJ5htL4bdApG5I28QbacN1cPbE2197xdt37LljIWB/PpmYRLHEfnBEk1ob6T+
	 rYgW1Q4yNmmHlDYcVYY2IsuT8v1LOxt1d+E2vF3zQI3OGKygUJGjcJPTaGEtJxfPF9
	 CJ9u+KV7e2dVULJdfmfUc09B7arl17o9WQG2ZY9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	James Zhu <James.Zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 082/120] drm/amdgpu: enable Vangogh VCN indirect sram mode
Date: Mon,  5 Dec 2022 20:10:22 +0100
Message-Id: <20221205190809.062506383@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Liu <leo.liu@amd.com>

commit 9a8cc8cabc1e351614fd7f9e774757a5143b6fe8 upstream.

So that uses PSP to initialize HW.

Fixes: 0c2c02b66c672e ("drm/amdgpu/vcn: add firmware support for dimgrey_cavefish")
Signed-off-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -149,6 +149,9 @@ int amdgpu_vcn_sw_init(struct amdgpu_dev
 		break;
 	case CHIP_VANGOGH:
 		fw_name = FIRMWARE_VANGOGH;
+		if ((adev->firmware.load_type == AMDGPU_FW_LOAD_PSP) &&
+		    (adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG))
+			adev->vcn.indirect_sram = true;
 		break;
 	case CHIP_DIMGREY_CAVEFISH:
 		fw_name = FIRMWARE_DIMGREY_CAVEFISH;


