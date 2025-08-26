Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68957284B5B;
	Tue, 26 Aug 2025 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207964; cv=none; b=MfhbHBbptvzqvxbZAu6RCuX6fhioGuazK4hcWEuga4eQhwm+v86tz7qF/zjuMhLMxE7VJ5Yi8/b4be6kp9TLnNCk/vI5tQHRvmPp7SI/uzVLy8y3XXWCnCw9uHbNryzXNJSIhhNbMp4QnMJvF2uh4d3MKqFqgjKoPr+WWT4D+t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207964; c=relaxed/simple;
	bh=MPvLCWln+c8gFpQZz58uJAMOiI1yqOfOfytH70SeSXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foOf+bGhR/IytWGeXCEC/rzFfDhJXSYNt8Oizui0ZPJLFFKTrNJue1CeSGaan2JajZH31gxtXmzOnzliJ6lXBNmzKivGV3tutdZst2ILs0FtNIg248zUzGzLuShkEyZu2TrCVtdyn0Mtcu3iz1GEnCz2TcZgTf8aBHaKAw4KgHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhoL3y2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhoL3y2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4C3C16AAE;
	Tue, 26 Aug 2025 11:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207964;
	bh=MPvLCWln+c8gFpQZz58uJAMOiI1yqOfOfytH70SeSXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhoL3y2GANwyOZdpYnXhJO9zVQO/wWFYTGX5DcYbB+O8watqXHYLVar4kO+7rNWLO
	 UEx+CAJB/uPv5vK/hOksJrJ2CBpqcjvgCMjN+Uas3LxW2xOLtML/rK5cvOhcADNZ0O
	 aGtlSy2FUcXWwCPLR72tFy64SR1pwvsEJycQxoR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 354/457] rust: drm: remove pin annotations from drm::Device
Date: Tue, 26 Aug 2025 13:10:38 +0200
Message-ID: <20250826110946.067905460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 0c04a81c1d0214d5b2025f805ccec1ac37c96b08 ]

The #[pin_data] and #[pin] annotations are not necessary for
drm::Device, since we don't use any pin-init macros, but only
__pinned_init() on the impl PinInit<T::Data, Error> argument of
drm::Device::new().

Fixes: 1e4b8896c0f3 ("rust: drm: add device abstraction")
Reviewed-by: Benno Lossin <lossin@kernel.org>
Link: https://lore.kernel.org/r/20250731154919.4132-4-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/drm/device.rs | 2 --
 1 file changed, 2 deletions(-)

diff --git a/rust/kernel/drm/device.rs b/rust/kernel/drm/device.rs
index 6c1fc33cdc68..cb6bbd024a1e 100644
--- a/rust/kernel/drm/device.rs
+++ b/rust/kernel/drm/device.rs
@@ -54,10 +54,8 @@ macro_rules! drm_legacy_fields {
 ///
 /// `self.dev` is a valid instance of a `struct device`.
 #[repr(C)]
-#[pin_data]
 pub struct Device<T: drm::Driver> {
     dev: Opaque<bindings::drm_device>,
-    #[pin]
     data: T::Data,
 }
 
-- 
2.50.1



