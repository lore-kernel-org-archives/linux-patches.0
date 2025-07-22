Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C33C22D785;
	Tue, 22 Jul 2025 14:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192836; cv=none; b=UoBuPSSiXmeQ9Eu5J6jOcAh4pvpG2ZxbTachYvyDnEdE/IXAHcXePkisTyqTKK1DVHsTDfSwi/7vzMVGfPzKoicNP5vYybZZGBNB9cZK7apSEcJiWabiXbqafe1YU0bkaOdMcD+SggJLeI9nt1mXHOunbdcoa1GAUyAlZx+ddzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192836; c=relaxed/simple;
	bh=m0ZGaLsinQtKPMK7o3PgRQ+RZjYJ377tDwYKmtZ2Wok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgILh9K3ohIEAZLUgTsw6G383eq8ilLga5nRT3qN6Fzf842GIeyUryNT7Ui7zlnj+vzEr95+RjTCRP19YTRSDgL1yd+PqGEjj7ZdVFUwRdaSE4FPYnyjwFFpsKR60nWxbzBuuCj9jDybUZAwoR2vXcGv0o9MMrpGoM1kMBHnqqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5bORiuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5bORiuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35729C4CEEB;
	Tue, 22 Jul 2025 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192835;
	bh=m0ZGaLsinQtKPMK7o3PgRQ+RZjYJ377tDwYKmtZ2Wok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5bORiuZjX4ZV5l6anR3jxjFQxqFRC9Aoe16RBuJU0HUbWGzAH7WuaSSZ34W/LJoP
	 mSBpqe0gqLns6TrykcPiSmGnowYrrHcLsa+v5mUAKshc28LG/NECfNE+oYnVt6kbzS
	 cVvfBap+hCUjgHD3oU9L8HS2LLK8X5rttqhTsO2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 028/158] objtool/rust: add one more `noreturn` Rust function for Rust 1.89.0
Date: Tue, 22 Jul 2025 15:43:32 +0200
Message-ID: <20250722134341.795476932@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -216,6 +216,7 @@ static bool is_rust_noreturn(const struc
 	       str_ends_with(func->name, "_4core9panicking14panic_explicit")				||
 	       str_ends_with(func->name, "_4core9panicking14panic_nounwind")				||
 	       str_ends_with(func->name, "_4core9panicking18panic_bounds_check")			||
+	       str_ends_with(func->name, "_4core9panicking18panic_nounwind_fmt")			||
 	       str_ends_with(func->name, "_4core9panicking19assert_failed_inner")			||
 	       str_ends_with(func->name, "_4core9panicking30panic_null_pointer_dereference")		||
 	       str_ends_with(func->name, "_4core9panicking36panic_misaligned_pointer_dereference")	||


