Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EEE183CBB;
	Mon,  2 Sep 2024 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725298401; cv=none; b=kdPJ3IJ8JasF5dKA3uKn55nNRx52HvN3Egsu3f3cMty/kPOWzy8DEX7xPCk0yFIhIRF7KOvDBVFQyZOTLnthlOguv1OcyH2KsO6egdR5D51AMwca2kCdPh7gAks/1d3BI7Ijlmn64r/xXA4AdHCsyGq1l00+s8vnuA3O9tVBJpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725298401; c=relaxed/simple;
	bh=POJbiAEvmV/X7WwpnqvkdEzC3Sr45qucZ9GgrlbddrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=W6Ebi3398smraeGUuZzByTgWqag50zvf9FHXDZqsbeKC3/+bHaKPZZeVRDwNEXs0E5P2fvdOVX+DaCX4cmtJyxMx2asXuhGz8bNyBEdkQ514fXBQCX3eUtmNPLmHKAhKOoxWWnA6Sh6dipM2TbxGQ+NcAoneQbT99o1qGZ4EZ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hf2jdsaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hf2jdsaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF768C4CEC2;
	Mon,  2 Sep 2024 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725298401;
	bh=POJbiAEvmV/X7WwpnqvkdEzC3Sr45qucZ9GgrlbddrQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Hf2jdsaJJaP/YScpGoCu4IOwAgwFL0OURKojLw8yeNgOEMbSMz5DEgfcUNiNWLeuS
	 CmqsfWV1fT6oyZSW7g8/tD5FTZrlm1aIR82kXSrnkD48ILr8Yy4sRSkbiCW+NJrGhk
	 SI2cm6ifSNBp5vstYFpjHRN2yXkE/mDhroiVnA+RhjQpUhC5KJgrl5B7T0Ynr22Etn
	 H8F6JqO/2ihozr5kuoi3HPtOSmyrvoDlOIbgM5RDYkr2nsOGxlbcXnoNIVKgzDXzdr
	 Iu9XwiAqJIVqulKlvAiQa+cShFrBn4XrcDgQyrKDzqvV5pRym3FJjAUjznJ3oAvlfu
	 /+9ZgdaZU2Jxg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Trevor Gross <tmgross@umich.edu>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] MAINTAINERS: add Trevor Gross as Rust reviewer
Date: Mon,  2 Sep 2024 19:32:54 +0200
Message-ID: <20240902173255.1105340-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Trevor has been involved with the Rust for Linux project for more than
a year now. He has been active reviewing Rust code in the mailing list,
and he already is a formal reviewer of the Rust PHY library and the two
PHY drivers.

In addition, he is also part of several upstream Rust teams:
libs-contributors (contributors to the Rust standard library on a regular
basis), crate-maintainers (maintainers of official Rust crates), the
binary size working group and the Rust for Linux ping group.

His expertise with the language will be very useful to have around in
the future if Rust keeps growing within the kernel, thus add him to the
`RUST` entry as a reviewer.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f328373463b0..77b395476a80 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19914,6 +19914,7 @@ R:	Björn Roy Baron <bjorn3_gh@protonmail.com>
 R:	Benno Lossin <benno.lossin@proton.me>
 R:	Andreas Hindborg <a.hindborg@samsung.com>
 R:	Alice Ryhl <aliceryhl@google.com>
+R:	Trevor Gross <tmgross@umich.edu>
 L:	rust-for-linux@vger.kernel.org
 S:	Supported
 W:	https://rust-for-linux.com

base-commit: a335e95914046c6bed45c0d17cabcd483682cf5e
-- 
2.46.0

