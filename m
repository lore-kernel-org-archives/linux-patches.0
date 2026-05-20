Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C116E3F0A83;
	Wed, 20 May 2026 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299593; cv=none; b=jZs2n04hVXCQtjILMZftwJRhvC0BwcMSwe+R35Cg350u3qiCUXRxacECsCfSOTluFd0dXd+vQ0xQchmZxOJX8k0x3sKcGCTiIoLXoD+2LuGm+1ES9M7W7ZdpOBHR6cC1S88uT1skKa8H0SaNflPD71pBriPbdmrB6Bh8aDPoyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299593; c=relaxed/simple;
	bh=APgAErVJKI1ZDYLOoS6sBQTqsLw5Rm6QWbZjJnkYPy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ttJ6BdFob0E1HumSkgK/83srCMR6kkXGbx67P5utE3PdlvXZCw4hMqc0XeewDtVc7fuX5O/Kanoc0JySLZ4hBW9HrFznWplp7X8DAh/267lC5VkC0yV/NqNXec+l8+ECpLNKFmmxgOD4KePE9MGTUhfs/dIbEOfvYPlzqVK/CKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYGerEd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYGerEd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F7D1F000E9;
	Wed, 20 May 2026 17:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299592;
	bh=DoIvSsbLry12+G2+2nGAOvvHtzhQ1Jtyrwo/b2hOTe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYGerEd8/MKboKGUl0hEsrb0S/AwsXmYV2SiDafM5wdf1Sl55hboa3uxC7+HEQSFO
	 a7D2DFHryIMdsvgv99vPlVcyaUqXp6ONih+NZbrHBSFM/CjkWEPwpwgctk9OwIx4zN
	 HG4oxHqo0mzvUiuHYm27ICSUUzuHCrFds5DcHhFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 830/957] drm/amd/display: Allow constructing DCE8 link encoder without DDC
Date: Wed, 20 May 2026 18:21:53 +0200
Message-ID: <20260520162152.567736902@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 60af4605ef35ecb7ad649a8534b83a2f7c69576d ]

When the DDC channel ID is set to CHANNEL_ID_UNKNOWN,
pass NULL to the AUX regs array.

This is necessary to support embedded connectors without DDC.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 155baf3038c1af50b602723022ed869b38e86a99)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
index 8822d5818d29e..b645c0c8ec3c5 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
@@ -734,7 +734,8 @@ static struct link_encoder *dce80_link_encoder_create(
 				      enc_init_data,
 				      &link_enc_feature,
 				      &link_enc_regs[link_regs_id],
-				      &link_enc_aux_regs[enc_init_data->channel - 1],
+				      enc_init_data->channel == CHANNEL_ID_UNKNOWN ?
+				      NULL : &link_enc_aux_regs[enc_init_data->channel - 1],
 				      enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
 				      NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
-- 
2.53.0



