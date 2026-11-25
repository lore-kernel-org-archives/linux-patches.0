Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618121;
	b=jxZ8llDVkbeaavfmpCAo4XR/xVJAWF733h5wUvu/jLUV4kwf9Q0diCf0+xDoQHJ70Fcd
	 HQdGg0fGG3YlV6Yj7wSYniho5jfXdpXYhcYnErgPib4Eb4U8hOMS425YCsLIsnQySCeLW
	 orLzzmYG5+K1hqasVUuKCMpxtHeter3A5Z+VtXHnm2u3ll+m/Z85tLY/1arQ5VcToB5/7
	 ULhqHHbWu3qup8/ycdJYL72XdXUVFO47YE2reLo8YUr6AMBmChLCpER2JCole/8i9pDv4
	 y/Xu4r3VeOkUEne/spZZYjlokDkkItIvngQWae7nb9o5q1beWyCft9XfVuHoDZjax7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I3anqIaBA7vmEO1fKZzQ0TM7nSHTaEG3QHpfW9/PQ/o=;
	b=v5E3AV7/vtrhjvJrfb6HhwwFmdneK/jFtrwkLHEXNLfGuPUYzFGQX8Z8e1cciI5gdtU7
	 necoatOCHGecVFgGz4Cuec/WPWuCjei003/dTuCMoJVNNN3K7YpxePMn873OHzCrxYfNO
	 rL4euoSxDbK5f8N4/BemF0kxUkNFs/4PokRF2kODs3tTEzna3bGoH6WCsNBydlrLfhQS7
	 5oVRuJNlgOSejeO6alAiFZl5X59IQKJkH4/KCTJgoVpRI370vXAvKm3/FEJoy47FseBJj
	 hgvhPGeDBasBPeE9q8XGsr9o1/YrG5qd26snsNlHqzOK11j5xGzBfOSengxxAvF/XRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mY/9u22H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26FD606A31E;
	Wed, 25 Nov 2026 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mY/9u22H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1EB1F000C4;
	Wed, 25 Nov 2026 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618121;
	bh=I3anqIaBA7vmEO1fKZzQ0TM7nSHTaEG3QHpfW9/PQ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mY/9u22HdSfwqwxw/ZmTnheGNLs/Tg0bYCR2MnANPmZA3tiajhABsRYeyjrLfxOqs
	 WJOM3EkizWQTWiymKJNLO8QBayOUbu091wQNzergUn6ymc34DFRaSxd0femfn1Upe6
	 NJ1i8HzhAz19sWJcBqioh4NQhMf6UMD+HNPNUuIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0180/1005] bpf: Fix the join of fp+0 with a value that is not a pointer to stack
Date: Wed, 25 Nov 2026 15:25:18 +0100
Message-ID: <20261125143825.960003384@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 6185d4fc6e64439cad415d9bf527f8ffb3fa3db4 ]

arg_track follows pointers to the stack through registers and spills.
Scalar evolution and the removal of dead slots rely on it to know which
slots an insn reads and writes.

Where two paths meet, a register can be fp-N on one path and not a pointer
to the stack on the other path. There is no value for that. The join adds
a fake second offset, fp+0: with two offsets no store through the register
is a certain write. But for fp+0 the fake offset is the offset itself:

  join(fp-8, none) = {fp-8, fp+0}    two offsets
  join(fp+0, none) = {fp+0}          one offset: "exactly fp+0"

Then a store counts as a certain write to the stack, but at run time it can
go to other memory:

  r7 = r10, or r7 = map_value + 8 ; arg_track: exactly fp+0
  *(u64 *)(r10 - 8) = fp-24
  *(u64 *)(r7 - 8) = map_value    ; arg_track: fp-8 is overwritten
  r8 = *(u64 *)(r10 - 8)          ; fp-24 or map_value. arg_track: none
  loop:
    r1 = *(u64 *)(r10 - 24)       ; the counter of the loop
    ...
    *(u64 *)(r8 + 0) = 4096       ; arg_track: not a write to fp-24

Scalar evolution does not see the last store. It gives the counter the
range of a loop that only increments it. The prog loads, and it accesses
a map value out of bounds.

Valid progs are rejected as well. The store through r7 makes fp-8 dead, and
a later read of fp-8 fails with "slot poisoned by dead code elimination".

When the single offset is 0, drop the offsets. The result is a pointer to
an unknown slot of the frame, and all updates through it are weak.

Veristat sees no difference in selftests, Cilium and sched_ext.

Fixes: bf0c571f7feb ("bpf: introduce forward arg-tracking dataflow analysis")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261102055913.3598414-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/liveness.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/liveness.c b/kernel/bpf/liveness.c
index acee6f86f8474..e1340e73cbeda 100644
--- a/kernel/bpf/liveness.c
+++ b/kernel/bpf/liveness.c
@@ -872,6 +872,19 @@ static struct arg_track arg_join_imprecise(struct arg_track a, struct arg_track
 	return (struct arg_track){ .mask = m, .frame = ARG_IMPRECISE };
 }
 
+/*
+ * 'a' or a value that is not a pointer to stack. A single fp-N gets a fake fp+0,
+ * to keep stack_use and prevent stack_def. fp+0 itself would stay a single offset.
+ */
+static struct arg_track arg_or_none(struct arg_track a)
+{
+	if (a.off_cnt != 1)
+		return a;
+	if (!a.off[0])
+		return (struct arg_track){ .frame = a.frame };
+	return arg_merge_offsets(a, arg_single(a.frame, 0));
+}
+
 /* Join two arg_track values at merge points */
 static struct arg_track __arg_track_join(struct arg_track a, struct arg_track b)
 {
@@ -896,20 +909,10 @@ static struct arg_track __arg_track_join(struct arg_track a, struct arg_track b)
 	 */
 	if (a.frame == ARG_NONE && b.frame == ARG_NONE)
 		return a;
-	if (a.frame >= 0 && b.frame == ARG_NONE) {
-		/*
-		 * When joining single fp-N add fake fp+0 to
-		 * keep stack_use and prevent stack_def
-		 */
-		if (a.off_cnt == 1)
-			return arg_merge_offsets(a, arg_single(a.frame, 0));
-		return a;
-	}
-	if (b.frame >= 0 && a.frame == ARG_NONE) {
-		if (b.off_cnt == 1)
-			return arg_merge_offsets(b, arg_single(b.frame, 0));
-		return b;
-	}
+	if (a.frame >= 0 && b.frame == ARG_NONE)
+		return arg_or_none(a);
+	if (b.frame >= 0 && a.frame == ARG_NONE)
+		return arg_or_none(b);
 
 	return arg_join_imprecise(a, b);
 }
-- 
2.53.0



