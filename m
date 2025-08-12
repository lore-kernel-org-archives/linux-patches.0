Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D75B1EF38C;
	Tue, 12 Aug 2025 18:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023443; cv=none; b=E/Rf1Ff8c0SEwSBarpwMSVn78NdNq6P26cLHA3dDz4FF99pZQLhWDHxfVqj7WWr1LWAGvLuxotFx3qpNbU/Xlrk2orSJGt0nyNJkh2qAHoKhvsZQR6niZ3OfpgLT320xPF4NYC+EnIx2cpcN5Zb3Y2z9CJEUR8PIROo/EZ2FQcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023443; c=relaxed/simple;
	bh=AvYCfMcBencV3esKvdMQbXB/UInFP4XUJ62zWCIefzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SilJJe2VUf6gM1nKkKQvA+xNA2lfKDSNFLprb1a5OgIGrS4sk4M9jXZfy52c9scAh3SYtEByLXqCSSdv2wbpiImR+kBfkTU//C/K+qMuRe+FDnI5I0DgGT2Z1y5mBWbUW+msoImNHlj+9BQaVLkE4hFgRtXK0rkMUVqHCwH3Ijs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cT7uO2v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cT7uO2v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F83C4CEF6;
	Tue, 12 Aug 2025 18:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023443;
	bh=AvYCfMcBencV3esKvdMQbXB/UInFP4XUJ62zWCIefzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cT7uO2v3TVwEnerfF5GcAXShvxzzkU6Z/IsxETX1+MDsSANue6tveXIpIkPD1+YDE
	 2WzIJNCjtglz8h6B9nE7ISIVN/orAN2aJ2DXOBIQfjjX8s8cdmHh0YRoKXAcd+/q2V
	 H/sOxK4Xd4w0JgWY/3f13HykD2UkoiLGe9QseVIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>,
	Shankari Anand <shankari.ak0208@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 081/627] rust: miscdevice: clarify invariant for `MiscDeviceRegistration`
Date: Tue, 12 Aug 2025 19:26:16 +0200
Message-ID: <20250812173422.388218072@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 939278bc7b03..4f7a8714ad36 100644
--- a/rust/kernel/miscdevice.rs
+++ b/rust/kernel/miscdevice.rs
@@ -45,7 +45,13 @@ pub const fn into_raw<T: MiscDevice>(self) -> bindings::miscdevice {
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



