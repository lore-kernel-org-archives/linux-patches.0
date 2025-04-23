Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164CF280A2C;
	Wed, 23 Apr 2025 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421113; cv=none; b=q+jcImoG/HfrOJjvaN65S0WgjeSFN2yFRS8HSrT9nNVHpYgENfV3JXbArnvVtDtjxdYhswlLXJQYY2R145N2A4OuQ6J293cJjCvJj8qpRQKaeHazBwv1ISyXqsyRNOg5uoZuKNktFnh0G8NuV6Qm/gNwlR+cpH57dHvm6O4iRDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421113; c=relaxed/simple;
	bh=USCzaULdMivVnwX3KQc0hB9AKf7a2Ol9EKY4h90E9Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=knAaRPtVs4AkyspABSBfeq7OcbRll/jG9JHACwHNJuFzQn8zwpzKMmuKMetpRzh9Ec+5+3SOfdcVg4dtjT/qHJqQ/SGwfwFeS5j3FQi2DrKdxrjyGxUwU/XZxJH286LiAv/HXd7tkIRnWQyloDWk9jl8JUeMB3vCrC18BCNmO0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=helW73BE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="helW73BE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A937C4CEE2;
	Wed, 23 Apr 2025 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421113;
	bh=USCzaULdMivVnwX3KQc0hB9AKf7a2Ol9EKY4h90E9Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=helW73BELAhnYS5cOToyT0zecD7pSTDQi1o8gN12POcfXaPzsVM0hAydqJqza364a
	 YIMYw6KqdDqfm1uq6Vu6X3qJZoQNB6aXFkLoemk1FUDuDQV96YS4atijUbSb3hsACl
	 Tm8y13jriR/u7uePu7mCCWvx4/Fkyzb9wqVwWJZM=
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
Subject: [PATCH 6.12 185/223] drm/mgag200: Fix value in <VBLKSTR> register
Date: Wed, 23 Apr 2025 16:44:17 +0200
Message-ID: <20250423142624.704501207@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


