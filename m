Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28B0247289;
	Tue, 20 May 2025 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750225; cv=none; b=MgHMXRpctm3GiPfUA7Iq4G5Cg55tpKgA7JAXyiVL9PPaUpuneLa1Kk6LfZvzXdfcnU2pRgBUpHpMWLAvZtHii4Dpm7xeKDI+/Kogv2+USWTqphBTDdgR+8XCGLEfuWOZK3cNbVH52GCGFGvLDiOmbaYJ8XS0JKPymLyw2hMKW8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750225; c=relaxed/simple;
	bh=jVvJS2sU4BrISJsSYr3mTN6slYjQozeHZnNvZLtgshc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwsKhON+HR7vT/YEAYIJcXGsV5BOpkow/AAxsfNB4CKTCqcM/+Vt/UAgCk2FsO5WQUw/G5zZ4J1+hbhmvyLY+taxE8M8orfYP2TBeWdR/425xd2SbpqTGHvhY57jH9fq9VoUsHSdBimITkBs1XyTbAsoDj/VqDETman0HcyBHUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY1d/hq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY1d/hq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7155DC4CEE9;
	Tue, 20 May 2025 14:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750224;
	bh=jVvJS2sU4BrISJsSYr3mTN6slYjQozeHZnNvZLtgshc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AY1d/hq1CSMeyvQ+m6kUxmlGSF02W9+L7QgnWrOfnywFuQAR99n4zcgNkhrhM2d+V
	 Yrkvj1mzHx8KRE1ZxT7W26CsbZI8xW+5QArVu+QxlsQFx8gM+sbz2qRZIlta8vwekD
	 zvkK8xM5AlXWMbRw1QnAwD1B17EqpRN0wkl/Tt+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>
Subject: [PATCH 6.12 083/143] drm/amdgpu: read back register after written for VCN v4.0.5
Date: Tue, 20 May 2025 15:50:38 +0200
Message-ID: <20250520125813.331476160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

commit ee7360fc27d6045510f8fe459b5649b2af27811a upstream.

On VCN v4.0.5 there is a race condition where the WPTR is not
updated after starting from idle when doorbell is used. Adding
register read-back after written at function end is to ensure
all register writes are done before they can be used.

Closes: https://gitlab.freedesktop.org/mesa/mesa/-/issues/12528
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 07c9db090b86e5211188e1b351303fbc673378cf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -985,6 +985,10 @@ static int vcn_v4_0_5_start_dpg_mode(str
 			ring->doorbell_index << VCN_RB1_DB_CTRL__OFFSET__SHIFT |
 			VCN_RB1_DB_CTRL__EN_MASK);
 
+	/* Keeping one read-back to ensure all register writes are done, otherwise
+	 * it may introduce race conditions */
+	RREG32_SOC15(VCN, inst_idx, regVCN_RB1_DB_CTRL);
+
 	return 0;
 }
 
@@ -1169,6 +1173,10 @@ static int vcn_v4_0_5_start(struct amdgp
 		fw_shared->sq.queue_mode &= ~(FW_QUEUE_RING_RESET | FW_QUEUE_DPG_HOLD_OFF);
 	}
 
+	/* Keeping one read-back to ensure all register writes are done, otherwise
+	 * it may introduce race conditions */
+	RREG32_SOC15(VCN, i, regVCN_RB_ENABLE);
+
 	return 0;
 }
 


