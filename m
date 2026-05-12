Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF8B3C0A01;
	Tue, 12 May 2026 17:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608451; cv=none; b=qB4TT1yR4KjIFfszu+1aqktLC341OvF9YZAtMlI+F1E8URvyJ7M9QBqBmYRBVsqgUlVHN8VvvDerDaySDkzF1Q3w4BQzEQRBrCvrWrOFoqAoQB4zA4AVOllOO8WJ0wA7AcAFdv1ViCC8wHCsqLDbLSWt6OrHoMgVNB0JnV+EVkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608451; c=relaxed/simple;
	bh=mGD2Be09doT/z8aVVpSvX+2me8pKEV6+Ko4RC69Kqyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjJBXOtYFWQmj5ha/lwGxwtWoJhz82DQFbHPGDWFnsAH2sFrQ5Joz8hs4/fwA292qYeleNp70AddSLV7phU+McOlxiEXlre6gAffau/dwabEqgFuhQcq9mhQiPdJEhoOtbIGFUWnSJWGfs0wV4QCBY4cq/N4wFJGsxhpUHHHLPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MS1lNu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MS1lNu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72636C2BCFB;
	Tue, 12 May 2026 17:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608450;
	bh=mGD2Be09doT/z8aVVpSvX+2me8pKEV6+Ko4RC69Kqyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MS1lNu+hCAP3d/lS/YcBpJgRuWQjdi4S8vucKebS2bv6sg2eKSx+J7p7yNAzlzcE
	 RmGS3smBe1CJeblBg/shIglGWmEbbHGdET17Ph4KJmwZ+LZjNsAQYgwFMGvh/XiiJD
	 tu4lbtdB+pcZrJhx571T34EO8jfc/fGnycKKD5+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 077/270] rust: allow `clippy::collapsible_if` globally
Date: Tue, 12 May 2026 19:37:58 +0200
Message-ID: <20260512173940.074669683@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -483,6 +483,7 @@ export rust_common_flags := --edition=20
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


