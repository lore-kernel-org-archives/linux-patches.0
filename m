Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C2326B09E;
	Thu, 13 Feb 2025 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459662; cv=none; b=etuZG7FLabHcy4XbFg/2cfvuQTPUE55/xcxlOYA1HTARvRz3Ovj9EXRCaQ90/AunTEAx0pCVRdA5HIIWn2Vwkrm75x5JfcW61x6gyz/LmT+ywmwvdGn8GR8zSFxV3wXUN7SMt2NIa+BzIEoTRKYeKDC6v2Hce4UejRBs6wFPUQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459662; c=relaxed/simple;
	bh=A1vCJsOIJd3EJS2aoLX3LMYAz0vv03RPUB/7QgsimOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Usfqz77ac2lUFd5ekeVVTDhAmqAnfRUcznTn5KFa3B5xdrejBdsCUX482l2IkVglHPkcR6Fw6prN4J8nlra3x7VxdPMvnsQA7acrvuT4/FZ7omF0f5RSTVRjxwe6oE3tKtv+icYGxUPu7ksCPgz4rMs8sceKekIHB4Vid9rsO8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMbBfkhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMbBfkhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40553C4CED1;
	Thu, 13 Feb 2025 15:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459661;
	bh=A1vCJsOIJd3EJS2aoLX3LMYAz0vv03RPUB/7QgsimOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMbBfkhvlbOkxKzFcaSxZ3BaaChoyz76K0fDV1v62LN/3brJA2PuectdLIopgq+mY
	 hwbcW7ze/tawxx0pgervWBhZIpPsAdt4OLyvJVQNPPDWOq0iLIocQowJ8KiG2lPChY
	 2hqZQEhMUvKn5dbwumGc5PKY81Ff+tfplQKHSux8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.13 327/443] parisc: Temporarily disable jump label support
Date: Thu, 13 Feb 2025 15:28:12 +0100
Message-ID: <20250213142453.236237516@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@kernel.org>

commit 3599bae489d86fbabe039f9a2ab5472ffb04f7f1 upstream.

The 32-bit Debian kernel 6.12 fails to boot and crashes like this:

 init (pid 65): Protection id trap (code 7)
 CPU: 0 UID: 0 PID: 65 Comm: init Not tainted 6.12.9 #2
 Hardware name: 9000/778/B160L

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
 PSW: 00000000000001000000000000001111 Not tainted
 r00-03  0004000f 110d39d0 109a6558 12974400
 r04-07  12a810e0 12a810e0 00000000 12a81144
 r08-11  12a81174 00000007 00000000 00000002
 r12-15  f8c55c08 0000006c 00000001 f8c55c08
 r16-19  00000002 f8c58620 002da3a8 0000004e
 r20-23  00001a46 0000000f 10754f84 00000000
 r24-27  00000000 00000003 12ae6980 1127b9d0
 r28-31  00000000 00000000 12974440 109a6558
 sr00-03  00000000 00000000 00000000 00000010
 sr04-07  00000000 00000000 00000000 00000000

 IASQ: 00000000 00000000 IAOQ: 110d39d0 110d39d4
  IIR: baadf00d    ISR: 00000000  IOR: 110d39d0
  CPU:        0   CR30: 128740c0 CR31: 00000000
  ORIG_R28: 000003f3
  IAOQ[0]: 0x110d39d0
  IAOQ[1]: 0x110d39d4
  RP(r2): security_sk_free+0x70/0x1a4
 Backtrace:
  [<10d8c844>] __sk_destruct+0x2bc/0x378
  [<10d8e33c>] sk_destruct+0x68/0x8c
  [<10d8e3dc>] __sk_free+0x7c/0x148
  [<10d8e560>] sk_free+0xb8/0xf0
  [<10f6420c>] unix_release_sock+0x3ac/0x50c
  [<10f643b8>] unix_release+0x4c/0x7c
  [<10d832f8>] __sock_release+0x5c/0xf8
  [<10d833b4>] sock_close+0x20/0x44
  [<107ba52c>] __fput+0xf8/0x468
  [<107baa08>] __fput_sync+0xb4/0xd4
  [<107b471c>] sys_close+0x44/0x94
  [<10405334>] syscall_exit+0x0/0x10

Bisecting points to this commit which triggers the issue:
	commit  417c5643cd67a55f424b203b492082035d0236c3
	Author: KP Singh <kpsingh@kernel.org>
	Date:   Fri Aug 16 17:43:07 2024 +0200
	        lsm: replace indirect LSM hook calls with static calls

After more analysis it seems that we don't fully implement the static calls
and jump tables yet. Additionally the functions which mark kernel memory
read-only or read-write-executable needs to be further enhanced to be able to
fully support static calls.

Enabling CONFIG_SECURITY_YAMA=y was one possibility to trigger the issue,
although YAMA isn't the reason for the fault.

As a temporary solution disable JUMP_LABEL functionality to
avoid the crashes.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: <stable@vger.kernel.org> # v6.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -60,8 +60,8 @@ config PARISC
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HASH
-	select HAVE_ARCH_JUMP_LABEL
-	select HAVE_ARCH_JUMP_LABEL_RELATIVE
+	# select HAVE_ARCH_JUMP_LABEL
+	# select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KFENCE
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK


