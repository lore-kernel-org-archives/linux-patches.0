Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE5D3A380C;
	Sat, 17 Oct 2026 18:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260775; cv=none; b=mn7hmJu9R3JCGqL8Nmt9XTxaRgC0PjWac62E1NjW7i5qpWLRJ++npkfW+AiW8RrrMhxcFZw75xIagZlaMpz5q0ZFuqXJ+aiMPxEkMtn7qEXKNspw1UhCiQOMgTFF50OYXtvpY4EOhwW+ULqIOWtny9DGJ1O2aSM0/D9a20/DBAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260775; c=relaxed/simple;
	bh=npiQheVHB2sU9MXUwToc3zXqGD2V+UpA5Sw6iE7oUVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dywKwMKieDYdHKSakQYzWrrsda0Jm9Humw0Gx6ZVKIbcoUEnRZsXuATArxTfy25NUw1Pmj/QggZYZFzPdZ0+1GpcfqHogoCALmNFpzpoa6Vj/n0TYIgrshU714md1GilMx22DhGud1X1043yJZhktkibCfmAu5mZZJ/W4K+qkwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR/338A8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR/338A8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB401F000C4;
	Sat, 17 Oct 2026 18:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260774;
	bh=Cf7p9OTVy8wSVyyUnEAAY4GTxF4SADWhiSC5f4j7y2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QR/338A8pSin1i0EPR5398hzlGKDdJxmOAwszpnPK/YxQtJhdwB0RTclSKhcDm2ay
	 aOSlVFdFsmIIiA76CuTxetIOcpywvMCk0VgC62FX46JwoCOD8GbY7v7uo3lki1bnIT
	 TMscEkZnz3O41iTWdra3+W+PxJPbUZ8S9Dx0EUWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+efe2810681f1b065d3a8@syzkaller.appspotmail.com,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1656/1674] drm/gud: validate GUD_ROTATION_0 is present in supported rotations
Date: Sat, 17 Oct 2026 18:05:28 +0200
Message-ID: <20261017160513.578512675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ab7662a31c16d..434c6c4b6c932 100644
--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -288,6 +288,8 @@ static int gud_get_properties(struct gud_device *gdrm)
 			 * but mask out any additions on future devices.
 			 */
 			val &= GUD_ROTATION_MASK;
+			if (!(val & GUD_ROTATION_0))
+				continue;
 			ret = drm_plane_create_rotation_property(&gdrm->pipe.plane,
 								 DRM_MODE_ROTATE_0, val);
 			break;
-- 
2.53.0



