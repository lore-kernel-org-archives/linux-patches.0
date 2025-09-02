Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA25306D3F;
	Tue,  2 Sep 2025 13:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819624; cv=none; b=ufLChvHeqIH9/VwqhOY+9TBAT9aKtKs8k/7zZR+VokhvD+PMj551irge9HOfbW9R2+6rGMxYnkfeHx3HH4wGBOTmM8I693Ky+YcXE5V/oAtKXlLcSG3+NmqTsCuBzxVWJTvXxXGHb2fs0mCJrIiuZoqYdRoaX1tJrchMPPxD9Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819624; c=relaxed/simple;
	bh=LSolS6qBIbywrdDuZmVj4dyGMkrRPkDf2shJ6iQuHx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvdgZNmVDgfaSequvlXn1NFl+h35WLVUp5DIZaHvOrTUPBqcnjVRdNMxGNrMofytB+66zzBK5vRBBIXFAyzoj6cOEU1eDYA6lco0i+y+Q1E0S4Bt80/d6P+oQL7QKCpG0zCX9RQP+AvnOURcTQzB/vN9OsdqFNijFoFduGtMxnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/9BNShD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/9BNShD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC6DC4CEF4;
	Tue,  2 Sep 2025 13:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819624;
	bh=LSolS6qBIbywrdDuZmVj4dyGMkrRPkDf2shJ6iQuHx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/9BNShD9ppz4ZcBz5AYsCzC67+LeYpGh4hL+d3uBtCvVROPF+ryWN2QcACHpthed
	 We67ldkIzKGVYW5kobr3qTwGrr8nyenQJp8lC9kLo4SYaHm3Urk8dl068B60UgtBaX
	 3BhgBdVl/QsPQJGZjDo2AkiXSPCqSbTT2/AKL/44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 063/142] drm/msm/dpu: Add a null ptr check for dpu_encoder_needs_modeset
Date: Tue,  2 Sep 2025 15:19:25 +0200
Message-ID: <20250902131950.667047832@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit abebfed208515726760d79cf4f9f1a76b9a10a84 ]

The drm_atomic_get_new_connector_state() can return NULL if the
connector is not part of the atomic state. Add a check to prevent
a NULL pointer dereference.

This follows the same pattern used in dpu_encoder_update_topology()
within the same file, which checks for NULL before using conn_state.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: 1ce69c265a53 ("drm/msm/dpu: move resource allocation to CRTC")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/665188/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index c0ed110a7d30f..4bddb9504796b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -729,6 +729,8 @@ bool dpu_encoder_needs_modeset(struct drm_encoder *drm_enc, struct drm_atomic_st
 		return false;
 
 	conn_state = drm_atomic_get_new_connector_state(state, connector);
+	if (!conn_state)
+		return false;
 
 	/**
 	 * These checks are duplicated from dpu_encoder_update_topology() since
-- 
2.50.1



