Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E1B36D9EA;
	Wed, 20 May 2026 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298913; cv=none; b=VeSdP+rwD+tBn080SF+9tHNPagvUUUDlvzqDAZaNEp4q2Qy+eZXcBPp+yHoS2AAqgl96lXZpRWixOlZbB2BK6DaFL3hjqEK/OTu8UnSJz8zOZDIC2XNCreJB/gddkQdkdhkA5p2k90tXHQlLx/Ka2FbrQwK2Xt5zpJxg6KhJxas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298913; c=relaxed/simple;
	bh=nGBGS6DnxB8JlRvpRBow1oo9G+Jr+crP6azvUfMvK/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWeEeQoij2UaVIRuspnvAqgSgU5UxpZNqfTsY5sVd0tv+50IEPSmCom0ylHxNmuzX5gQz/bP+C1YJgMhg94REHy/ASFIx3h4uAgxH3HeD/5HFOD+Fms32qFizaWXAbYA9SRaAGoLQ2ZK7Od8gX7ziu4ax0jpSlRLT+/ofC2rcBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caIb+DjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caIb+DjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5636E1F000E9;
	Wed, 20 May 2026 17:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298911;
	bh=EqqNYKy4xJWIXMVrktIkhT45oR9cNDVIl2RFBBB8qrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=caIb+DjM5byWDcAUz39/5sUGc9ycBRsgUcGeQbcJTMpzn4xyw5r1xRM4JsuMnN6v2
	 77G3lEM7kpfAnl98lN5tGRS9jt5wmImEsCWho+deHiG4lH20Mxe5BTJXKx/SaAbCTu
	 g6ua1jGBjkm8c/WYZ/y5Nv2bYFAA9pMLZZhdchXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 574/957] x86/um/vdso: Drop VDSO64-y from Makefile
Date: Wed, 20 May 2026 18:17:37 +0200
Message-ID: <20260520162146.979143889@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 3c9b904f9033fb250db72d258bbdec791dc89405 ]

This symbol is unnecessary, remove it.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20251013-uml-vdso-cleanup-v1-4-a079c7adcc69@weissschuh.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: d1895c15fc7d ("x86/um: fix vDSO installation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/vdso/Makefile | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/um/vdso/Makefile b/arch/x86/um/vdso/Makefile
index 7478d11dacb71..8a7c8b37cb6eb 100644
--- a/arch/x86/um/vdso/Makefile
+++ b/arch/x86/um/vdso/Makefile
@@ -3,16 +3,13 @@
 # Building vDSO images for x86.
 #
 
-VDSO64-y		:= y
-
-vdso-install-$(VDSO64-y)	+= vdso.so
-
+vdso-install-y += vdso.so
 
 # files to link into the vdso
 vobjs-y := vdso-note.o um_vdso.o
 
 # files to link into kernel
-obj-$(VDSO64-y)			+= vdso.o vma.o
+obj-y += vdso.o vma.o
 
 vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
-- 
2.53.0



