Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0666D4772B2;
	Sat, 12 Sep 2026 11:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212906; cv=none; b=XO5SPcFpQosbzfsXM7qSidwb4J15ukJpCwzgJsZ5dwHRH4/7eJxVAYqSPXHwX8VXUHevWrPvGLF09A3n6syVFw8CfuUvCWEcfjsJ6AmKmvEeR636hCi3rbzhdeUdsmG9ZEtim0uJ1xvqMU6bQO9heecb4shDreVbS2k4n/qpoWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212906; c=relaxed/simple;
	bh=/4URkfDNcAGRvpF4a6SYxNN8wpOHviIeni+MVkxiE3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjlNF86D+2D9U6pBP97sUeOcfDCcpUolBpQ4czDZVIBQRzf2B3Ficrwg7DW1p/dOPw+eYinHePUVjH4GFCapjaknwKWrPkEWMS5eR47ytX5MmeQxwdZ3TuHe7Zppb/1Y+rHXpcftyI9lqRC5q5Fvtwf/nVBbIrgcADQ2XlLC2jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+u9zRH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+u9zRH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C901F00899;
	Sat, 12 Sep 2026 11:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212901;
	bh=sCLQeMEevCOvTY7ANcxCbLigN4gu8FSxlRjBcH8aCdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+u9zRH5R6j+vXjjxZGI0OKZC09eNvjWiP2hQZmacIagP+7PpD6ndqctb+FekoLVl
	 r9N+yaPi3yNky+yuXu++jku/govpFy5/UT8uSIBsj7xCflpiBtHTmVrRfVCrxcqIMt
	 Z/R48cnTpDg578tORw3oi1zCvGJ9WVdoevN6gJsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0013/1376] objtool/rust: add one more `noreturn` Rust function
Date: Sat, 12 Sep 2026 08:40:39 +0200
Message-ID: <20260912065607.846547805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

[ Upstream commit c18f35e4904920db4c51620ba634e4d175b24741 ]

Fix the following warning:

rust/kernel.o: warning: objtool: _RNvXNtNtCs1ewLyjEZ7Le_6kernel3str9parse_intaNtNtB2_7private12FromStrRadix14from_str_radix()
falls through to next function _RNvXNtNtCs1ewLyjEZ7Le_6kernel3str9parse_intaNtNtB2_7private12FromStrRadix16from_u64_negated()

The commit 51d9ee90ea90 ("rust: str: add radix prefixed integer
parsing functions") introduces u64::from_str_radix(), whose
implementation contains a panic path for out-of-range radix values.
The panic helper is core::num::from_ascii_radix_panic().

Note that radix is derived from strip_radix() here and is always
within the valid range, so kernel never panics.

Fixes: 51d9ee90ea90 ("rust: str: add radix prefixed integer parsing functions")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251223113538.1016078-1-fujita.tomonori@gmail.com
[ Reworded typo. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f6fe896d0d652..e19bf7621daa3 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -208,7 +208,8 @@ static bool is_rust_noreturn(const struct symbol *func)
 	 * as well as changes to the source code itself between versions (since
 	 * these come from the Rust standard library).
 	 */
-	return str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
+	return str_ends_with(func->name, "_4core3num22from_ascii_radix_panic")				||
+	       str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
 	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core6result13unwrap_failed")				||
-- 
2.53.0



