Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F4223CE;
	Tue,  3 Dec 2024 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241684; cv=none; b=ZLEWGpZpm3ojTo595KPyTgSoERGrSCzg56aZ5czG2M7fjOTUzJVuslXs9JLkZC/pRs34JiU3Sx4rjJXGLWQ5BnyQVhlQ9GFe02bM7JcyCRx3hHZBSzLbQYBPJ4fF7PrkFancjWDPTP2c7hy0yuvUs0oR4wtlD2fKYvrWOPVOlUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241684; c=relaxed/simple;
	bh=ob1TD0dRfB1ZyHqnmV615dqdwClBeFlk9zBTTV8w/uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmdK8VA08O3PRf+yGdXUpd5O/aLpFeHd0/rNJgJeseDMSnnfcDvGKsrC+Ab0RLGu7tzyMD8u6QYu3RrjBwHSoVuu3ekENvQW2J5VdI1v4guIzhXVvSTX8swe1DjErwlRTXqw3spdkTmfHTlKtr2wlp8Is7UjwaU6AVJ6zN7bD7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4yw5vH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4yw5vH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A22C4CECF;
	Tue,  3 Dec 2024 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241683;
	bh=ob1TD0dRfB1ZyHqnmV615dqdwClBeFlk9zBTTV8w/uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4yw5vH10nCV2H6guXVOx6rmySJjYkd5pLHJ430g6AccEeEzdISyEieTZOJuhKQRw
	 zZmDozWQPN4TAfAz56faQVpBVTr6kAmkIJ97zTf6fV7z5fdeSFEWgMJn2+Y4tv+F2c
	 g5GFI9NOttIH0j+AcWbjOg0SyYOPvKaCH5kD2RAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 489/826] rust: macros: fix documentation of the paste! macro
Date: Tue,  3 Dec 2024 15:43:36 +0100
Message-ID: <20241203144802.832437468@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a626b1145e5c4..90e2202ba4d5a 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -359,7 +359,7 @@ pub fn pinned_drop(args: TokenStream, input: TokenStream) -> TokenStream {
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



