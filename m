Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C403175A62;
	Sat, 28 Feb 2026 17:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301422; cv=none; b=N3CHJaNNCNg+tH/19hsNC5QCEsUsdXfXOqj8CoUwngtUE+pwhavS7vsjIIdEa7hAbNDX04yz8Outy1BmEvaL/ySLNOjIUrJnX2SIHynJigg24o5tZZnFa6IOBRpVVkIKFLlFQgwrS/NII/k8ioFO5tse0m4rI09QZgWfPa0y4pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301422; c=relaxed/simple;
	bh=L6aT3qUTLfThn9I6bCBDwQlKHAfnFbemVlPtE+jyx9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMpJJBVNMzt3mdtpib2QH1eglXjl3aC58WXtcqZ+ztbmGRInsoKE6PJ66CMfhCXjOFtApeKp7MvxTEMXKaQKor1zvScePy/mBpmZxOyfo6g3ihg6tutPyUM470Ld6ISVJy2ip0JswGy+OJuO/wWMzGV2mZFqtEG+vH010UP7D5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjXFzBxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjXFzBxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BA1C19423;
	Sat, 28 Feb 2026 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301422;
	bh=L6aT3qUTLfThn9I6bCBDwQlKHAfnFbemVlPtE+jyx9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjXFzBxsFab9NjDzN/4oL44xtChjynTdNLhqE+YJ/ldkMrcnHfXlJo8vn+q5epNfF
	 8JoKJ8RtteykHOFWnEPfpaMRxaKerMURT3wq9n36HHLYlld5PkROE40nTnaDoqM9tv
	 HKH7TYEt0IcQEcvUttvwfwMdcjEOWZ0zVNKoEOdChVaE48kOUO1o1t3ODLU1H1suDi
	 LGKthVFvxsxUG0v7B9BcFn3SaLZHcJDRDKMNSuDyl6qviKBwgMKx+m4WSCmGH437JD
	 PXofPlu/tZhBZKSbazisCjpL7QVIa5Nhrhqc7mznxtPMQcuknWDMcvC8oK0IACCM91
	 GRDJcyvfoyNjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 612/752] rust/drm: Fix Registration::{new,new_foreign_owned}() docs
Date: Sat, 28 Feb 2026 12:45:23 -0500
Message-ID: <20260228174750.1542406-612-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lyude Paul <lyude@redhat.com>

[ Upstream commit 638eeda8abaa3e6afe6bd5758ef8045a7f33b9a0 ]

Looks like we've actually had a malformed rustdoc reference in the rustdocs
for Registration::new_foreign_owned() for a while that, when fixed, still
couldn't resolve properly because it refers to a private item.

This is probably leftover from when Registration::new() was public, so drop
the documentation from that function and fixup the documentation for
Registration::new_foreign_owned().

Signed-off-by: Lyude Paul <lyude@redhat.com>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Fixes: 0600032c54b7 ("rust: drm: add DRM driver registration")
Cc: <stable@vger.kernel.org> # v6.16+
Link: https://patch.msgid.link/20260122221037.3462081-1-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/drm/driver.rs | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/drm/driver.rs b/rust/kernel/drm/driver.rs
index f30ee4c6245cd..e09f977b5b519 100644
--- a/rust/kernel/drm/driver.rs
+++ b/rust/kernel/drm/driver.rs
@@ -121,7 +121,6 @@ pub trait Driver {
 pub struct Registration<T: Driver>(ARef<drm::Device<T>>);
 
 impl<T: Driver> Registration<T> {
-    /// Creates a new [`Registration`] and registers it.
     fn new(drm: &drm::Device<T>, flags: usize) -> Result<Self> {
         // SAFETY: `drm.as_raw()` is valid by the invariants of `drm::Device`.
         to_result(unsafe { bindings::drm_dev_register(drm.as_raw(), flags) })?;
@@ -129,8 +128,9 @@ impl<T: Driver> Registration<T> {
         Ok(Self(drm.into()))
     }
 
-    /// Same as [`Registration::new`}, but transfers ownership of the [`Registration`] to
-    /// [`devres::register`].
+    /// Registers a new [`Device`](drm::Device) with userspace.
+    ///
+    /// Ownership of the [`Registration`] object is passed to [`devres::register`].
     pub fn new_foreign_owned(
         drm: &drm::Device<T>,
         dev: &device::Device<device::Bound>,
-- 
2.51.0

