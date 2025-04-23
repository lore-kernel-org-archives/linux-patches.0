Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9107A2BE101;
	Wed, 23 Apr 2025 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421682; cv=none; b=skMSkIMR57jLZsKs1wtsblLg9cr8DCZS+wBZVF9TE4BBPH1q7xHzST5Vvi6uPUaVsTeQq7u5uDZcuZ7BeWoH5d1AYT65qakw4SD8yIUerl6P9QMfLHJLXt4a4IaYJh5/uTnmptys5x+vjJcis2Dc7+demIxqR8lVYm8OdfW1Ic0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421682; c=relaxed/simple;
	bh=icdxCIF20ysLf8BxQUFbsqXxC2ZaOEksU/qxC2yFAfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ICP9iEd8xkRt3N9YYUrcFhoECHd/UaS5R23CuY9lVe/0WCC2c2OUrlUpA2x/2fAmmQtJ30NYiRIzGtacxVM2zl7ASQeTibD31gnYrtXY79TR9nhgcV2150t8bkZWFcnQQjD9ASXGDOQMX1ubQVycDVOGfHd2YMSRUmdfp3ldEOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9PjX7FJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9PjX7FJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968D2C4CEE8;
	Wed, 23 Apr 2025 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421681;
	bh=icdxCIF20ysLf8BxQUFbsqXxC2ZaOEksU/qxC2yFAfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9PjX7FJ9F3T+HI4WXGewcubo6aqOsHmShvV2RuQQP8OM1aTO3emFzIjrsBPaz2EB
	 0wiAVdRdAHmGEOaZO3klerWBd6DraFfGiFhm/Sbi358CYvfRPigYziwMXeQb6dZJkk
	 rB34+LvRgeep/ZVcyQrCfMHifhbgK2zo0WRSA4Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wakko Warner <wakko@animx.eu.org>,
	=?UTF-8?q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9?= <afmerlord@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.14 219/241] drm/mgag200: Fix value in <VBLKSTR> register
Date: Wed, 23 Apr 2025 16:44:43 +0200
Message-ID: <20250423142629.505225032@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 76c332d119f9048c6e16b52359f401510f18b2ff upstream.

Fix an off-by-one error when setting the vblanking start in
<VBLKSTR>. Commit d6460bd52c27 ("drm/mgag200: Add dedicated
variables for blanking fields") switched the value from
crtc_vdisplay to crtc_vblank_start, which DRM helpers copy
from the former. The commit missed to subtract one though.

Reported-by: Wakko Warner <wakko@animx.eu.org>
Closes: https://lore.kernel.org/dri-devel/CAMwc25rKPKooaSp85zDq2eh-9q4UPZD=RqSDBRp1fAagDnmRmA@mail.gmail.com/
Reported-by: Сергей <afmerlord@gmail.com>
Closes: https://lore.kernel.org/all/5b193b75-40b1-4342-a16a-ae9fc62f245a@gmail.com/
Closes: https://bbs.archlinux.org/viewtopic.php?id=303819
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: d6460bd52c27 ("drm/mgag200: Add dedicated variables for blanking fields")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.12+
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Tested-by: Wakko Warner <wakko@animx.eu.org>
Link: https://lore.kernel.org/r/20250416083847.51764-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -223,7 +223,7 @@ void mgag200_set_mode_regs(struct mga_de
 	vsyncstr = mode->crtc_vsync_start - 1;
 	vsyncend = mode->crtc_vsync_end - 1;
 	vtotal = mode->crtc_vtotal - 2;
-	vblkstr = mode->crtc_vblank_start;
+	vblkstr = mode->crtc_vblank_start - 1;
 	vblkend = vtotal + 1;
 
 	linecomp = vdispend;


