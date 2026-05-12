Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C21E25FA29;
	Tue, 12 May 2026 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609133; cv=none; b=jqIkH8VykXTRnpSQRyXfySFcgl15NmjNu8l7Vlpq+1W0csa6KQhw/6g2W55IIl2aC4bjVQxH32DEtDjvFCsMF9Q76vEbWBSCtaL1Tzo28MlGv+0xfBY1jLD0cZYujT2wOsPHMQh53B5jxHtPFMT8R9pEOuXlnCARCJlwYdKIb78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609133; c=relaxed/simple;
	bh=M6ydTwUiWTUG0tE0KbD/szBE402y6/fuzWJBjK5uglo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYPcQF7Cv2QLcAEfQ4RPDFIbsE38QM0OyCyO1osKh3Lyeq6Gdx2c/MI0KJRh3FSkif3Lp7Hcy4If7BPErAJZ/Unnv0fuGMR+nN5Oqmm0T1BnyzfNC3IM797ZzfdLNlXc/GCuNJOG3w7vbwcNgv/UHw9ZkC2Z4FSGuc6jTFfmU1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjjsZt64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjjsZt64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243B2C2BCB0;
	Tue, 12 May 2026 18:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609133;
	bh=M6ydTwUiWTUG0tE0KbD/szBE402y6/fuzWJBjK5uglo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjjsZt64v+Z8nCB9wp9OYy32pIjVEl2k9ZDny0MWPKIIK4g41V1qP9F7JM6vrne8Z
	 kl8pbqnhkm0XWcQy0Db/ZmuK1cWii6UC39AdrHJ8C120Au2OwbqKkglYxjVYDlmDGt
	 FvUSO0k9lGswSlc1101dkYGsdR5faStrXm54J0/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.0 079/307] rust: allow `clippy::collapsible_if` globally
Date: Tue, 12 May 2026 19:37:54 +0200
Message-ID: <20260512173941.787692975@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 2adc8664018c1cc595c7c0c98474a33c7fe32a85 upstream.

Similar to `clippy::collapsible_match` (globally allowed in the previous
commit), the `clippy::collapsible_if` lint [1] can make code harder to
read in certain cases.

Thus just let developers decide on their own.

In addition, remove the existing `expect` we had.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Suggested-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/rust-for-linux/DGROP5CHU1QZ.1OKJRAUZXE9WC@garyguo.net/
Link: https://rust-lang.github.io/rust-clippy/master/index.html#collapsible_if [1]
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260426144201.227108-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                                    |    1 +
 drivers/android/binder/range_alloc/array.rs |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -486,6 +486,7 @@ export rust_common_flags := --edition=20
 			    -Wclippy::as_ptr_cast_mut \
 			    -Wclippy::as_underscore \
 			    -Wclippy::cast_lossless \
+			    -Aclippy::collapsible_if \
 			    -Aclippy::collapsible_match \
 			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
--- a/drivers/android/binder/range_alloc/array.rs
+++ b/drivers/android/binder/range_alloc/array.rs
@@ -204,7 +204,6 @@ impl<T> ArrayRangeAllocator<T> {
         // caller will mark them as unused, which means that they can be freed if the system comes
         // under memory pressure.
         let mut freed_range = FreedRange::interior_pages(offset, size);
-        #[expect(clippy::collapsible_if)] // reads better like this
         if offset % PAGE_SIZE != 0 {
             if i == 0 || self.ranges[i - 1].endpoint() <= (offset & PAGE_MASK) {
                 freed_range.start_page_idx -= 1;


