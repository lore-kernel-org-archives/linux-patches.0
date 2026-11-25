Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619500;
	b=jVQcflxNEQ4SENkFdZiOMA9dik5BaRMzFEWFuWpsjqHz8VKA+N5CXZY6N80/V2TeW2SP
	 nptysDdA0NTFsR2QTzO2dOAgZJNHmFdHGhE5lYZ8O8ssxWXOOKN/ZfRKzfc68z63mOwtR
	 cPZOuUte3cBq+jvNzcCKvE+tNalUcdT314o/nLyITFx6tNgKBu80z+/nWoGXlWDhpbkOG
	 xGffshQAs/vsfZq8ju74ii9ANwTQIRHYjBmX8sVzDzbl7ugTgIf+sLuw9qnqR97ByWaPg
	 fMpTT52hkRjwhO0LyC/Hqcmx6+YP4LF8vtG9bzRYttyC8NyVCSzXnPTtG6cQOHuupIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EyfCy7TujlBWVPoca6vTzv18bFe9Wdl2g08NUB+ltbQ=;
	b=jX6O9u8zWG/tozF8RP5lTFvPJMvAJkRUy1ESooBgXXK41YnrIrF0FXDDgBBPUoKEb48N
	 +3l9XX1KdBpvhhPlCmm1+cFFSBV59Fmb2YOY8jPq4oMtDQGKcny3zk3MoGsp4DWvID5Z0
	 rKPHI0qhaFNMoNj/ZHohgkfaPs1k0uIkbAqb02NWgriYdgHl65gvGM1tFHE5wF/LqS4jW
	 /xtH8g9/jefQfYbhJBbt5RjxtJeExUnQTSmX7l0gt+36Ey/2E+9qpCtG4lMGMsQ0dUTMZ
	 SfczmodWGkXRrF8TmCjR1cjeCoTIMRR2iUEafYUFaPNTMLBl57pjla1Av+0a0FOo49w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1C4Ftu3i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739DB606A323;
	Wed, 25 Nov 2026 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1C4Ftu3i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48A01F000CA;
	Wed, 25 Nov 2026 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619500;
	bh=EyfCy7TujlBWVPoca6vTzv18bFe9Wdl2g08NUB+ltbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1C4Ftu3iAi/mS1gP1eaWVgYv5UD7Y7eVjhZOBeoNTlncgrvgiHCVzF7XgIwKMGq5S
	 /B0gZl1AslQd3eh6qtNX8jlLAJJ18/xCt+A8/4GYyBQQZ8HWkIdU5o9Cfgb6mfVdrU
	 Ntg4sBZ96JjRKJODKDdzAgY6x6j8WKw41MwHPeEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Bezdeka <florian.bezdeka@siemens.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.3 0616/1005] entry: Fix return type of syscall_trace_enter()
Date: Wed, 25 Nov 2026 15:32:34 +0100
Message-ID: <20261125143836.176972738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Bezdeka <florian.bezdeka@siemens.com>

commit 75b1663222d7aa0b3c33cc3522a347757e6d1d26 upstream.

All return values of syscall_trace_enter() were migrated to bool in
commit 71ff30013f19 ("entry: Make return type of syscall_trace_enter() bool"),
but the function declaration has not been updated.

Fix that up now.

Fixes: 71ff30013f19 ("entry: Make return type of syscall_trace_enter() bool")
Signed-off-by: Florian Bezdeka <florian.bezdeka@siemens.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261030-wip-flo-fixup-entry-code-v1-1-7724c29e800b@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/entry-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index fa2854fed1f2..a8b2430eadc5 100644
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -62,7 +62,7 @@ void trace_syscall_enter(struct pt_regs *regs);
 void trace_syscall_exit(struct pt_regs *regs, long ret);
 void syscall_enter_audit(struct pt_regs *regs);
 
-static __always_inline long syscall_trace_enter(struct pt_regs *regs, unsigned long work,
+static __always_inline bool syscall_trace_enter(struct pt_regs *regs, unsigned long work,
 						long syscall)
 {
 	/*
-- 
2.56.1



