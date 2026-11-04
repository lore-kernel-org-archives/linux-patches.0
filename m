Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831366;
	b=k8yw2jpl/RhbNxGehdWzAissQawMIRohK3oUc7yBCr5Fa4CCV9ClrbkM9fUTnLXIiZYM
	 qJy3pk6fRmS1zi6y2r+0ZLuBgGDDCak/leJPV85zFqCmPDL7BFByagy+fFo/Xd3sigA3T
	 YtyrG6i91YcRn/MuQoI4/OZWWM3gnYtJZptwOgPTL8ILhNUOzmD+JonfQ+sog9qKtWtzZ
	 csTk8/UW4GY1LmHXWkfIw+fMP6JVxeHoIPjMACJ+8jDTE0xrxL/GBh8oTpIod2Lm1L7dm
	 cffLeCkqRoZzfe+451psMiJx7tFaS6oJ42dmAtN/VRp0tjKYGHIACUfQuN2eHTQXWtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9oY8LKT5IBPnjzEwLg2dYpD/gVDamoDmyL9f0i40BC0=;
	b=f/tEStR/MwwYmWo0Fh4So1rJ4F2/U/qePrz8JwMrOj2KzCZyEptsn5i2dey/hvy5SQD0
	 sTGWYl2GBluALm45ZYE5FUQD1VbdSPt4zCp4o8klzv1Lh+wDcxsf+4vfTD3g3phsAS3f2
	 i5RHmOR37enLYQa9Y4tAkPxPQFfpwTyJWRsuLMipu6bx1gM1sLBK+0RINm2/PWxOPWDd1
	 M4m/1Ofm9XZKqxSxflrLQ5WqaRvNq4eekg0uNNWEjhn0wlIAivEnFp55d/bh+TSKeIaah
	 wVy62mNswpDeDBZ5FrXU6crDr88lxPXnnnZE4s5rW6SYUF5Sq/tKjyxFh6DnyJX3u6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wj03pNoj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47341606A332;
	Wed,  4 Nov 2026 22:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wj03pNoj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F031F000C1;
	Wed,  4 Nov 2026 22:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831366;
	bh=9oY8LKT5IBPnjzEwLg2dYpD/gVDamoDmyL9f0i40BC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wj03pNojltvNtdwHRPuJJ/vkqZwMcGXoqI6YXfxDBh2L82cLrw09MvVoE+xLARqgv
	 vKBl8Z5ZpWD57GguXYS+qNijELUgof6Bq/Ol2GqfLnEOvW5zM0rOhSNTc0zpMw/Hst
	 irvyg2sjjvHFuJTmM+KggBkUTFNiTQb5thlP2SSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0660/1005] x86/ioperm: Prevent NULL dereference on theoretical missing IO bitmap
Date: Wed,  4 Nov 2026 16:06:33 -0500
Message-ID: <20261104211102.173901032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 2d36d3b451a94899db9c965adde15492ffe6027a ]

Outside the IOPL emulation path, the IO bitmap is always expected
to be allocated when TIF_IO_BITMAP is set. The paranoid WARN_ON_ONCE()
handles the case where the flag and the pointer got out of sync.
In this theoretical scenario, which presumes some other bug in the
code that triggers the WARN_ON_ONCe(), return early, instead of
continuing and dereferencing a NULL pointer.

[ mingo: Clarified the changelog. ]

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Link: https://patch.msgid.link/20260615070115.4720-1-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4c718f8adc592..d5cd2177f18a5 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -486,6 +486,7 @@ void native_tss_update_io_bitmap(void)
 		if (WARN_ON_ONCE(!iobm)) {
 			clear_thread_flag(TIF_IO_BITMAP);
 			native_tss_invalidate_io_bitmap();
+			return;
 		}
 
 		/*
-- 
2.53.0



