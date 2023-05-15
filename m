Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB57FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F09C433EF;
	Mon, 15 May 2023 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170582;
	bh=drhGnSGvYxwpS8uOHQel/WorVpxgNQs3Ix4O3UQuUOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARW0iCJm32Pr0RhpJR7Ulb3kfiYkTVZ5pGcJZTdSeu6P4YowVNjelqc0E+g7dLPEv
	 hp22yengii/0iqdVBQYaNn39n3Kl5na9nVvJmKQonPP6MJxR1aEkWf6cORUcmcUa+o
	 EpS9BgLB5KxYbSvQr+nnpR0l3/8tOlj8+2CADwmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.1 149/239] drm/i915/color: Fix typo for Plane CSC indexes
Date: Mon, 15 May 2023 18:26:52 +0200
Message-Id: <20230515161726.152147751@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

commit 2efc8e1001acfdc143cf2d25a08a4974c322e2a8 upstream.

Replace _PLANE_INPUT_CSC_RY_GY_2_* with _PLANE_CSC_RY_GY_2_*
for Plane CSC

Fixes: 6eba56f64d5d ("drm/i915/pxp: black pixels on pxp disabled")

Cc: <stable@vger.kernel.org>

Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Animesh Manna <animesh.manna@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230330150104.2923519-1-chaitanya.kumar.borah@intel.com
(cherry picked from commit e39c76b2160bbd005587f978d29603ef790aefcd)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_reg.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -7840,8 +7840,8 @@ enum skl_power_gate {
 
 #define _PLANE_CSC_RY_GY_1(pipe)	_PIPE(pipe, _PLANE_CSC_RY_GY_1_A, \
 					      _PLANE_CSC_RY_GY_1_B)
-#define _PLANE_CSC_RY_GY_2(pipe)	_PIPE(pipe, _PLANE_INPUT_CSC_RY_GY_2_A, \
-					      _PLANE_INPUT_CSC_RY_GY_2_B)
+#define _PLANE_CSC_RY_GY_2(pipe)	_PIPE(pipe, _PLANE_CSC_RY_GY_2_A, \
+					      _PLANE_CSC_RY_GY_2_B)
 #define PLANE_CSC_COEFF(pipe, plane, index)	_MMIO_PLANE(plane, \
 							    _PLANE_CSC_RY_GY_1(pipe) +  (index) * 4, \
 							    _PLANE_CSC_RY_GY_2(pipe) + (index) * 4)


