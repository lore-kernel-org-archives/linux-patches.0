Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2972326928;
	Sat, 12 Sep 2026 07:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199087; cv=none; b=n6pydz1dDAWq24jj44mSejPJD+NUFz2gqllPqtfS/iTgdxe6vpML09o171qBvnX44wXBWnJUo5fRpoSLOcnjsYeQuqHM3f+Q0kZe3p1+g0FWjBVkGFFdCH2jPBuQpD0ChCkYOQzIiXoXu1A+d4SQyZYyoj5LodUbh0orFytWQRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199087; c=relaxed/simple;
	bh=xfWMXNn8wrFRZLij0wiYXaBdS0A5PIGNvoLhZpR8tmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YZiVHqrcxQOCuJQx2yyE1N849mrl7M2fJoew+VLyJBImUFGOt6RXLA9KRcxyLCGk8hF4pa6Rm11FxICTIapNtYOuB1a/AqwfZ1M/1tvXmEhIvRjdrRSPyiJn1o0Le+nZj92XUOKhif0V2HqCZDCvsiqJMJkpMZDhoahLqwB+kSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoNi/E1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoNi/E1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3FF1F000FF;
	Sat, 12 Sep 2026 07:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199085;
	bh=PelsLD8t0hsMdgdkieqOcf0mVLJxtt21CyuyvLtHQHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KoNi/E1ayT1CFKyWB2u+BgSAaWMQUiLRMx/mTMsUOKddwNeHdYHjx8y+EiQ/mkz1W
	 yEbmCHmDX+STP26yYK8+OPP98r0LkkNNjRmc2AMUtw0cNAeDUAnuV8VApXkHJH3f+v
	 ThkxrEkE3ZUHVZECVdh0zMoh2nxh8PGmMAHnUaiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0514/1815] drm/v3d: Drop unused drm_encoder.h include from v3d_drv.h
Date: Sat, 12 Sep 2026 08:37:44 +0200
Message-ID: <20260912065700.956736893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit cc29c864ee50b9c145fa847406b3535026511917 ]

The V3D driver has no display pipeline, so nothing in the driver requires
drm_encoder.h. Remove the stale include.

Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260604-v3d-sched-misc-fixes-v4-1-c068f5bf5ccf@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Stable-dep-of: fa98563ab00d ("drm/v3d: Associate BOs with every job that accesses them")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index 8779a42c65081..e175e28ca11b9 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -7,7 +7,7 @@
 #include <linux/spinlock_types.h>
 #include <linux/workqueue.h>
 
-#include <drm/drm_encoder.h>
+#include <drm/drm_device.h>
 #include <drm/drm_gem.h>
 #include <drm/drm_gem_shmem_helper.h>
 #include <drm/gpu_scheduler.h>
-- 
2.53.0



