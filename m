Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591349;
	b=zDJjx9KgNLot7mSgSOxbvCBpInN1pSVOTISMB9TD+HtqieTqu25bnoDvniYiJtxJfQhb
	 +fwN1ocNPkKrP7zJrlsTCUyQRZQbBM0NTrervTF5VOMtWnwScizOijsjn24KfUdzh88yD
	 vCoPq9bovDc9dRYVKY6QYROQsyn3pl8OIGMZNPZxEYTUSbr2Cpjic/i9EwkkvRppRlCr+
	 1EpCEF3YCaW4/9DyV66NilNuiEYKuNQ+F3IznFcCdCbS85p/H6meZbpECWrvBXKj6qdyb
	 8qIWRERDtIlTWVIm4nDSw7le2G/Uq0iSE4Q6JxA1ruCov52IwJYMeQ1sB0BhchGbTWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1yiPM5BhlXWLijPZsQOLlZMsRuNGF9xVErvkH8V3PtY=;
	b=Qos9X4MAKI0Wvh0EMajpnJDQ5BN5xu60vgam1giANzWogRi6sCg8oxEIZO/6eqhgyNQ+
	 MEDDFsvjfem/v7OLNcAGM98auOI275OnfhOh7E8vavoy3k0cDVPff9xVXQrJIXHKEiQ2S
	 bmd+BXMZXzHUe+YKteAD+fnXf4CV8aY2Uf8fjuRPg0aA9bPDZVa+0ZjtsL5uElZOYbclc
	 NNn9r3sJAvnGrDyWwkm5iLqtUAagDE4cTyOJvxYePNTcDbs8Qap2HX4fdEcMUCCUQXdFI
	 E+PyN3H6jrowF54hnHD4v8YLZ69g4Dj8Nfg0IiFY0mRrMZXWHid2MBJ4LYIop8TqVuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dB4614ow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B87606CEFA;
	Fri, 13 Nov 2026 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dB4614ow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C4E1F000C4;
	Fri, 13 Nov 2026 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591348;
	bh=1yiPM5BhlXWLijPZsQOLlZMsRuNGF9xVErvkH8V3PtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dB4614ownKgcLPxUTKmPIvuSn3Nun2gg4Ko028TkkwdN+SoGdiWq7cCPGN40HwYaU
	 NR0Cf2pxzEAATaLWfNLpeKbgMhlmwo4lrRR9rbPAcSfVK9x6mDqqJFHbPujgWhJ2sr
	 POWrQ3d5PnPRznALpRkJwvCR0emOCqqy+8tQouok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Plattner <christoph.plattner@gmx.at>,
	Daniel Palmer <daniel@0x0f.com>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 455/670] m68k: Fix task info flags handling for 68000
Date: Fri, 13 Nov 2026 10:50:19 -0500
Message-ID: <20261113153827.322485216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 72e95663b62ff..c257cc415c478 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -18,6 +18,13 @@
 
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
@@ -70,9 +77,8 @@ ENTRY(system_call)
 
 	movel	%sp@(PT_OFF_ORIG_D0),%d0
 
-	movel	%sp,%d1			/* get thread_info pointer */
-	andl	#-THREAD_SIZE,%d1
-	movel	%d1,%a2
+	/* Doing a trace ? */
+	getthreadinfo
 	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TINFO_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
 	jne	do_trace
 	cmpl	#NR_syscalls,%d0
@@ -96,16 +102,15 @@ Luser_return:
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



