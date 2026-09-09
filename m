Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7383157981E;
	Wed,  9 Sep 2026 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964469; cv=none; b=EJBU8bDc0JTQReMPTWbiePObINbvvHl6DNjeA8hXXcYrrCAwpnlmjmAq2xESjkZ9A55I4mEwSo7BP6FrjKQT+Mc2xT33zIkxZaKCQMsxl95ToGGZG0z+fgsrSehIy3w4WC9mwCZ2/uY0c4uIZWx5IX2wpDE4KDsAddd5PP57JyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964469; c=relaxed/simple;
	bh=wxw/4UfvTKoU+CJVG9KM0+GCyLdXS+7svy5c1D8Yh7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fkjdv3mQ7EMF6G2HLBEs1YtxmVTalhT4x2rBW7FFW6fvk5OASDxya9WhvjPfoiWIpplR87yquiZB3ziuVWYyFVP/c8flKb3bfB0rvAUM7+oGgRHJxGKJ5xmSbszJNiluHpsJnYox6DKztr7OQLEEtTugJtoWCIvvJ+6IjiUKfMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNI7Dz2A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNI7Dz2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C547C1F00A3A;
	Wed,  9 Sep 2026 14:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964468;
	bh=jTEFle6gkI75TBtmKp+p7kpYC0lYlvqs8PME3ebiS2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNI7Dz2AHjE5GfdMdO0nNOjwXR6/HTjiYOTwYUjYhFzzvQ2AbO99Mam8etaRjkmWa
	 uQoPqhzieAW1rOaIVzP88p1nZqwerpJg5z+75gtvB8U+aAHy8IcjpwvLWkwtBediiF
	 5j9oaWRxTBxGOcXlrQfW4PSqWxwpqoyWdGv4Hqzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 396/583] drm/amdgpu: update the fw version for gfx11 userqueues
Date: Wed,  9 Sep 2026 15:41:21 +0200
Message-ID: <20260909134251.715320594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -1616,10 +1616,10 @@ static int gfx_v11_0_sw_init(struct amdg
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


