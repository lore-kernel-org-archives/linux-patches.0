Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212490;
	b=zSwpkAANavJg1/sszpA0UfaNfau7TGRf/mfZUUoW9q6C4pgoo/LAG8KqVjHGkxyIMP3M
	 u2c8yARLFG/TFYuzZFwkesvIk5LN8S3sINqzRwJNpLRk7RK4K+5vYfio/znui49fMvEEp
	 H7jPLcuRo0kYMD2ShN6fpeSnRuEAlAwJdtPKYXxI5/ZZaS2Mid9AwLFdWy5jERTjgqqqe
	 BEYMT52ubcQNC0S3VhU3ctRoMlPJbEOnTk68tzFN9qx45OnPcTHkALwKOMrnQdCRRV4KW
	 +2U2UFnMtD/Unkw5Wgzjeca8hd0u0/LelKFCl0T4hwTi2mG5iVju0FemcGguEeZL45g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=irwU2FV+8hI3eCGdMp2bdbtHmS+wt9h9yjXHjwgNaDA=;
	b=e1peR34cfHngmh/mmmZ9RzQe1oFpJ/KFm5CdbM3B5IiwToOCcx1HGqgNMHSkH4cPBLtm
	 KxGl9Q3O+sf6lQz5kgxQCiL6voMGkMRQ9Mkdxh/eSsXFgBhAbudKyJ1m+tYAYDjGxbbu/
	 VgYJvzbPbix8qcsrEmEM8jTpclTf1D9hqkOcAxQqqa0xDLmDoVh0Cbb4ys41dAjj/lM2s
	 BAP2q4SeuCY0vxZRYRYMOhSvd1eb0JY9Pmr/r4NlU0xntbAIJODSj1umg5sFugI19kH6r
	 CppJcLwQJQTyW65fdLnX7dqO2Kt17JEDuEhrg4MynNN8RgtU7gd6u0gAleqcOO/f4HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srXxCzC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113AD606A323;
	Wed, 28 Oct 2026 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srXxCzC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CFD1F01825;
	Wed, 28 Oct 2026 18:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212489;
	bh=irwU2FV+8hI3eCGdMp2bdbtHmS+wt9h9yjXHjwgNaDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srXxCzC2VDDHIrK4UBWtUNernToNBjEF1QyfEprigv2vhJUgXIw0vo9t8RfrWtobI
	 Odh+K4ug9lrBKQBO4rCbxV4egh+256iQc19dlSpZbvT74FjjxxJjmMCJuXS/E9zBy5
	 EhOCKU9hwvl6ZIk9YJxCd8shV6OpE3MYOsL8uI/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 0173/1887] kprobes: Skip disarmed probes when checking optkprobe overlap
Date: Wed, 28 Oct 2026 17:37:49 +0100
Message-ID: <20261028170503.175511582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

commit 7a39c732a22ec4a369af9e19fbe3d666ec83eec4 upstream.

On x86, an optkprobe at A replaces five bytes with a jump. If a disabled
probe B is at A+2, get_optimized_kprobe() stops at B when arming a new
probe C at A+4. It leaves A optimized:

              A    A+1  A+2  A+3  A+4
  A's jump  | e9 | d0 | d1 | d2 | d3 |
  after C   | e9 | d0 | d1 | d2 | cc |

The INT3 for C overwrites the last byte of A's jump displacement, so
execution can jump to the wrong address. B can have prepared optinsns
while disarmed, but has no jump to unoptimize.

Continue past disarmed and unprepared probes to find the active optimized
probe before arming a probe in its jump.

Link: https://lore.kernel.org/all/20260930053618.104498-1-leon.hwang@linux.dev/

Fixes: afd66255b9a4 ("kprobes: Introduce kprobes jump optimization")
Cc: stable@vger.kernel.org
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -491,14 +491,16 @@ static bool kprobe_queued(struct kprobe
 static struct kprobe *get_optimized_kprobe(kprobe_opcode_t *addr)
 {
 	int i;
-	struct kprobe *p = NULL;
+	struct kprobe *p;
 	struct optimized_kprobe *op;
 
 	/* Don't check i == 0, since that is a breakpoint case. */
-	for (i = 1; !p && i < MAX_OPTIMIZED_LENGTH / sizeof(kprobe_opcode_t); i++)
+	for (i = 1; i < MAX_OPTIMIZED_LENGTH / sizeof(kprobe_opcode_t); i++) {
 		p = get_kprobe(addr - i);
+		/* A disabled probe can have prepared, but inactive, optinsns. */
+		if (!p || !kprobe_optready(p) || kprobe_disarmed(p))
+			continue;
 
-	if (p && kprobe_optready(p)) {
 		op = container_of(p, struct optimized_kprobe, kp);
 		if (arch_within_optimized_kprobe(op, addr))
 			return p;


