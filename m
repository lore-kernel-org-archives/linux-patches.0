Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632593DEFF0;
	Thu, 17 Sep 2026 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665163; cv=none; b=mF8SGQfL2aEwM6YHgTpsbTjq8vyHVumeogeIDBBDMw8E8YWk/1ybNVKJPUh8PR0i/cU9T+aAFfefHUo9vtNzso+rGxxBtm/MZ+oiBI12QoKatQe4C463Izk3qLXERZjcPkS5E48d1ro0C056ahpZvispPpFV+t+RTs68O/PfUZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665163; c=relaxed/simple;
	bh=QW6K8kYSecPK3ji42dXiujNvjwEC52hpISvRg2OWKwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTm8sMifcqXrQov2F3VAWsS8Ds7JXupZDaoyPfSIXVzWOVL8hUV2ktl1wVtF3Q8pK59K3ddF2DJ93hajSQaXPLUQ2ehnO8or8bvAQEUpKKQzxDNPQn+LA46Cc4vF9PIqPp0v+QSwDvQbQVPTlwCSvABtl0rtL/mXxJYGM4oP6gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVS9ZJ9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVS9ZJ9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16DF1F000FF;
	Thu, 17 Sep 2026 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665162;
	bh=5UIbHrFYF/AEEtJKBXLBszPPWL6oHs6IeWcWNU9Vgp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVS9ZJ9CjGNY3E+PpB3iDQX6sYBrhrRtyLfnh680HaIhqKI8s4VDaF0iqRIxcxxRx
	 7oqvA3JHwVTCAIb0t/XGHyTL0oMFnarT6XYI9gQuNesepZ0M0HGjcABzmAWbUHf6Wt
	 dZ/bWAHAsT1wIULVo9r1aKKZ7IevaR3vP7/OsKEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+efe2810681f1b065d3a8@syzkaller.appspotmail.com,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0614/1250] drm/gud: validate GUD_ROTATION_0 is present in supported rotations
Date: Thu, 17 Sep 2026 16:06:49 +0100
Message-ID: <20260917151608.515429059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Sajal Gupta <sajal2005gupta@gmail.com>

[ Upstream commit cb732d027aa18e1fcf9d2797f47d20b179ebc59c ]

The rotation argument to drm_plane_create_rotation_property() is set to
DRM_MODE_ROTATE_0, and the device reported rotation bitmask is used as
the supported_rotations argument. The driver never validates that
GUD_ROTATION_0 is present, so a device that omits it from its
GUD_PROPERTY_ROTATION triggers the
WARN_ON(rotation & ~supported_rotations) in
drm_plane_create_rotation_property()

Fix this by skipping the creation of rotation property if the device
doesn't have the GUD_ROTATION_0 bit

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Reported-by: syzbot+efe2810681f1b065d3a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=efe2810681f1b065d3a8
Tested-by: syzbot+efe2810681f1b065d3a8@syzkaller.appspotmail.com
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260821071812.16500-1-sajal2005gupta@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gud/gud_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/gud/gud_drv.c b/drivers/gpu/drm/gud/gud_drv.c
index 4f0906f677b2a..81c0440204c7c 100644
--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -289,6 +289,8 @@ static int gud_plane_add_properties(struct gud_device *gdrm)
 			 * but mask out any additions on future devices.
 			 */
 			val &= GUD_ROTATION_MASK;
+			if (!(val & GUD_ROTATION_0))
+				continue;
 			ret = drm_plane_create_rotation_property(&gdrm->plane,
 								 DRM_MODE_ROTATE_0, val);
 			break;
-- 
2.53.0



