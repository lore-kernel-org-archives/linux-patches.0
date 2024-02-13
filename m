Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851F15F54E;
	Tue, 13 Feb 2024 17:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845307; cv=none; b=ATF32bcusIiwz27r0iD15PkFosnALBQ67dc9nHbxd3mPvpYzkMpL8VXVfCgrubh3ib1K0TN8++KBSJY9gis791L1bFz+JYRa4DMAZgVrjsVinDkZsgKQNWotFx1bMDXRWJ+oOs+XS/tTEVkVXy6aCkdhm7+LqfBCjQCCAvXv/dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845307; c=relaxed/simple;
	bh=BBSQ/eHvVArxJhGZ5GQD+xUqLT4XXfMWcno2775/+Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkjT3vfltqTfLxweLBtriOGiFtrtM0CoqHc56Auaazcd9Uo3il5KIs6ZMm4NzmOO77SsuT51yNbECGMahWK9G4+i8CwSiWr0hMEB49sFfNEVLIg/jPFq9MpKQP8vkIiMazknXdjVH9TnVlX1KCUWiQctynCVEWDMOnr3NdcFYfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRe9YC/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRe9YC/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC38C433F1;
	Tue, 13 Feb 2024 17:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845307;
	bh=BBSQ/eHvVArxJhGZ5GQD+xUqLT4XXfMWcno2775/+Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRe9YC/w9b2vfddLHEcNk5ZuRMwztp1DlaPMbW5VPHFw7L7fiBGhvvLJdVFNet/Lq
	 yi9NWiouclCQE9VJs3kJ9rIm6LK7IMUnfryrnVAySVR92Y3r4UTBlhNd0LORKGUCz8
	 f/o87zaBN8LSfG4It9/O0ajNnfap+ZnSFXHLtfRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Finn Behrens <me@kloenk.dev>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 015/121] rust: print: use explicit link in documentation
Date: Tue, 13 Feb 2024 18:20:24 +0100
Message-ID: <20240213171853.415375973@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

commit a53d8cdd5a0aec75ae32badc2d8995c59ea6e3f0 upstream.

The future `rustdoc` in the Rust 1.73.0 upgrade requires an explicit
link for `pr_info!`:

    error: unresolved link to `pr_info`
       --> rust/kernel/print.rs:395:63
        |
    395 | /// Use only when continuing a previous `pr_*!` macro (e.g. [`pr_info!`]).
        |                                                               ^^^^^^^^ no item named `pr_info` in scope
        |
        = note: `macro_rules` named `pr_info` exists in this crate, but it is not in scope at this link's location
        = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`

Thus do so to avoid a broken link while upgrading.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Reviewed-by: Finn Behrens <me@kloenk.dev>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Link: https://lore.kernel.org/r/20231005210556.466856-3-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/print.rs |    1 +
 1 file changed, 1 insertion(+)

--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -399,6 +399,7 @@ macro_rules! pr_debug (
 /// Mimics the interface of [`std::print!`]. See [`core::fmt`] and
 /// `alloc::format!` for information about the formatting syntax.
 ///
+/// [`pr_info!`]: crate::pr_info!
 /// [`pr_cont`]: https://www.kernel.org/doc/html/latest/core-api/printk-basics.html#c.pr_cont
 /// [`std::print!`]: https://doc.rust-lang.org/std/macro.print.html
 ///


