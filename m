Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930AF1B6D0A;
	Wed, 19 Feb 2025 08:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955095; cv=none; b=Ft/hVERwJlRXON9KzQVrBVKBUFMlDwUUH564x485CbWW+H6/WXlDo9XE6lyLtCUzIoLtncD/hJPLUHlH1RG1U8qLyThn2TEWyj2HBgsJxHugaXJdKz6XmSrlD9rv1s+w7DOUrhnOYY5s0ZBOy0cEPsFrYXroZMitkYlcaXWTcuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955095; c=relaxed/simple;
	bh=unFYozWLdHewEgyxeg0f5CpDgyJLidw275xsS8mlwyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UT0JY/jYAxvNM00vHFJPP4nzPTM3aPL+o9lT+dV5rlY9n+pXa8XnnPlJMTtChaKYUo+4CXaxC31UbJ+CFe8/7uiIoH/zFH7WiSt6ExpC1PLTO4ULysqqE+jZIyQ4WzGvwev2g8/R5Rtxhwyt5ie6bC9WjJoIp4IgroNlkUjmmck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxxkvPHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxxkvPHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1513EC4CED1;
	Wed, 19 Feb 2025 08:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955095;
	bh=unFYozWLdHewEgyxeg0f5CpDgyJLidw275xsS8mlwyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxxkvPHA7zD3g0dthvRttPSxVlE/t6LEri2jVVp29m8TZgqoRjoIzLWI3NjzbOwwU
	 LZ5jq8Wf8Dgv2yxh5cNPR98Hwii9kdT36r72hS7DxuPf5eOlDN5Wk6ZpW6QqmFOfTH
	 2JH9I0OE+E5F4OPSaFiTZ4DZIW9QxRB37ga8KTDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 098/230] drm/amdgpu: bump version for RV/PCO compute fix
Date: Wed, 19 Feb 2025 09:26:55 +0100
Message-ID: <20250219082605.530543710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 55ed2b1b50d029dd7e49a35f6628ca64db6d75d8 upstream.

Bump the driver version for RV/PCO compute stability fix
so mesa can use this check to enable compute queues on
RV/PCO.

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -119,9 +119,10 @@
  * - 3.58.0 - Add GFX12 DCC support
  * - 3.59.0 - Cleared VRAM
  * - 3.60.0 - Add AMDGPU_TILING_GFX12_DCC_WRITE_COMPRESS_DISABLE (Vulkan requirement)
+ * - 3.61.0 - Contains fix for RV/PCO compute queues
  */
 #define KMS_DRIVER_MAJOR	3
-#define KMS_DRIVER_MINOR	60
+#define KMS_DRIVER_MINOR	61
 #define KMS_DRIVER_PATCHLEVEL	0
 
 /*


