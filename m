Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973163A9629;
	Fri,  4 Sep 2026 05:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500370; cv=none; b=Prvz7lJbZZeaWesY24tW37+aEUuE10f2zGGNiYWKvAEyjUa5JXwi9oZ4xHAVxM0Zv/3D92K1o2w4Pt3xDSFZkIZuhZcNQS6LlEJL/KvOvgFTTyMZJH3Q2QfTjWymt8OCTHktbjPqdxhqPoSrtUMMI+YZfzxufitsL4xGi0Jn4Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500370; c=relaxed/simple;
	bh=Rctwr566TorC2FEtt++MF1rMDGICSyLwmiX2tlkRVaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwveoz0qNY6OSFYb9hpqB3UxH4VeIreOzqjw792fhHzdreQ+SepX4Q0nv6+bBQrQHUNWzQbKOV6X5OoNT43D1QRU5at4x49kIoPQbVivEx3FZJAUomeyS1vQv2rskZg8qyrDCzsHAUYf2Y2fiyG9S11UyLvebRvuuF1vpkiRkCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rt0QRKY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rt0QRKY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F291F00A3E;
	Fri,  4 Sep 2026 05:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500369;
	bh=XcmL+MrArwu8gHdAI6CGtLzXVHVdgd+qGbP7WlfsCQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rt0QRKY0sXD6oPU+mDuxZtq6yXSrrAERH+McQ118d214aFriXh6cRRy7KvIhUWdub
	 l1VLVTj/YPakCdG8/0yKXehOU1QsSouO+ZDjJo9n38xEm82JH8EFyV6EIdc/5btUMU
	 KoTe0yr/zuY6LYMREZcj1R02dDClAAPtrSZaZAQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolai Grlica <nikolai@nikolaigrlica.dev>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 025/552] rust: kernel: list: fix incorrect pop_back example comment
Date: Fri,  4 Sep 2026 06:53:02 +0200
Message-ID: <20260904045748.397429943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Nikolai Grlica <nikolai@nikolaigrlica.dev>

commit a5c7d35e2fd3e24c411816c91f8f6cc78e652e0c upstream.

The example uses pop_back(), but the accompanying comment says
pop_front(). Update the comment to match the example.

Signed-off-by: Nikolai Grlica <nikolai@nikolaigrlica.dev>
Cc: stable@vger.kernel.org
Fixes: bf87a41b85d6 ("rust: list: Add an example for `ListLinksSelfPtr` usage")
Link: https://patch.msgid.link/20260810150322.61809-1-nikolai@nikolaigrlica.dev
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/list.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/list.rs
+++ b/rust/kernel/list.rs
@@ -233,7 +233,7 @@ pub use self::arc_field::{define_list_ar
 ///     assert_eq!(list.iter().count(), 3);
 /// }
 ///
-/// // Pop the items from the list using `pop_front()` and verify the content.
+/// // Pop the items from the list using `pop_back()` and verify the content.
 /// {
 ///     assert_eq!(list.pop_back().ok_or(EINVAL)?.value.foo(), ("a", 15));
 ///     assert_eq!(list.pop_back().ok_or(EINVAL)?.value.foo(), ("a", 32));


