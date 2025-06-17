Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B641A2632;
	Tue, 17 Jun 2025 16:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178880; cv=none; b=SCPVyggYNnD6O5e/M0qZR65/XWj8Ou0VyNNzy5bM84BAYlwm2JNOikz3DSuvSMMENx715Z/L1lQeC1DfENnPF9KxZv4OAT5wFGre57SpmM54vg++fqGXAT+u1A6uhN1nF+HgUjmKfL4whcDjD6VzzQMhYvlr//Xyks90bDVCRak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178880; c=relaxed/simple;
	bh=IBvwCBLN/ASl6t8K6G888PmsCb0C7SnyYuUZ+ZW+6Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/77qkuh52dwW7ziwawc4/Xp5HS//20RfczSZCp3Rnipz3aHzDie6krfXBtEIimVHy1nnW0xsUplZk/iDn9SqElwaLcPl6BJ1HutMAq92W4W0jCmn1AatMNtAaYd0gTWoH1kozZtJF1HXiaiKuOgUhM7ZOP9/ZsKiMA4pvZeKxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kf5FkLLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kf5FkLLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D8DC4CEE3;
	Tue, 17 Jun 2025 16:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178880;
	bh=IBvwCBLN/ASl6t8K6G888PmsCb0C7SnyYuUZ+ZW+6Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kf5FkLLzX8B/xNgcCdb6YjXQ8bUKdFhw19on9qo9s7Sr80XhQqVtVe86chTLnxn7Y
	 RSGJxI/tKQx1zCoxj2C4P9FVCo+zYPDPDjnxVZMLwYZlZpHPL/LBKXTKezUSTuYrzd
	 6/bMQNCwYMBlJdudusu1piDe8wo/NRB2+qSHsbnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schrefl <chrisi.schrefl@gmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 540/780] rust: miscdevice: fix typo in MiscDevice::ioctl documentation
Date: Tue, 17 Jun 2025 17:24:08 +0200
Message-ID: <20250617152513.505821629@linuxfoundation.org>
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

From: Christian Schrefl <chrisi.schrefl@gmail.com>

[ Upstream commit 81e9edc1a8d657291409d70d93361d8277d226d8 ]

Fixes one small typo (`utilties` to `utilities`) in the documentation of
`MiscDevice::ioctl`.

Fixes: f893691e7426 ("rust: miscdevice: add base miscdevice abstraction")
Signed-off-by: Christian Schrefl <chrisi.schrefl@gmail.com>
Reviewed-by: Benno Lossin <lossin@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250517-rust_miscdevice_fix_typo-v1-1-8c30a6237ba9@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/miscdevice.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
index fa9ecc42602a4..15d10e5c1db7d 100644
--- a/rust/kernel/miscdevice.rs
+++ b/rust/kernel/miscdevice.rs
@@ -121,7 +121,7 @@ pub trait MiscDevice: Sized {
 
     /// Handler for ioctls.
     ///
-    /// The `cmd` argument is usually manipulated using the utilties in [`kernel::ioctl`].
+    /// The `cmd` argument is usually manipulated using the utilities in [`kernel::ioctl`].
     ///
     /// [`kernel::ioctl`]: mod@crate::ioctl
     fn ioctl(
-- 
2.39.5



