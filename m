Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D5C579827;
	Wed,  9 Sep 2026 14:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963079; cv=none; b=NoKsjP9x+YnZq38xddn9l50/P2mYPiuQIXl4vSD3Ejy753W7mLkbnqQsa1jMnRJ1udDTAIPo+bPK7VvOQ9ObsvxJj76MJSi6r+RMfSzPOuUT/IB1C7OlDjNF+urgbkpAOlS21wav0rqPnemQNJln6TGR4ATua+URR7YdI3ogHZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963079; c=relaxed/simple;
	bh=E6uu1Jkn2us+ENhWdabVL7NJYSluEjJFqssFvD05BCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDNi6B36xdHFeIUD8y1maN2FmWi8zgyHqqyU/LnMS6lBWfej14SXMCKlSVKAV/nLdjSfsNWNJj7oJo12mL0y2z+czn3JesOJDRCCw0t/RvnnlbfMHOCBT6exR9LQybfYCmE36uW7YzS3Z2byg032UJrvxHuH3CauBPmgNGMLwCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HL8PQrkh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HL8PQrkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD85F1F00A3A;
	Wed,  9 Sep 2026 14:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963078;
	bh=l7PoGYJ/6ovR+PwqzJB1nKbpthrhoOPLj6p6/goZpnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HL8PQrkh7gG0+pHuSqzezR4DJuhFiRbUJe3tZn6Utz8toRJipxFZJdeFoNXqklwwc
	 AQ9NyX+G+gTEinRhi4eVoa5uBxdevt7eBZUUqyllTu9WTt5RdIqhQmr35I7t1Ry16R
	 Uq33CTZHx4BAzuP4D1gKChPfSGDsGNWOU8omdd5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 511/556] drm/amdgpu: update the fw version for gfx11 userqueues
Date: Wed,  9 Sep 2026 15:43:11 +0200
Message-ID: <20260909134248.427127283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit c748dd03df33360549ad60cdccee13570e9c0f90 upstream.

Update to the latest stable fw versions where userqueues
is working as it is expected with major fixes.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d50201b891604ab97f305d4a20d888ba93305b48)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1646,10 +1646,10 @@ static int gfx_v11_0_sw_init(struct amdg
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
 		if (!adev->gfx.disable_uq &&
-		    adev->gfx.me_fw_version  >= 2420 &&
-		    adev->gfx.pfp_fw_version >= 2580 &&
-		    adev->gfx.mec_fw_version >= 2650 &&
-		    adev->mes.fw_version[0] >= 120) {
+		    adev->gfx.me_fw_version  >= 3090 &&
+		    adev->gfx.pfp_fw_version >= 3190 &&
+		    adev->gfx.mec_fw_version >= 3450 &&
+		    adev->mes.fw_version[0] >= 147) {
 			adev->userq_funcs[AMDGPU_HW_IP_GFX] = &userq_mes_funcs;
 			adev->userq_funcs[AMDGPU_HW_IP_COMPUTE] = &userq_mes_funcs;
 		}


