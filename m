Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D007639FE8;
	Fri, 24 Nov 2023 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFwPyedC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A120C433C7;
	Fri, 24 Nov 2023 18:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849183;
	bh=TXngV4FTJcv9tianYpgOndoxtk91YYNWr0hIBy8a3ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFwPyedCZRcmeqvFsOyS8rGHuTIaWa+o2tTRywJ8eEJ896pd2Z7Z4lrjTRYvH1GEe
	 lb0IN845G0QdEbpFfzD+qpfJ6LzygsipRUPkMU2ajN7IN4IGF71fJe93DcjQaUBf81
	 QgwlRqaRIIqC8fNqjiLNPbH8P8qXOZOMSl7G6pVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/530] drm/amdgpu: update retry times for psp vmbx wait
Date: Fri, 24 Nov 2023 17:43:42 +0000
Message-ID: <20231124172029.760716532@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit fc598890715669ff794b253fdf387cd02b9396f8 ]

Increase the retry loops and replace the constant number with macro.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index 469eed084976c..52d80f286b3dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -59,6 +59,9 @@ MODULE_FIRMWARE("amdgpu/psp_14_0_0_ta.bin");
 /* Read USB-PD from LFB */
 #define GFX_CMD_USB_PD_USE_LFB 0x480
 
+/* Retry times for vmbx ready wait */
+#define PSP_VMBX_POLLING_LIMIT 20000
+
 /* VBIOS gfl defines */
 #define MBOX_READY_MASK 0x80000000
 #define MBOX_STATUS_MASK 0x0000FFFF
@@ -138,7 +141,7 @@ static int psp_v13_0_wait_for_vmbx_ready(struct psp_context *psp)
 	struct amdgpu_device *adev = psp->adev;
 	int retry_loop, ret;
 
-	for (retry_loop = 0; retry_loop < 70; retry_loop++) {
+	for (retry_loop = 0; retry_loop < PSP_VMBX_POLLING_LIMIT; retry_loop++) {
 		/* Wait for bootloader to signify that is
 		   ready having bit 31 of C2PMSG_33 set to 1 */
 		ret = psp_wait_for(
-- 
2.42.0



