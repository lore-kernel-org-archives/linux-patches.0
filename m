Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4ED2DFF04;
	Sun,  7 Jun 2026 10:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829578; cv=none; b=HxNXG3D+GubZAZVBuZImEezQvfPUSQDmybM17Hd20WceByxF4dK7itbw9YuuUf2OSI1nF4xQeBeazsOOtoUY2cijWwJ4e87i8Ks69zkG8XTGubYTl63/nklN5pghh2uPO39qoItB7he7lPv7/wu28Hy8kccTJkFsMnCUjBY1zWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829578; c=relaxed/simple;
	bh=8diRm4w09Kms5kKLa76RYY59yoV4PBmp02fW+DiONiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhjLqim22e+XvEkowU1mnMV8/Dr2RdnkRKLAie0FNBrCTT0ufrZH7nOh/GstVvLl9a10PTAZ0ladjL+KMejEPYs7DcsyZgphXdSR98OAApHW+O1Htx+BwyKTJtiiqQOSmwv1hYKUvLYxfCXabYDQEUXjnq6iw7+iW4U62XpbfxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+534sKQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+534sKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66FA1F00893;
	Sun,  7 Jun 2026 10:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829577;
	bh=eXKh1Dcqohsd14C71rd+LRa86L2rwouG8kyrZLC/jBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+534sKQkigBnpbUyhA1lr51xDuLnNnLn3JWZfnoOCie9sO9Fjy/I9VqCp0oBOCXv
	 IN8WRcbv7XFQ0Qbl7lPeql0cS07U30OVNPjUf84InpcyhxnFSX6eyvTNzLbGRmZ4kx
	 bqzFxClLnKgNN5ykxJYLBgeIX3DuBIKovjUusf0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pranay Samala <pranay.samala@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 7.0 291/332] drm/i915/color: Fix HDR pre-CSC LUT programming loop
Date: Sun,  7 Jun 2026 12:01:00 +0200
Message-ID: <20260607095738.741059446@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranay Samala <pranay.samala@intel.com>

commit d196136a988051173f68f91de0b5a1bd32122dd7 upstream.

The integer lut programming loop never executes completely due to
incorrect condition (i++ > 130).

Fix to properly program 129th+ entries for values > 1.0.

Cc: <stable@vger.kernel.org> #v6.19
Fixes: 82caa1c8813f ("drm/i915/color: Program Pre-CSC registers")
Signed-off-by: Pranay Samala <pranay.samala@intel.com>
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260519075308.383877-1-pranay.samala@intel.com
(cherry picked from commit f33862ec3e8849ad7c0a3dd46719083b13ade248)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_color.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index e7950655434b..6d1cffc6d2be 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -3976,7 +3976,7 @@ xelpd_program_plane_pre_csc_lut(struct intel_dsb *dsb,
 				intel_de_write_dsb(display, dsb,
 						   PLANE_PRE_CSC_GAMC_DATA_ENH(pipe, plane, 0),
 						   (1 << 24));
-			} while (i++ > 130);
+			} while (i++ < 130);
 		} else {
 			for (i = 0; i < lut_size; i++) {
 				u32 v = (i * ((1 << 24) - 1)) / (lut_size - 1);
-- 
2.54.0



