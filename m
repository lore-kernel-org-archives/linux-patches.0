Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962A83F5BF7;
	Wed, 20 May 2026 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294511; cv=none; b=OgRrfImQgBj7ORzssIet9+Ua/PuZl6hza6nGa6om8p2P0OjNHxcq5AF73zqmKrOiRKJIwG2V7ZgFTfaQ5eICgr8faaxkE3D+JVbs0sOLR1dILE1tjU1EZVe0BjRCrKprGeEtHA14GMcpZQEZT8fDxcYplxHoC3epnybZ9AwWBJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294511; c=relaxed/simple;
	bh=bZm2nRmgXLvQWOmUa7w73WUrgRSfa4Ex+RDI1D44B+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZCqlt+TQrV/UJUTG1QrChOA5WSmLBpx9fwO9vnvtCKFwCENafNAWsbBk3MoVGcuxlfwk7OD9JHHnX6O5d7hHFsKLCd1KvGWfxL7Rub807/PRLj7JNoxbWLHlr3jWPeEsYFK7Nk0Kx+9fEdQn1Yc+kc5z5sUxbHCzOmhYMfvKI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkRZ29ab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkRZ29ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D49B1F00894;
	Wed, 20 May 2026 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294508;
	bh=7F+pKd8it24yUMVY0WZb9acN6GXWFcv9erFexdKCa+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkRZ29abKX8LMomrdg9IhVC2Ge8yS5ZYGt0fnRgHsRPDkaIJaqRszmoNJlocvHymP
	 BjcSnhqzgMOkS2+lb4HoWRbzVYXoIJ1VoBynezeTHIXSznrZd2X3GE17qMXD89qv0N
	 a4Eb4n6cv3uymHac6wszgNzMZltAgG3+oAc6Lf2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0065/1146] x86/vdso: Clean up remnants of VDSO32_NOTE_MASK
Date: Wed, 20 May 2026 18:05:15 +0200
Message-ID: <20260520162149.834973286@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 6517f293b2c6774d21b6e7e26a55fae60c6ec4cf ]

VDSO32_NOTE_MASK is not used or provided anymore, remove it.

Fixes: a13f2ef168cb ("x86/xen: remove 32-bit Xen PV guest support")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260330-vdso-x86-vdso32_note_mask-v1-1-2f5c473327bf@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/vdso.h | 1 -
 arch/x86/tools/vdso2c.c     | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index e8afbe9faa5b9..f2d49212ae902 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -18,7 +18,6 @@ struct vdso_image {
 	unsigned long extable_base, extable_len;
 	const void *extable;
 
-	long sym_VDSO32_NOTE_MASK;
 	long sym___kernel_sigreturn;
 	long sym___kernel_rt_sigreturn;
 	long sym___kernel_vsyscall;
diff --git a/arch/x86/tools/vdso2c.c b/arch/x86/tools/vdso2c.c
index f84e8f8fa5fe6..b8a555763f437 100644
--- a/arch/x86/tools/vdso2c.c
+++ b/arch/x86/tools/vdso2c.c
@@ -75,7 +75,6 @@ struct vdso_sym {
 };
 
 struct vdso_sym required_syms[] = {
-	{"VDSO32_NOTE_MASK", true},
 	{"__kernel_vsyscall", true},
 	{"__kernel_sigreturn", true},
 	{"__kernel_rt_sigreturn", true},
-- 
2.53.0



