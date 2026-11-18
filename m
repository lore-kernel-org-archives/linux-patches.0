Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038110;
	b=q869XYM+/Vzomm1ZFf1SLGOD+CiQmFjs3o2/i8pCeFlQUddztjYfzDr/L2+thEbtEG0A
	 Qqu1zWgY2ZlyqiN7Jw0yyOY5jUM9axKU1+DUeKO+J9yPWWdB1XRBYKuOy9GjH2TaynNix
	 dW5LoduSEhj86FwFZcjDHO52DmqQbFirHWpiXmaTj7dE/RaPW5M2oitsYqDRYdlkkfMXW
	 iUbgGSv7oXvhVXsgSFqoEN2c1LnRi6MZKQCeVwbXzIupwIbc5OWyx+Bw6ELREuZbj1Kcl
	 FZbhRF3NR0026UqJWpKAvRFPkVNGnK5tDTkeBHOACijyCI71lj8DjHVPLr5PkAL9DwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gvX8Hp8v9aaIDcP0sX1+/8z0pthvKGbUb7f2nlyxf6Q=;
	b=s7NE4vC3Tl3luWUx2R1DhxhujxLbwnLWysItVbcVDaR/WUEIEwECl2csq215eChDO69i
	 lKoUjtzb2znRVxhJkEyyB7j+hqP8U/7z+omorN8KFdGyRgJKtOko+qg71NIwi3/DzqpES
	 1NoBM609+yKlyR767XawqzX2GFqJK/i6N2HvJCVbtcXVdJ16VlJbD3QyPZ/f36qq+XSWM
	 ACSW2MBdvixFmvEIU/t13lLHthBzMWwPRVTQccBxI43OL872n5dd0jznOwevA0AOD3kUc
	 td+mDVYORuzTisoO43ix6E4pOiBQv8RliWmBtbW0kCCD2apXpBVeIq4wuydEi/sdUvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AiBb8MLl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13719606A31C;
	Wed, 18 Nov 2026 21:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AiBb8MLl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCD71F000C4;
	Wed, 18 Nov 2026 21:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038109;
	bh=gvX8Hp8v9aaIDcP0sX1+/8z0pthvKGbUb7f2nlyxf6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AiBb8MLlUcn/hQ9Qhq34ENXbBotLYJIHlRMtmVBsc4Bwx9qKe/FkNz1VRYr+B2scy
	 GiJLC4WI1UwGjtADfkAbQTyXxgCx3EOhmfxsgzdRT/YNU8dLnwAIIkPLF17VCrVKvD
	 qarZSOSME8NE+mmiIpBJyXuwX6obZCIQWTBhsLHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Plattner <christoph.plattner@gmx.at>,
	Daniel Palmer <daniel@0x0f.com>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1629/3318] m68k: Fix task info flags handling for 68000
Date: Wed, 18 Nov 2026 15:37:31 +0100
Message-ID: <20261118150410.612742862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 2c6805145e1605cef39459f78979f7edee251b41 ]

The logic for deciding what to do after a syscall should be checking
if any of the lower byte bits are set and then checking if the reschedule
bit is set.

Currently we are loading the top word, checking if any bits are set
(which never seems to be true) and thus jumping over loading the
whole long and checking if the reschedule bit is set.

We get the thread info in two places so split that logic out in
a macro and then fix the code so that it loads the byte of the flags
we need to check, checks if anything is set and then checks if
the reschedule bit in particular is set.

Reported-by: Christoph Plattner <christoph.plattner@gmx.at>
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Stable-dep-of: 48859f8018d9 ("m68k: Fix seccomp filtering on ColdFire and 68000")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/68000/entry.S | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/68000/entry.S b/arch/m68k/68000/entry.S
index 7d63e2f1555a0..37926b4b205af 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -21,6 +21,13 @@
 
 .text
 
+/* get thread_info pointer into a2 */
+ .macro getthreadinfo
+	movel	%sp,%d1
+	andl	#-THREAD_SIZE,%d1
+	movel	%d1,%a2
+ .endm
+
 .globl system_call
 .globl resume
 .globl ret_from_exception
@@ -73,9 +80,8 @@ ENTRY(system_call)
 
 	movel	%sp@(PT_OFF_ORIG_D0),%d0
 
-	movel	%sp,%d1			/* get thread_info pointer */
-	andl	#-THREAD_SIZE,%d1
-	movel	%d1,%a2
+	/* Doing a trace ? */
+	getthreadinfo
 	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TINFO_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
 	jne	do_trace
 	cmpl	#NR_syscalls,%d0
@@ -99,16 +105,15 @@ Luser_return:
 	/* heavy interrupt load*/
 	andw	#ALLOWINT,%sr
 
-	movel	%sp,%d1			/* get thread_info pointer */
-	andl	#-THREAD_SIZE,%d1
-	movel	%d1,%a2
+	getthreadinfo
 1:
-	move	%a2@(TINFO_FLAGS),%d1	/* thread_info->flags */
+	/* check if any of the flags are set */
+	moveb	%a2@(TINFO_FLAGS + 3),%d1	/* thread_info->flags (low 8 bits) */
 	jne	Lwork_to_do
 	RESTORE_ALL
 
 Lwork_to_do:
-	movel	%a2@(TINFO_FLAGS),%d1	/* thread_info->flags */
+	/* check if reschedule needs to be called */
 	btst	#TIF_NEED_RESCHED,%d1
 	jne	reschedule
 
-- 
2.53.0



