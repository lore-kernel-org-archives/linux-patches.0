Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6944F20ADF7;
	Fri,  6 Dec 2024 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497747; cv=none; b=fsJ4JznpP/1fLzO4OGnylak426hHC5YoGmVzh/jTqDBf6HCGEwMarBsxzAHsOf1ItaZvqDx893MC0pTj2/PrXCxczk4Ri2dYreECoE7VWZv1ZQ3uo8V2Av6efHo1SgGqZ+oLxnKPRCH1FaDOUzw/1Z7CfAVrf95pMvv7q8ljNSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497747; c=relaxed/simple;
	bh=sRaRfZY1ku2bxMYCKOGURoennicAthfZCV6BKbYaw0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLaTriX4FATyUuCm+H6c0vvvrhDQRg0uGJNfGew2nSziJizjXIk6A54bt1ZVbB8U9cm+uzSkKwp39D61T7LkGUjwwCfG2zr/ohdy42mbmKrVen56so1ZiCw5pvNpYFYtOupFeH9YuDSyjQWBbMnvbwLsMah6mh2QihNpuW3e7pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5/IwGQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5/IwGQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D7BC4CED1;
	Fri,  6 Dec 2024 15:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497747;
	bh=sRaRfZY1ku2bxMYCKOGURoennicAthfZCV6BKbYaw0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5/IwGQ4Q/itqBXiwvFMAt+Ox79EXPtpeBtmAbBW7Uo1lrZxhZ/sdOCT8XmQOAQA6
	 gpbbMbuhMSS0D8NKmhE8fLXSajXjor2JamzyziOIwFOa4lbeptejpVAyuIOd/8t6Ai
	 S/aEaDkUu3m+4METKfwkBl7LHdqXf35rmzwbIBjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 350/676] rust: macros: fix documentation of the paste! macro
Date: Fri,  6 Dec 2024 15:32:49 +0100
Message-ID: <20241206143707.016633698@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 15541c9263ce34ff95a06bc68f45d9bc5c990bcd ]

One of the example in this section uses a curious mix of the constant
and function declaration syntaxes; fix it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Fixes: 823d4737d4c2 ("rust: macros: add `paste!` proc macro")
Link: https://lore.kernel.org/r/20241019072208.1016707-1-pbonzini@redhat.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/macros/lib.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 34ae73f5db068..7bdb3a5a18a06 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -298,7 +298,7 @@ pub fn pinned_drop(args: TokenStream, input: TokenStream) -> TokenStream {
 /// macro_rules! pub_no_prefix {
 ///     ($prefix:ident, $($newname:ident),+) => {
 ///         kernel::macros::paste! {
-///             $(pub(crate) const fn [<$newname:lower:span>]: u32 = [<$prefix $newname:span>];)+
+///             $(pub(crate) const fn [<$newname:lower:span>]() -> u32 { [<$prefix $newname:span>] })+
 ///         }
 ///     };
 /// }
-- 
2.43.0



