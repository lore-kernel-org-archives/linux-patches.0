Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378F126ED33;
	Thu,  4 Dec 2025 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764859853; cv=none; b=nIuxcq84FrhwPJJjOejJuNBVvQb+a3COhJ3P3tG64+AEBkioz1PRHUkEojhLsEY+2CvmM7MyHKExsZuocn8v8+rLu2lXp0LDzMA60dvC9FT1EDgE4juEa3YgAiB8ewtEcrAswi2+XDws2M70kvR2xLWaW0rZ5tJFd/NRfHkfRQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764859853; c=relaxed/simple;
	bh=57EUhknxP+N6Azfo4iushZqqYFaxz3h03NpTrin+1Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FIgrcKEQdHWUk/ilcVnc3SxsfGVMVg3jp+9KX61XDj1x45o+M3Jh5izdWuRBRiXp7a4owVBWgedSXp/qtUbG2SQNoyB/NJh/RyNqfCf1yx4mWtnR7J2s+UCYqFUCQFV+J35XUzzBZk9AG/lyfFUErVQ9gNaFHoLoxHtvFrRLXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CP44IMzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CP44IMzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14570C4CEFB;
	Thu,  4 Dec 2025 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764859852;
	bh=57EUhknxP+N6Azfo4iushZqqYFaxz3h03NpTrin+1Sk=;
	h=From:To:Cc:Subject:Date:From;
	b=CP44IMzMUocylgPpKvIhk4TcnoJ3QD9xPz+mKF/JXM9mZG+DyqYXx+NypiqWOcpW7
	 jCA/uyjPAqg1aR+/DjiMaxMV6ScZVuN7LUPQjGreqvlv1b+kGc1Q7vwoYmI50/wPK+
	 awzuXBLIBQzHDSV8y5dZGU0koVHEhC0IhFfna2f/s1bsrplIRWbzA19AAen2jm1hIf
	 /6dfUgLe21Yrs1FNiuaTYmBcaTP2/z8aL1Xnv+s2vdVF8AE3RIQszxkmg9wVQCBRc2
	 FpdgzBDQ6P5czteq5mb5HW9RzYlmUIj5muJgVqLJykLFEHyw6c+tcMGDdbETKqcDze
	 AkiIjGMW547Kg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Gary Guo <gary@garyguo.net>,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: sync: atomic: separate import "blocks"
Date: Thu,  4 Dec 2025 15:50:35 +0100
Message-ID: <20251204145035.2056127-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 14e9a18b07ec ("rust: sync: atomic: Make Atomic*Ops pub(crate)")
added a `pub(crate)` import in the same "block" as the `pub` one,
without running `rustfmt`, which would sort them differently.

Instead of running `rustfmt` as-is, add a newline to keep the import
"blocks" with different visibilities separate.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Perhaps Linus could pick this one directly if ATOMIC Ack's it?

 rust/kernel/sync/atomic.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
index 3afc376be42d..4aebeacb961a 100644
--- a/rust/kernel/sync/atomic.rs
+++ b/rust/kernel/sync/atomic.rs
@@ -22,6 +22,7 @@

 pub use internal::AtomicImpl;
 pub use ordering::{Acquire, Full, Relaxed, Release};
+
 pub(crate) use internal::{AtomicArithmeticOps, AtomicBasicOps, AtomicExchangeOps};

 use crate::build_error;

base-commit: 559e608c46553c107dbba19dae0854af7b219400
--
2.52.0
