Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831432;
	b=tCZgX00eGWKITmpnLDwl8Dm6u3ERd54Y3SyW9DOUy9ovlB+zYME/fh+A2P8/Ai6vq3Lq
	 eoSY2dLChbWjqJVMJXkf83CtRhrBiK5lyohonTZJXLs1/CV1rVmWkct++K7KMIcFsGRRn
	 t33EijbFLYynDTFfkm3RhS9eu3w12gwDmExa6KIAqgsiGIbhqEoyvxkgyO0ZwJ/QmBPXe
	 bsrDeIAIfD61n4s0oJIxf+p4YZm1Oiqtf2ziBDzU3q3q9o0hwRGzfhpoiVjCXQeAqAxW6
	 nIVsW/AG4MRg5NXY2HYMICKe2EvRmwf13j/o7ebLtP2qCdq7JlROw7sO8/N2sVHaoFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RUHRIN/lBUsjCmYEAjjpeN31TApF0PjcPoHtxnmayKU=;
	b=PkpaevumHD65oztvv+dpRsfFvGgvv0d9pyfwlq0i14Uj4Qrv7Ty05uHkurOdTqdMeN7y
	 WoUylN/Cxj9W3pPMCqTihEz0xjvtxxLuYMIDFMdQ/PFR3eEv99KJkKV0ypi81Q/oQ8vys
	 m/OSq72mdt+othWv1yNJW1dUp8Kv5m+9+ykf1dWt1vfnO7Kjom2/3qRaxQpTmkn65kjB0
	 8I8e8JQqIzpflofe/vlmiLOWwZs9mXFzs4vNtZYUKW/S5GqZ8NyP4vosv+sEEPpQyzcsd
	 i273aKQHprwOn8bt1ulFqVhu3wjiVBkUehFJGSIalVYpuqPkHxmacWhaBlQBvXBoH4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rkLcAj/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB82606B384;
	Wed,  4 Nov 2026 22:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rkLcAj/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B321F00919;
	Wed,  4 Nov 2026 22:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831432;
	bh=RUHRIN/lBUsjCmYEAjjpeN31TApF0PjcPoHtxnmayKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkLcAj/Rxnn8DoRx9MWytZFdf/J+MCtUnmRs2dNO43LU1bn4rSiB11DlCJG5oZY75
	 Cf9D9QW4FYOyXw/hb6neZOZkNLeAzQ1l41sDZMyJU0Fus17PV0ZZDLZy5bDk+P+bpV
	 YXlc3tgcqjV0OM6/IAlUNguzJd3wxW5h3txnSp8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 0698/1005] objtool/rust: add one more `noreturn` Rust function for Rust 1.101.0
Date: Wed,  4 Nov 2026 16:07:11 -0500
Message-ID: <20261104211103.150421943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -221,6 +221,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core6result13unwrap_failed")				||
+	       str_ends_with(func->name, "_4core6result13unwrap_failed19unwrap_failed_inner")		||
 	       str_ends_with(func->name, "_4core9panicking5panic")					||
 	       str_ends_with(func->name, "_4core9panicking9panic_fmt")					||
 	       str_ends_with(func->name, "_4core9panicking14panic_explicit")				||


