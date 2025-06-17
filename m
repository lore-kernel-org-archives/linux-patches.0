Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD91CA4B;
	Tue, 17 Jun 2025 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179526; cv=none; b=Cgrh/dnzpLSMXwb0RCXGAJOGwrDBC4yKyHH2pa/0wBYkT/v8vZrYKCTuCyxUHYXh2LCx4ConAWlkHb0xrD54jizXMtrOBCXIkyFAc+gTFpkMmD/XJbv08VNZQLJ2AsHcE69NaqzIut2/OdSwmyopYK3Pmu5b7+UrFAcvYRH4410=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179526; c=relaxed/simple;
	bh=9rJf45ZjkXLPnzhzS60uM0DdVOl2+DupF3X1qZkPkjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUPulLooaiEVFjOpgXpry4bbVAT1CG+d3gQeC18KIEPz8PgWur3Rb1ol5ww/3m5DtozBs+NLjJvyvxiWKoGbDi2daQR/czDC/nwUh81oCQz5+SuiwXNZeZq8qdfnHJXLlw371G/QIwbciZyUgUnwlIslZz6y2SYTMUxjnqMYP4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E47XSp15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E47XSp15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995AFC4CEE3;
	Tue, 17 Jun 2025 16:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179526;
	bh=9rJf45ZjkXLPnzhzS60uM0DdVOl2+DupF3X1qZkPkjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E47XSp15Ge+FS6q3Vk7rT9VqaS+Ou+zqWoGk5KlvMpABYcGlI5T8HgvKOcCWaIe6t
	 iz2UPrLJ3Qpyu1fMQ7spnvwtu7XtTQmCuPcScVBXcbY1eIVIKEsmJuoCsyP7AdoGnH
	 9wHMSAh77+Jm1zOvwPBbiTuMfIw6WZXsYiUm61Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.15 742/780] rust: list: fix path of `assert_pinned!`
Date: Tue, 17 Jun 2025 17:27:30 +0200
Message-ID: <20250617152521.719123923@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Benno Lossin <lossin@kernel.org>

commit eb71feaacaaca227ae8f91c8578cf831553c5ab5 upstream.

Commit dbd5058ba60c ("rust: make pin-init its own crate") moved all
items from pin-init into the pin-init crate, including the
`assert_pinned!` macro.

Thus fix the path of the sole user of the `assert_pinned!` macro.

This occurrence was missed in the commit above, since it is in a macro
rule that has no current users (although binder is a future user).

Cc: stable@kernel.org
Fixes: dbd5058ba60c ("rust: make pin-init its own crate")
Signed-off-by: Benno Lossin <lossin@kernel.org>
Link: https://lore.kernel.org/r/20250525173450.853413-1-lossin@kernel.org
[ Reworded slightly as discussed in the list. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/list/arc.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/list/arc.rs b/rust/kernel/list/arc.rs
index 13c50df37b89..a88a2dc65aa7 100644
--- a/rust/kernel/list/arc.rs
+++ b/rust/kernel/list/arc.rs
@@ -96,7 +96,7 @@ unsafe fn on_drop_list_arc(&self) {}
     } $($rest:tt)*) => {
         impl$(<$($generics)*>)? $crate::list::ListArcSafe<$num> for $t {
             unsafe fn on_create_list_arc_from_unique(self: ::core::pin::Pin<&mut Self>) {
-                $crate::assert_pinned!($t, $field, $fty, inline);
+                ::pin_init::assert_pinned!($t, $field, $fty, inline);
 
                 // SAFETY: This field is structurally pinned as per the above assertion.
                 let field = unsafe {
-- 
2.49.0



