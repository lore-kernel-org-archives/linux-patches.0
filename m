Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77C217BB21;
	Wed, 17 Sep 2025 12:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112904; cv=none; b=YFcUUQVZ5yS9tfpOQwVO61yhJGFZAYymX5ks+4ctwTypDWEroih0DN+0gT2c8kcX6SKtt8dURq7P7KQ/KYlFgh2T1Pv3igucuTu8T8/PPJRITbeSZY7ilIMGU1Q6qed8aXstUcIbq4nQHH78PMsxfj/LZR6hjDSqq7CwHfMYXs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112904; c=relaxed/simple;
	bh=nReBixn6Tmav4gkMi/fx0PRuu+W2Q8mdHk1JimIg5lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaKfTCyVSIPfqnwXH8ZOZnR6EU/vmtCSf8LoDQVnZUjpvCgVwVc1VYdj0i0pz9ZICQB1+9H8LFbXJGYN5nZ87q/K5UZIW+daqiH9PGkT8iPX9nJHH+btNEAiNGLn6Z76sJcWaWiAhJsf7/r92F7yLphGkK6BJlReLquVq871UH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mf3sIGo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mf3sIGo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E78BC4CEF0;
	Wed, 17 Sep 2025 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112904;
	bh=nReBixn6Tmav4gkMi/fx0PRuu+W2Q8mdHk1JimIg5lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mf3sIGo6/yrk02md5VVXuDcq+VdwfsmFllK749Fvy14OrbTBRYHh80JEWx8vj1+FO
	 e63VLt83ajMPGdFg+MDgVVL/xG/A9SSb+uvPIcF5H90p68xZlc8NaPe+cMssW/2pK2
	 O64qTYFh9a2Vdk74sYA15hNkuCEDc7X7RpbpOQ/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Zagorodnikov <xglooom@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Pratap Nirujogi <pratap.nirujogi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 112/189] drm/amd/amdgpu: Declare isp firmware binary file
Date: Wed, 17 Sep 2025 14:33:42 +0200
Message-ID: <20250917123354.604497694@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratap Nirujogi <pratap.nirujogi@amd.com>

commit 857ccfc19f9be1269716f3d681650c1bd149a656 upstream.

Declare isp firmware file isp_4_1_1.bin required by isp4.1.1 device.

Suggested-by: Alexey Zagorodnikov <xglooom@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Pratap Nirujogi <pratap.nirujogi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d97b74a833eba1f4f69f67198fd98ef036c0e5f9)
Cc: stable@vger.kernel.org
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/isp_v4_1_1.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/isp_v4_1_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/isp_v4_1_1.c
@@ -29,6 +29,8 @@
 #include "amdgpu.h"
 #include "isp_v4_1_1.h"
 
+MODULE_FIRMWARE("amdgpu/isp_4_1_1.bin");
+
 static const unsigned int isp_4_1_1_int_srcid[MAX_ISP411_INT_SRC] = {
 	ISP_4_1__SRCID__ISP_RINGBUFFER_WPT9,
 	ISP_4_1__SRCID__ISP_RINGBUFFER_WPT10,


