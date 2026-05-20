Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B1E36A352;
	Wed, 20 May 2026 16:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295118; cv=none; b=ONYxeujcnU8QbAIAV2ygkCwY4cbSs98qx+MSem0iLbS+oqRDOga3UrnnM3NDaHyQaDVWttGrF/Yp6zae2wFDe7OeThkw23suHCG/g3+3AopaXzrIp8EcgprshcmgMqSYblK/mY/c/ssEzfSmsHboun5zvWR3Xcar1m61O+AmBRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295118; c=relaxed/simple;
	bh=tYgnDAXwSxo7rvZwlWUvYKBmwDWsuLDjyo8tqGoxydY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6bi8f4bDw+gNTwuTJf74C2VQuqzUiU/dRiy/QS2fMrT+54nKvv3POwmtzjf3HHa2rzbzZrnzgYF23ZUcd51+O0NQ0T3yixh17FBKHClpJ+6nfRbQne1hpvMtQQKmAKOYnhdJaW71xeZ1ujSsSNJqPphBWroetEGmWKJFuwXuDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xs/Jb7zI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xs/Jb7zI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1033A1F000E9;
	Wed, 20 May 2026 16:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295116;
	bh=iymdLom2c7pUdMzyd1Qabzy/lpEsY+YrWAUbSQWq7S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xs/Jb7zIgb9i/309mUv5RDEKyuSV6US9GUrzgOBdAU56ASzfSdXgTWeCCEdSkcSgO
	 4GtocwkNQ7QYPsRIYLjvvl9JVP7VLMng+4CFBvjQOx29QAavreKTUCsntDqw15IXMK
	 ntoNcfmDmWuzJyYdxDlH7cxGLK149PxVStSLyflE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0295/1146] drm/amdgpu: Add default case in DVI mode validation
Date: Wed, 20 May 2026 18:09:05 +0200
Message-ID: <20260520162154.890501033@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit e6020a55b8e364d15eac27f9c788e13114eec6b7 ]

amdgpu_connector_dvi_mode_valid() assigns max_digital_pixel_clock_khz
based on connector_object_id using a switch statement that lacks a
default case.

In practice this code path should never be hit because the existing
cases already cover all digital connector types that this function is
used for. This is also legacy display code which is not used for new
hardware.

Add a default case returning MODE_BAD to make the switch exhaustive and
silence the static analyzer smatch error. The new branch is effectively
defensive and should never be reached during normal operation.

Fixes: 585b2f685c56 ("drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)")
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Timur Kristóf <timur.kristof@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index d1bf2e150c1ad..780a0078c91a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -1239,6 +1239,8 @@ static enum drm_mode_status amdgpu_connector_dvi_mode_valid(struct drm_connector
 		case CONNECTOR_OBJECT_ID_HDMI_TYPE_B:
 			max_digital_pixel_clock_khz = max_dvi_single_link_pixel_clock * 2;
 			break;
+		default:
+			return MODE_BAD;
 		}
 
 		/* When the display EDID claims that it's an HDMI display,
-- 
2.53.0



