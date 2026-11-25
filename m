Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620027;
	b=jaly1UcXHm8nZNFPt/2/clIBYgqWSfjQnItyaCzPRu/unlEIPae4DbbNTS2c2PpTo5pJ
	 7IsSsjaMcqpyzRUVRzaoWKq0pNv6GuqEkeUtvq9Ws3fHGKnYqKhAGmN1ZqMzdcCQeeMO5
	 B15HfsQNHNyNVMjTgsAeeYqRhd9Dq4qfYKQwjaMFCEYOdq4+TaUKDFiwB/MzPVeMyikvG
	 CEP+Fh0+VcTwnBDa5vUk2F9Vq/v3j3lHi1AvlYLaKSEmZ8XXmNUjjUkPmZUQMqpsbzM6t
	 PoyBz69J4uknYE0QIy2RLVRCOPr7CGiY39SjlyPiMwftlel0htPvEm1gP+nVP2maXNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jpSQdfWANoTRqtyDe6afjUaF4+gjHo7fBB82oN0soKg=;
	b=vFkxD7i/w3Gwkh/OGcuEk4ckr5Yv0ofc/eoRp5t8kf4n1bNSvFw18lYz5PSQ1KuoO08Z
	 8uO0RXkh1Onga4G9hVmlzUq9PfadZcMO55c4CPXqj7nYaejQ+QuW8RszRIvGGhu2iaUlP
	 2Auviv0nlaKqxZoR+iOz9T7KQ0Jm2I4cJkUwiFHvARC5/vJT9gWJngMfLdPQspSxATNu3
	 aVYqoD12NZPjJpf1wYcdw3fyWoDmB+tD5FNgH1975lp1PU0TLA788uADY2VpqOHmtxlNe
	 MQ5WPDJa91Kifjuq4Z/TvW2e3lh5oyZrEOAKi3CyNfNUbilJanklKr6MnvRNCNXuPZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwU8TSaR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D48606A31E;
	Wed, 25 Nov 2026 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwU8TSaR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CCE1F000C6;
	Wed, 25 Nov 2026 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620027;
	bh=jpSQdfWANoTRqtyDe6afjUaF4+gjHo7fBB82oN0soKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwU8TSaRQXgXvkJ5zGLBkMmj4IdQ0OHEd66pDQ6/JAnaxvLwuT828xYA9eGgk/PEX
	 eOtZ20ISjmtvIcjmLZNsxjvYBSvr6DSJtmuyG+9B2Qs6GKx4T4q+cjP3p5jSAfJD0M
	 RDZU74QhvOpIGRP+zmKBMunN6L8RYXaIkfei3TfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0783/1005] tracing/eprobe: Fix 1-byte signed field fetch in get_event_field()
Date: Wed, 25 Nov 2026 15:35:21 +0100
Message-ID: <20261125143840.084042182@linuxfoundation.org>
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

commit a0f836eea463d4c468edb58eedb03911c9c0791d upstream.

Because the kernel is built with -funsigned-char, plain 'char' is
unsigned on all architectures. Reading 1-byte signed trace event fields
via *(char *)addr in get_event_field() therefore zero-extends instead of
sign-extending negative s8 values.

Use explicit fixed-width integer types (s8/u8, s16/u16, s32/u32) when
reading event fields.

Link: https://lore.kernel.org/all/179455852542.403392.15666310371702309464.stgit@devnote2/

Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -330,21 +330,21 @@ get_event_field(struct fetch_insn *code,
 	switch (field->size) {
 	case 1:
 		if (field->is_signed)
-			val = *(char *)addr;
+			val = *(s8 *)addr;
 		else
-			val = *(unsigned char *)addr;
+			val = *(u8 *)addr;
 		break;
 	case 2:
 		if (field->is_signed)
-			val = *(short *)addr;
+			val = *(s16 *)addr;
 		else
-			val = *(unsigned short *)addr;
+			val = *(u16 *)addr;
 		break;
 	case 4:
 		if (field->is_signed)
-			val = *(int *)addr;
+			val = *(s32 *)addr;
 		else
-			val = *(unsigned int *)addr;
+			val = *(u32 *)addr;
 		break;
 	default:
 		if (field->size == sizeof(long)) {


