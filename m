Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380EB15ADB4;
	Thu, 19 Feb 2026 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466665; cv=none; b=M6ZRFTIKqTXwlpclWYJlheg+sPjI9dqt9ilqfkYKbdzlyFiuuPfoBk1NTzpgIypSZJVqPV5TQSzVLZjT1+MyzrEE72+/iWPtGlFD+AJ5kQbE9gFA890tkAJptkWuwvHpvA/lVgtMuFcOIz0N0JkWc9M0TE4cBARk2JNZ3bg11+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466665; c=relaxed/simple;
	bh=YiI0Gom/A99ZV86esIVmUa1IM1DN4h2Z5lqqLo8Dx0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dfD6fu8GwOtphv1xoPgnTLCmlHYPF9awbG4jNPU/UpiLn/My2/TuWaEXDOwwNLkexHCPpSJz9IrbhphXUO0wkE7tBFp2iC1/pbpUVZhPl4loSLtFhGLRI3KGuAgt03yt7gYHd1ckM1C2QptcBdq++nTTassGB0sw8E7FwX2a564=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cvpMeuWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvpMeuWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E97C19422;
	Thu, 19 Feb 2026 02:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466664;
	bh=YiI0Gom/A99ZV86esIVmUa1IM1DN4h2Z5lqqLo8Dx0Y=;
	h=From:To:Cc:Subject:Date:From;
	b=cvpMeuWHkAb0ksaEA8DsHz/IuRzB9wNV/M4wi2Quswzehs3VV3/IUrR2Jd5H/2sDV
	 /ZY4KdolVpJXNrKbCXWxh382CbcWdSRkC9D+os/pTIObQ8BzDXzV6NAWSxb/7KWi75
	 Jq11ktXOERSJES3HvjZ4DXQJzi7HLr7J9TQV3noAeFtGeW78Yz/3s9xgqAW1iD9NiV
	 aVrJOB11vxpfn/qO5SC5n07u9d2MgLciZG4EbLZyQwZfQeifkIgpV9XgRcp+q2K6C3
	 YB/+7NHFsIHjiiSHEyxQg36fRPAuI9EU/ao4HgOCFKVMzN31YI9bXYpQfDfjADYNsn
	 4LmGU6i+mIs/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xi Ruoyao <xry111@xry111.site>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	arve@android.com,
	tkjos@android.com,
	cmllamas@google.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] rust_binder: Fix build failure if !CONFIG_COMPAT
Date: Wed, 18 Feb 2026 21:03:37 -0500
Message-ID: <20260219020422.1539798-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Xi Ruoyao <xry111@xry111.site>

[ Upstream commit 174e2a339bf731e080ced67c215ad609a677560b ]

The bindgen utility cannot handle "#define compat_ptr_ioctl NULL" in the
C header, so we need to handle this case on our own.

Simply skip this field in the initializer when !CONFIG_COMPAT as the
SAFETY comment above this initializer implies this is allowed.

Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Closes: https://lore.kernel.org/all/CANiq72mrVzqXnAV=Hy2XBOonLHA6YQgH-ckZoc_h0VBvTGK8rA@mail.gmail.com/
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251209125029.1117897-1-xry111@xry111.site
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Confirmed: v6.19.2 has the `compat_ptr_ioctl` usage but does NOT yet
have the `#[cfg(CONFIG_COMPAT)]` fix. This means **v6.19.x stable is
affected by the build failure when CONFIG_COMPAT is not set**.

## Classification

This is a **build fix** - one of the explicitly allowed categories for
stable backporting. Without this fix, the kernel cannot be compiled with
the Rust Binder driver enabled on configurations where `CONFIG_COMPAT`
is disabled. This is a real build failure affecting real configurations.

## Scope and Risk

- **Change size**: 1 line added (`#[cfg(CONFIG_COMPAT)]`)
- **Risk**: Extremely low. When CONFIG_COMPAT is enabled, behavior is
  identical. When disabled, the field defaults to zero (NULL), which is
  the correct behavior matching what the C equivalent would produce.
- **The SAFETY comment** in the code explicitly states that zeroed
  fields are safe for `file_operations`.

## Verification

- **git log** showed `drivers/android/binder/rust_binder_main.rs` was
  introduced by commit `eafedbc7c050c` during v6.18-rc cycle (v6.17-rc3
  + 103 commits)
- **git describe** confirmed `d4b83ba11cf22` (the compat_ptr_ioctl
  change that introduced the bug) was at v6.18-rc3 + 277 commits
- **git log v6.19.2 --grep** confirmed `d4b83ba11cf22` IS in v6.19.2
  stable
- **git log v6.18.12 --grep** confirmed `d4b83ba11cf22` is NOT in
  v6.18.12 stable (so 6.18.x is unaffected)
- **git show v6.19.2:...** confirmed v6.19.2 has the buggy
  `compat_ioctl: Some(bindings::compat_ptr_ioctl)` line without the
  `#[cfg(CONFIG_COMPAT)]` guard
- **git show v6.18.12:...** confirmed v6.18.12 uses a different approach
  (`rust_binder_compat_ioctl`) not affected by this bug
- The commit has `Reviewed-by: Alice Ryhl` (the Rust Binder maintainer)
  and was merged by Greg KH
- The lore.kernel.org link in the commit confirms the build failure was
  reported by Miguel Ojeda

## Summary

This is a minimal, single-line build fix for the Rust Binder driver in
v6.19.x stable. It fixes a real build failure when `CONFIG_COMPAT` is
not enabled, caused by bindgen's inability to handle `#define
compat_ptr_ioctl NULL`. The fix is obviously correct (zeroed default is
safe and matches intended C behavior), reviewed by the subsystem
maintainer, and has zero risk of runtime regression. Build fixes are
explicitly called out as stable-appropriate in the stable kernel rules.

The only applicable stable tree is v6.19.x (the bug-introducing commit
`d4b83ba11cf22` is not in v6.18.x). The fix applies cleanly.

**YES**

 drivers/android/binder/rust_binder_main.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/android/binder/rust_binder_main.rs b/drivers/android/binder/rust_binder_main.rs
index c79a9e7422401..9a527268f5b45 100644
--- a/drivers/android/binder/rust_binder_main.rs
+++ b/drivers/android/binder/rust_binder_main.rs
@@ -314,6 +314,7 @@ unsafe impl<T> Sync for AssertSync<T> {}
         owner: THIS_MODULE.as_ptr(),
         poll: Some(rust_binder_poll),
         unlocked_ioctl: Some(rust_binder_ioctl),
+        #[cfg(CONFIG_COMPAT)]
         compat_ioctl: Some(bindings::compat_ptr_ioctl),
         mmap: Some(rust_binder_mmap),
         open: Some(rust_binder_open),
-- 
2.51.0

