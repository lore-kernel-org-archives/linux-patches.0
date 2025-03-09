Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC4B160783;
	Sun,  9 Mar 2025 20:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741552956; cv=none; b=h71wcB/tmOXDxIIlWbXYj//Ro7HMdGZli3jUfQCENHwWQIpEKygbxhG0vujUqzpkDpf8lVLEInXAUZt4/Vpixb4vdOqKaTwaWmSnROR+puMMtAfVSlig1guFjDsiDnGCkFjQMsbBZtpSD78mnQdzCCK1t476z0Ur5N19304kWhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741552956; c=relaxed/simple;
	bh=jmee3ccXe6iJANBLGrFii7Gy5ZmU36sbL32fmuWP4+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGcBYVXL5qayWCxk8OBZ8bKncfmaMDs5a1SzckPERvNGhYRkONwqV/hoo4tmkASLYw5QSlReBxp5tx3wIgs/XhXKv4FjvujCeVA6mf2B4T1GPh0vwe1/CNFBYFDZwlY4ZOWNiAf/7J/jXA/fCyIAgeUDsWyZU+cAsZSDVywkaQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HCfVi79p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HCfVi79p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF12C4CEEB;
	Sun,  9 Mar 2025 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741552954;
	bh=jmee3ccXe6iJANBLGrFii7Gy5ZmU36sbL32fmuWP4+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCfVi79pjaecVR6G+c+udg/LkZfLrOFBIOb0fg8MbjtNaKF5aAUmkx4N2vbBwrti1
	 jjZ73vvZY3Zv/3HHZ23no9QgoI3rAcfGViuHKPn9q5NJtjFBNzrn8VIMponnT6Zvr/
	 gB9sPaLrDTXjp1Sgud3mMnb7LiK6GT9e2xyy+XapwNDlbuOJ6FFZGsq5NQf1FFDHuL
	 J5eZqYf8ZChPRJV+iP9dW3a/+mG9czIYiS0FxBpX8YqLldI6jO/fviP5jdHwp1GGBo
	 saDGFAAv4shbQ4hHnQylMeusx00TOFtFCmTGAU1xN/Krig+zqmOyYeP6nRugSnC6WB
	 nl8SoJxiFZVeA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 1/2] rust: finish using custom FFI integer types
Date: Sun,  9 Mar 2025 21:42:16 +0100
Message-ID: <20250309204217.1553389-2-ojeda@kernel.org>
In-Reply-To: <20250309204217.1553389-1-ojeda@kernel.org>
References: <2025030955-kindness-designing-246c@gregkh>
 <20250309204217.1553389-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 27c7518e7f1ccaaa43eb5f25dc362779d2dc2ccb upstream.

In the last kernel cycle we migrated most of the `core::ffi` cases in
commit d072acda4862 ("rust: use custom FFI integer types"):

    Currently FFI integer types are defined in libcore. This commit
    creates the `ffi` crate and asks bindgen to use that crate for FFI
    integer types instead of `core::ffi`.

    This commit is preparatory and no type changes are made in this
    commit yet.

Finish now the few remaining/new cases so that we perform the actual
remapping in the next commit as planned.

Acked-by: Jocelyn Falempe <jfalempe@redhat.com> # drm
Link: https://lore.kernel.org/rust-for-linux/CANiq72m_rg42SvZK=bF2f0yEoBLVA33UBhiAsv8THhVu=G2dPA@mail.gmail.com/
Link: https://lore.kernel.org/all/cc9253fa-9d5f-460b-9841-94948fb6580c@redhat.com/
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index ef2d490965ba..bcf248f69252 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -931,7 +931,7 @@ fn draw_all(&mut self, data: impl Iterator<Item = u8>) {
 /// They must remain valid for the duration of the function call.
 #[no_mangle]
 pub unsafe extern "C" fn drm_panic_qr_generate(
-    url: *const i8,
+    url: *const kernel::ffi::c_char,
     data: *mut u8,
     data_len: usize,
     data_size: usize,
-- 
2.48.1

