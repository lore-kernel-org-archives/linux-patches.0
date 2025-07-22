Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847832F002F;
	Tue, 22 Jul 2025 14:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193264; cv=none; b=Fj/pVevpzUe99dcnKDaeshJK+XNDdr4bZYE4k2JWZImSSy2Brqi/RI97YaZK6DXRO9hX9CuHnHe6cFFQeluE3lVJG7QUju6XFvCaC7Cb2i5XyVyDwl/isxzKW0YxprB5Du2hBvVd3M2Ps9cc1pJ69x0LVknbDR6T5TApSKMVFEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193264; c=relaxed/simple;
	bh=A2AbqezS8NKzk/9EFcR9mmTZqhaw2tisf5UT2VJzI+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I60TgpBnC11w6myTBj4vdLrjmz74sjezJzEF2xQi+rvguVLAoYs1XLNY4oh6mU6tw22geGjTYoGEgpJGqJuc8twftc3wkKuuuSbnRrmAXaNFHcTpM3qN+KLy6xE1EHGL5aV6qcscVFg4ZYvNDLpIL8iuGGFi+Cpf3RcVQsAmQaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2rLcXRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2rLcXRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD2DC4CEEB;
	Tue, 22 Jul 2025 14:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193262;
	bh=A2AbqezS8NKzk/9EFcR9mmTZqhaw2tisf5UT2VJzI+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2rLcXRjq2OYcQxue7K1Hp97Q0lCCOFlMvueSEhP3J3F/NxFpWXYhJPIA2ko6n+rg
	 mzCLKt1Hs9t1vNnJevtFvpIqpA/DoBumlJYZsRwb63Jv5ATLpQJhcXEv9uuXjfwyV8
	 iBZwYXPaqPh+6DNHBY8Scn74/7A4HcBUr8ZwWsBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.15 032/187] objtool/rust: add one more `noreturn` Rust function for Rust 1.89.0
Date: Tue, 22 Jul 2025 15:43:22 +0200
Message-ID: <20250722134346.953541759@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit aa7b65c2a29e8b07057b13624102c6810597c0d5 upstream.

Starting with Rust 1.89.0 (expected 2025-08-07), under
`CONFIG_RUST_DEBUG_ASSERTIONS=y`, `objtool` may report:

    rust/kernel.o: warning: objtool: _R..._6kernel4pageNtB5_4Page8read_raw()
    falls through to next function _R..._6kernel4pageNtB5_4Page9write_raw()

(and many others) due to calls to the `noreturn` symbol:

    core::panicking::panic_nounwind_fmt

Thus add the mangled one to the list so that `objtool` knows it is
actually `noreturn`.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250712160103.1244945-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -224,6 +224,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core9panicking14panic_explicit")				||
 	       str_ends_with(func->name, "_4core9panicking14panic_nounwind")				||
 	       str_ends_with(func->name, "_4core9panicking18panic_bounds_check")			||
+	       str_ends_with(func->name, "_4core9panicking18panic_nounwind_fmt")			||
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
 	       str_ends_with(func->name, "_4core9panicking30panic_null_pointer_dereference")		||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||


