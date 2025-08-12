Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119A8260583;
	Tue, 12 Aug 2025 19:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025514; cv=none; b=J4/F9Bznk3h7Fv4ZK0wkOKdcSAD51odVmjdU9TRvNSwoUKxsosNJNj2wIio6NFKS+vn/rt7I6HJundUke+bxQkGWZvCLXQvtYiw/3WKyuU674kBAKj45fllOfCwFoDgSpQaBBoY2AiYjlX3OquXyZfKh9Hx6IYdUntjbHsMiVyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025514; c=relaxed/simple;
	bh=6uLJhhlkLzu4VVaXOWkIM6CubXPPzf5ENyaRs6WbS4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1YRGk8RR+dWPtvX6w7jfx9qnwq1U+aeQ8z5mOocCgtRGUpmEQoTAI2HcTR4QJ2x4ouYGAZHd8KxERvikRc1Y/BVJMr/l+10b+n+1n3bw9USCAejy/u4EuwbgxRF75NxnTAOUqGH7k0Yf48Tl+EaWS/9puwI6CIPjxC19Da5Ngw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTUm7QC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTUm7QC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F6CC4CEF0;
	Tue, 12 Aug 2025 19:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025513;
	bh=6uLJhhlkLzu4VVaXOWkIM6CubXPPzf5ENyaRs6WbS4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTUm7QC6I8hlx4uSzR50wx+9hjXsctoKluseVh0aTJZBbk/+pQ0+339BWfax/TIEi
	 cvG00z9Kqslb34eDjrLri1EVUnKUVS7PugZOA7uBiS0EYyPaHDH3bYCypM0L5G9N2F
	 QIQ/+FDfxYe7yVZbDvus6qE5J/1sWWwD1qYtDkxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>,
	Shankari Anand <shankari.ak0208@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 063/480] rust: miscdevice: clarify invariant for `MiscDeviceRegistration`
Date: Tue, 12 Aug 2025 19:44:31 +0200
Message-ID: <20250812174400.022707276@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Shankari Anand <shankari.ak0208@gmail.com>

[ Upstream commit b9ff1c2a26fa31216be18e9b14c419ff8fe39e72 ]

Reword and expand the invariant documentation for `MiscDeviceRegistration`
to clarify what it means for the inner device to be "registered".
It expands to explain:
- `inner` points to a `miscdevice` registered via `misc_register`.
- This registration stays valid for the entire lifetime of the object.
- Deregistration is guaranteed on `Drop`, via `misc_deregister`.

Reported-by: Benno Lossin <lossin@kernel.org>
Closes: https://github.com/Rust-for-Linux/linux/issues/1168
Fixes: f893691e7426 ("rust: miscdevice: add base miscdevice abstraction")
Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
Link: https://lore.kernel.org/r/20250626104520.563036-1-shankari.ak0208@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/miscdevice.rs | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/miscdevice.rs b/rust/kernel/miscdevice.rs
index 15d10e5c1db7..188ae10d3319 100644
--- a/rust/kernel/miscdevice.rs
+++ b/rust/kernel/miscdevice.rs
@@ -44,7 +44,13 @@ pub const fn into_raw<T: MiscDevice>(self) -> bindings::miscdevice {
 ///
 /// # Invariants
 ///
-/// `inner` is a registered misc device.
+/// - `inner` contains a `struct miscdevice` that is registered using
+///   `misc_register()`.
+/// - This registration remains valid for the entire lifetime of the
+///   [`MiscDeviceRegistration`] instance.
+/// - Deregistration occurs exactly once in [`Drop`] via `misc_deregister()`.
+/// - `inner` wraps a valid, pinned `miscdevice` created using
+///   [`MiscDeviceOptions::into_raw`].
 #[repr(transparent)]
 #[pin_data(PinnedDrop)]
 pub struct MiscDeviceRegistration<T> {
-- 
2.39.5



