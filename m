Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620096;
	b=32b9mc8zN6+f8sxGKfSI2pOW0MKwjTqV/Pgsc4/MjJmWwaPb2OMou/xSZmNkN7vrZnV1
	 o2cKl3SqqTum/GkDGwpyMxphW5gd9RMkOZnFWEBmUhBl9xkrCziSHolJ/47VN/kHiGpvY
	 UW7f1k0AQd04PVAEbDbOxTtaN1hWH7AS9GhH2UpRFX6NDRr1zFc80K1mGeuI5c7S0gLN/
	 NearKMDcGzOqQ4QtjN/kzDP6H4JzHf8H9nFCKEAU66gJLEGKqIJGc5LU8AlB2vpqaGaop
	 k4Uv/8VIJZpMT386RDtQTviU9o2lr6oPhoC3YEjFst57eTmGxzG1rV/o3RpKiFeONBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S5zCKAqg0BAh7QieNC3YOPDOwEs8r9DjY3+5K8azR0c=;
	b=IZNgvzmS5WW1dowbh8vwgw4pb4KUA9R0mWJL3YOT58HOUkfWWhecBZUIx8rtTB5CxS6y
	 qUmwSqKHej0ubL09C/4D+i9Ic2baJw5Ir9Yuk9l02oS+pwtYCEz1vgOnjZmxJRashezXY
	 pc0YZla2ywWqileT1NWiC7fKyc+FtS7PYOuk9vV86np+Pn7ilKwvAS/3lzJQlYsF3NZWz
	 5W9MfVHtUKgVOytlnfCAbhK2+bVvSwOW0QL1nUmFXbRMnVjD6U9Qfp5XVzeHfIrTJ8PWc
	 JXYpFiEtDwG4YZcw8Ad49Tis6u4ocLj/tnumQsavJz5R2Bq9ALjGF51ysBJ3aayvxmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2aU3PJ/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05809606A323;
	Wed, 25 Nov 2026 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2aU3PJ/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6C11F000CA;
	Wed, 25 Nov 2026 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620095;
	bh=S5zCKAqg0BAh7QieNC3YOPDOwEs8r9DjY3+5K8azR0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aU3PJ/8Ipes7zuRoQ6mOjVIdkKEpWohJoAL+cmMKTRxWKa/z+ww04RzVnTuL8UAx
	 mqa3RgGG1Elsai/xXExbShBp73R3GV8so3hGEeKqAU1sflFdQlJnERD1cbBJEDNlBq
	 glD6HF0p3TmlPFJJ/6/o6cl/a+g4wYxZibKni6Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0790/1005] tracing/probes: Reject array count on non-dereference string sources
Date: Wed, 25 Nov 2026 15:35:28 +0100
Message-ID: <20261125143840.245298372@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 0941144ebeaf3ce46c80711f00e935921eb28b21 upstream.

The runtime array loop (FETCH_OP_LP_ARRAY) for string types requires a
preceding memory dereference instruction so it can advance the pointer
address on each iteration. Non-dereference string sources such as $comm,
immediate strings, and eprobe event fields cannot be indexed as pointer
arrays, but finalize_fetch_insn() still accepts an array count on them
and emits an invalid FETCH_OP_LP_ARRAY sequence.

Reject string array counts when the preceding operation is not a memory
dereference.

Link: https://lore.kernel.org/all/179455855309.403392.4197028577158545202.stgit@devnote2/

Fixes: 40b53b771806 ("tracing: probeevent: Add array type support")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1990,6 +1990,12 @@ static int finalize_fetch_insn(struct fe
 			 * For the symstr, it doesn't need to dereference, thus
 			 * it just get the value.
 			 */
+			if (parg->count && (code->op != FETCH_OP_DEREF &&
+					    code->op != FETCH_OP_UDEREF)) {
+				trace_probe_log_err(ctx->offset + type_offset,
+						    BAD_STRING);
+				return -EINVAL;
+			}
 			code++;
 			if (code->op != FETCH_OP_NOP) {
 				trace_probe_log_err(ctx->offset, TOO_MANY_OPS);


