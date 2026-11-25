Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623282;
	b=rG4neT8HPvDIXveBwortBhftoYk9DFiO27WJv6187yT6eXGv8Duqn2Rv7jL07rfZS8fv
	 SNM5woK0/E5htd15NI2oaHLkZm3f4SEXabpsyjoS9xrsjJHiIoEcCByPxdbqwtPrvbg6p
	 kj8yPdXpoiesB5iPGiVZZyPyLfHQsqoTWsy+b1sot9IgTvDPp0g9Sbh6GMUBgMHYGgvAq
	 oqNoKoZkGZhm/eyYX45fUFVkIa1UivZYmY5WxJjU3ToZ8PPJawhrqFvxIVq5eL+sW9Ywv
	 EYwT+DiwnxtsUyPCU4X79aGLnEJj46IGaqhQkxzB3KfzgYVlCpBsY8G6OIpK5nY72Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KHCVXBXbghOYOp5voKWChXzqb5FhY66C7fZbb8K9sFo=;
	b=Om0V+Yh0x04EKFx7EHhVyLWmWOVSLklCcZLHq4oMvqH7S+cJCvun2NUvTsJlqFgLfPrb
	 Pk15cDkOM8aaYR9/kPrYYrymsw7EX5gH4ehznJ2jeRuYubF3l7r9v9bqQWuOcIBZFMZYx
	 irElFTOExRmOyMHTOho3+zI+w3HDQ4EIHfGTS7dlwI2B6uXGPNTJTe/nQT+GPCeHWZzM0
	 r0QIf9D9+FYqSbwKGki33uYyDsUYWk5MqUtBMACd1rAT4+ZBTD6GLeSFvpq1zkJp5+vMp
	 8fi8VN4QNkuN7NeXdt0BYNwyRCTJJCrdBbCbDcduGshm+3VsZw9dUSe9ZTBhywhi29w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WruCo9Mw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF28606A31E;
	Wed, 25 Nov 2026 16:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WruCo9Mw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5021F000C4;
	Wed, 25 Nov 2026 16:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623281;
	bh=KHCVXBXbghOYOp5voKWChXzqb5FhY66C7fZbb8K9sFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WruCo9MwghDrcyr13xTBeoIlKejfyWAcL+Yw6q2S7DqjLNmcUMZtL9UyK6mUMtgAk
	 Wa4LYcG5cDSn3NOIt/SqYpn9wWglrq5PSS5jW5C2rQFUdpohB4RyMdTNkcG6ueGbX7
	 sM9CDjuzWl7+Uh9zywnXQUlsL/Naa8IUGyZT9npY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 808/990] tracing/probes: Reject array count on non-dereference string sources
Date: Wed, 25 Nov 2026 15:36:15 +0100
Message-ID: <20261125143840.971771383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -1518,6 +1518,12 @@ static int finalize_fetch_insn(struct fe
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


