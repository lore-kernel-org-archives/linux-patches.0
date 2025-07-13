Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3E81804A;
	Sun, 13 Jul 2025 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752418140; cv=none; b=rja4HeJv1KSIwdGLhdv/iFvDcq5DMi8sXJOSnGK+5Bj1q21wqX1ZR/vQg3QUSAt20f4yco8o1GQRWujtjVVjsirHMk01A/3WE5aDEYVG2zd5j+I8hCMc1Uru5ZnsxfRd3jtPVRWyNshYLUMAq+jHXuBUMZZjir0xu70CuabPRsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752418140; c=relaxed/simple;
	bh=oz6czx8HxgHo1482tpfP8IcaymOfGVB1uwRqP+6V3L4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=AE6lDiKOSgNlgAjmKrxklITfb09e7aCVDRY+EXy1WqdV65F3jF/aUwht8ey6gX/Wf5PjAZR/hC1DW8DRISkizqb8KBd2Sv3JkMj/m+3sIR63awd1+7rgo6d8Yz26owZ4pm7rD6aTyN313AbKBz+wv/s+q0YF5Ysgxii6DxvDBfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBN1PQbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBN1PQbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8CCC4CEE3;
	Sun, 13 Jul 2025 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752418140;
	bh=oz6czx8HxgHo1482tpfP8IcaymOfGVB1uwRqP+6V3L4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=CBN1PQbn4fmEkNeeEA+tjdRn7x2DHxEThJgu6gqJQzunZy8eU9THQ9YUGA1L4oeXe
	 d01VUjTtchpppTAeNaw/hzn5As6A27SBNDW6Frd2faojVbc+X2XqltAg8Aq/Id8n06
	 fJuVL2cLhChIDXRO3IDbpblB0MtxTB5CZtj7z3SA=
Subject: Patch "rust: init: allow `dead_code` warnings for Rust >= 1.89.0" has been added to the 6.12-stable tree
To: a.hindborg@kernel.org,alex.gaynor@gmail.com,aliceryhl@google.com,benno.lossin@proton.me,bjorn3_gh@protonmail.com,boqun.feng@gmail.com,gary@garyguo.net,gregkh@linuxfoundation.org,lossin@kernel.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tmgross@umich.edu
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 13 Jul 2025 16:48:42 +0200
In-Reply-To: <20250712171038.1287789-1-ojeda@kernel.org>
Message-ID: <2025071342-untoasted-cupid-13af@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    rust: init: allow `dead_code` warnings for Rust >= 1.89.0

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-init-allow-dead_code-warnings-for-rust-1.89.0.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From ojeda@kernel.org  Sun Jul 13 16:40:56 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Sat, 12 Jul 2025 19:10:38 +0200
Subject: rust: init: allow `dead_code` warnings for Rust >= 1.89.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: stable@vger.kernel.org, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>, "Björn Roy Baron" <bjorn3_gh@protonmail.com>, "Benno Lossin" <benno.lossin@proton.me>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, "Benno Lossin" <lossin@kernel.org>
Message-ID: <20250712171038.1287789-1-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

Starting with Rust 1.89.0 (expected 2025-08-07), the Rust compiler
may warn:

    error: trait `MustNotImplDrop` is never used
       --> rust/kernel/init/macros.rs:927:15
        |
    927 |         trait MustNotImplDrop {}
        |               ^^^^^^^^^^^^^^^
        |
       ::: rust/kernel/sync/arc.rs:133:1
        |
    133 | #[pin_data]
        | ----------- in this procedural macro expansion
        |
        = note: `-D dead-code` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(dead_code)]`
        = note: this error originates in the macro `$crate::__pin_data`
                which comes from the expansion of the attribute macro
                `pin_data` (in Nightly builds, run with
                -Z macro-backtrace for more info)

Thus `allow` it to clean it up.

This does not happen in mainline nor 6.15.y, because there the macro was
moved out of the `kernel` crate, and `dead_code` warnings are not
emitted if the macro is foreign to the crate. Thus this patch is
directly sent to stable and intended for 6.12.y only.

Similarly, it is not needed in previous LTSs, because there the Rust
version is pinned.

Acked-by: Benno Lossin <lossin@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init/macros.rs |    2 ++
 1 file changed, 2 insertions(+)

--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -924,6 +924,7 @@ macro_rules! __pin_data {
         // We prevent this by creating a trait that will be implemented for all types implementing
         // `Drop`. Additionally we will implement this trait for the struct leading to a conflict,
         // if it also implements `Drop`
+        #[allow(dead_code)]
         trait MustNotImplDrop {}
         #[expect(drop_bounds)]
         impl<T: ::core::ops::Drop> MustNotImplDrop for T {}
@@ -932,6 +933,7 @@ macro_rules! __pin_data {
         // We also take care to prevent users from writing a useless `PinnedDrop` implementation.
         // They might implement `PinnedDrop` correctly for the struct, but forget to give
         // `PinnedDrop` as the parameter to `#[pin_data]`.
+        #[allow(dead_code)]
         #[expect(non_camel_case_types)]
         trait UselessPinnedDropImpl_you_need_to_specify_PinnedDrop {}
         impl<T: $crate::init::PinnedDrop>


Patches currently in stable-queue which might be from ojeda@kernel.org are

queue-6.12/rust-init-allow-dead_code-warnings-for-rust-1.89.0.patch
