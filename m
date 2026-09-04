Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8007F24A05D;
	Fri,  4 Sep 2026 05:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498333; cv=none; b=oL9qLT0KEB8HyX9Tg95cwY0BlOs6SLzN4q1vaU8vnML5cCpq8+5MfaneOUm32QA3fV8f0DpF9CgFqTbBhZlqnDyO6BetzfF1ulCwQUQd6+9qb95Cv6J9c3W4hl8wzjBcweN03CdrD27xKlHBJUyafRyygRz17ZxN5KzEEsTOjJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498333; c=relaxed/simple;
	bh=DUy8jma4GHeeAp1Fhp36cc8733cb4nS2CNAyhbEpFIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7qQy0KMA3DHiFAN9p+JYkRYPBHr1j+HDSA6jsy0/F7rbUXkdIQI10qudYFs/ssHlK6B4oxEPkbFbxs3+ozIS78PcGiLtstmWMyp76uzL2CC6DaMSRQqfGCfC5velgrRdZgOeNLeL3YcZvOzOztDxYJVN0N4Ra+ieQ7UbykYZ5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuHBqDAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuHBqDAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D981F00A3D;
	Fri,  4 Sep 2026 05:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498332;
	bh=QjJpF6V7LTl6X+BYY1vzGXxWZyhwHznNw2xEfkCqxr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nuHBqDAnBoRNLg1gG9Uhp67Y/FrgsxkwczMpGFMYTYNjwu4s9UbBFfhRy3ZUAh9KY
	 C8o55+m0scUGhrourDVeXei6AnGVNmS3/ChvPrcB1olxDVEu20YF42g9uAknjKqNGV
	 XNwgU2T5lEUpRNbfjtZOoJdjFiBoNnlOZY+481a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 025/713] objtool/rust: add one more `noreturn` Rust function for Rust 1.99.0
Date: Fri,  4 Sep 2026 06:49:53 +0200
Message-ID: <20260904045804.391581557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 16861ca3508e0deac70d3bcacb6dcf435b49d9ef upstream.

Starting with Rust 1.99.0 (expected 2026-10-01), `objtool` may report:

    rust/kernel.o: warning: objtool: _R..._6kernel3str9parse_intaNtNtB2_7private12FromStrRadix14from_str_radix()
    falls through to next function _R..._6kernel3str9parse_intaNtNtB2_7private12FromStrRadix16from_u64_negated()

due to calls to the `noreturn` symbol:

    core::num::from_ascii_bytes_radix_panic

The function was renamed from `from_ascii_radix_panic` [1], which is
already in the list.

Thus add the new one to the list so that `objtool` knows it is actually
`noreturn`.

See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
for more details.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://github.com/rust-lang/rust/pull/159554 [1]
Tested-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260728191448.349241-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -194,6 +194,7 @@ static bool is_rust_noreturn(const struc
 	 */
 	return str_ends_with(func->name, "_4core3num20from_str_radix_panic")				||
 	       str_ends_with(func->name, "_4core3num22from_ascii_radix_panic")				||
+	       str_ends_with(func->name, "_4core3num28from_ascii_bytes_radix_panic")			||
 	       str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
 	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||


