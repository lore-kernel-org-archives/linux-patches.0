Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827093;
	b=wqz7/W6Xr3TuAiCBjf5RuSDscq5X5ft/A5wXG+YZDO6/TRypMWvtxlvUdMohTKw6vF3i
	 uMfkwXnDIKDpDmD26e9i8ru608sbr0FyEv+mQIyaily462bfgNv1MmNDSHUmZ2wNwhSiV
	 bYi2kAh6PXGWbV1+EMn8luvnL6f4w8AL7Qmue01JdWnFncWSBlsHoOOV+oRrKl1b3B2Pn
	 0BNlj72XsmwRisdamQrAviZoFUyJOxsqb9jJ425UdE6HSu1gH9zLDo4oQLfcqlQ/x0Z72
	 JdYWKBVOMAgZmE0z6BFUwqG9Ka/qgDHOQ54wi0Cg08wk+iwAl2pUGuZXn66XlXUWWkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qPn8pXMJ3Ie2Ex8Juvyz+SfDsim1In3F3HczjRMGEJg=;
	b=3WLbcPEKwAFFEe6EMoIaTJSHbeXOkBVMNz66vgJ0jkYvxeX1gijaDjDSezGAbC/EV4ZV
	 ygj+KCTDBBXzgMV6HivV/ifxwN+GoviXCRS19ct6iEquxzh7Y8R8h85wln2vd5v1Au8Hs
	 0/+01G5N4XDfqsYKLF3Luxfu8+wutZM8vEVesqpXG35wl5XiV1irCDihllyKo8duWJMk1
	 hQTsx/GMz/GbcYFFHPApC7d3JbgXRr57b7Ml3vwdfS/88QXoiVY6Er6HhLq0BD9xCEsz1
	 MLSeZRB45hpUd94HX2ubFCsb7gdO4OkGBXQxdbibzHcm7eCHhBwCQPeKEo4e6xuC5lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nK2rKu22;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65DF60841AD;
	Wed,  4 Nov 2026 21:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nK2rKu22
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8D61F000C1;
	Wed,  4 Nov 2026 21:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827092;
	bh=qPn8pXMJ3Ie2Ex8Juvyz+SfDsim1In3F3HczjRMGEJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nK2rKu22ufwOuU68TuTKJJffapARVbe2uRcAthRH5cS1REKKOEthmWyKOMrtDuvWM
	 EyErW2drKQJqJ8LVbEzzukqSqwHt+hVxRZi/ytKW2up6q67pshTS7PcVz9iXPjx6Df
	 BIPPkdfqgCnZacxzYq78fJVAIYHGmO2BLwb/hGsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.3 191/547] objtool/rust: add one more `noreturn` Rust function for Rust 1.101.0
Date: Wed,  4 Nov 2026 16:06:15 -0500
Message-ID: <20261104211043.560713701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -201,6 +201,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core6result13unwrap_failed")				||
+	       str_ends_with(func->name, "_4core6result13unwrap_failed19unwrap_failed_inner")		||
 	       str_ends_with(func->name, "_4core9panicking5panic")					||
 	       str_ends_with(func->name, "_4core9panicking9panic_fmt")					||
 	       str_ends_with(func->name, "_4core9panicking14panic_explicit")				||


