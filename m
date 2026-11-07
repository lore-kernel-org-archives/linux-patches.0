Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061544;
	b=2uqDrgEDFWCSBoPeottP59NAsISJFbUAFTdAx+Kjca3lkfJDzpeOli03VkS76Gfkr3du
	 +4OZ/Yqv2ZcPkscECcr4zaQr+H2w7L2lB2o/7xzspvWR9NxRotgDxpXzcPLjU8gQeYj9j
	 C38PeNZX5fl5mqFDcEpoUj8ki8G89sJ6wXd4OifjExrxrKlLkHT2+JLrP1epeFA3EXqaH
	 Wq24gOgTIAZBowtp3ANDBKyoinPCyGwdlydZREm86wXwWnWItr7hGBkeG2v3nT56eJbXZ
	 W6T1M7Q2yn4zfyJW38Tr1xEOsWwLDBLGUxdZyra1A6eEDPipiEqhDrlFoeNjyG6ccgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MkhghfqilhVT/ckmRUQBhllwVdUXmL2prpoVCxMOAT8=;
	b=xKUaBYD7MN77grV+z80jvaYfl7al9mJi6Noq/Hgndexfq0/SGwJVpxHyubxcVAaIeTuX
	 h8Xk3NoRktC/PYoUYIx84BD/UCpuRZ3yP2KYp2qQ1qmr5TS+M7g7BkI7oZNbT4PI/G0yA
	 yCYeR7Mxs0g+QxxTFn/nP8E5wT+r9uPk+xQBngjqdpJY3P5b0mptnU10Y9ZKbAOgtVS8L
	 7Jnkw2D+wWGdTlByCr5qjrajKOjFx7BwPvVUblq7YJzNdKNbMXjUI+eSZBVulyX+5PMyD
	 GMzDty5ak/95Fa4CSpv7+HWc2KWREbHxR/4qq+VrTbTsHsSG0KMK4u4soCa6iYa8LtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brp1MH+5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720B5606A326;
	Sat,  7 Nov 2026 14:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brp1MH+5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E1C1F0089F;
	Sat,  7 Nov 2026 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061544;
	bh=MkhghfqilhVT/ckmRUQBhllwVdUXmL2prpoVCxMOAT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brp1MH+5dcxmCUB+2FFrr675wYDU1S4F7YO/WGJABzDXb2lOamiICh0zi9vbnrl4L
	 H1O/kJwqbPyDQrIfrjYckAamj3Br+x5c/kcfkH7/mNWLZVWnTIwJ0++AfGXJk26s77
	 fTm8OWNtPOa/hcls9blX3ihlaFxyWNKDrKnWRz5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 0629/1536] objtool/rust: add one more `noreturn` Rust function for Rust 1.101.0
Date: Sat,  7 Nov 2026 08:44:05 -0500
Message-ID: <20261107135015.198812153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

commit 6b704ec9007a3f23ec5ded8f320825ac444f307d upstream.

Starting with Rust 1.101.0 (expected 2026-12-24), `objtool` may report:

    rust/kernel.o: warning: objtool: _R..._4core6result13unwrap_failed...()
    falls through to next function _R..._4core6result13unwrap_failed...()

(and others) due to calls to the `noreturn` symbol:

    core::result::unwrap_failed::unwrap_failed_inner

Rust introduced this helper when making `unwrap_failed` generic [1]. The
existing entry for `unwrap_failed` does not match the new helper.

Thus add the mangled one to the list so that `objtool` knows it is
actually `noreturn`.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://github.com/rust-lang/rust/pull/164059 [1]
Assisted-by: LLM
Link: https://patch.msgid.link/20261018131313.59391-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -213,6 +213,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core6result13unwrap_failed")				||
+	       str_ends_with(func->name, "_4core6result13unwrap_failed19unwrap_failed_inner")		||
 	       str_ends_with(func->name, "_4core9panicking5panic")					||
 	       str_ends_with(func->name, "_4core9panicking9panic_fmt")					||
 	       str_ends_with(func->name, "_4core9panicking14panic_explicit")				||


