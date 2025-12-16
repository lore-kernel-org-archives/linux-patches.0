Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E4C328638;
	Tue, 16 Dec 2025 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887059; cv=none; b=bIvVzzChtwePoubqI3llXBQMQYadbyT2y5LMB7megi56Rch9Siht/GEybxw1NSfiOBHXK34nRFj+7uUiX8QAdIRAD273WWdAYXA9zCv3XexZHafyz1bVosyXtZmJyauY4KpzhawqhlrLgyVgVWOaf6qUYsRI89y305CEdLkujpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887059; c=relaxed/simple;
	bh=Ax/UmH3dY1+iRn+EIpLDhTyFpo/3669DejVBzWFzPTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWlGjppjFrcmcQfHHZfkNgd5ilzMEtVQZpvMbWPz75LNyvXIoI6HIAqmceXGoQtkDot4iiu+Npr11rkA+4leHudN0zFIpnPxYESd792T7g/tuVFTkNY4g18qgQOoozorJjk7RxpRGlDpDglaC+4rn9k15aLVI7FXeXr+IUiRoTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKm4+WjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKm4+WjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E26C4CEF1;
	Tue, 16 Dec 2025 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887059;
	bh=Ax/UmH3dY1+iRn+EIpLDhTyFpo/3669DejVBzWFzPTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKm4+WjYlnUVcK1dyC5ZSQBgZVifCht4bK/E6HkoZHolpKi3tusRK0kt2R8pnR246
	 ZH8d3m2oLelpMtLmz7T2MeF8/7eJFQJ9WKo8Xg9eWHiVP5D2wA4EnqOBK9nqlOnm1I
	 BoaKWT8td8sj3Xya2dTHaNF0N5dZSgXMHDVpg4n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/614] accel/amdxdna: Fix uninitialized return value
Date: Tue, 16 Dec 2025 12:07:44 +0100
Message-ID: <20251216111404.833346202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 81233d5419cf20e4f5ef505882951616888a2ef9 ]

In aie2_get_hwctx_status() and aie2_query_ctx_status_array(), the
functions could return an uninitialized value in some cases. Update them
to always return 0. The amount of valid results is indicated by the
returned buffer_size, element_size, and num_element fields.

Fixes: 2f509fe6a42c ("accel/amdxdna: Add ioctl DRM_IOCTL_AMDXDNA_GET_ARRAY")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251024165503.1548131-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_pci.c b/drivers/accel/amdxdna/aie2_pci.c
index 6e39c769bb6d8..43f725e1a2d76 100644
--- a/drivers/accel/amdxdna/aie2_pci.c
+++ b/drivers/accel/amdxdna/aie2_pci.c
@@ -845,7 +845,7 @@ static int aie2_get_hwctx_status(struct amdxdna_client *client,
 	}
 
 	args->buffer_size -= (u32)(array_args.buffer - args->buffer);
-	return ret;
+	return 0;
 }
 
 static int aie2_get_info(struct amdxdna_client *client, struct amdxdna_drm_get_info *args)
@@ -920,7 +920,7 @@ static int aie2_query_ctx_status_array(struct amdxdna_client *client,
 	args->num_element = (u32)((array_args.buffer - args->buffer) /
 				  args->element_size);
 
-	return ret;
+	return 0;
 }
 
 static int aie2_get_array(struct amdxdna_client *client,
-- 
2.51.0



