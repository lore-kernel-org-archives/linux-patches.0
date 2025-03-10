Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D697B2F28;
	Mon, 10 Mar 2025 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627089; cv=none; b=HX3TQM4DRPUlEzK8QcaL6XjHggrKUxqUiO/DjkC/JT+1mgOe0v5BUdWWJQoMhavMuAr0t/1qxPkeGmE59nrZsh66q6d0q5d3xoWxHwBak9XAQYUJ09/1Yp9fHxd+aEYGh5pkLHXhWpP4pFdqg9Z1eGHJhYtzzVV/zDNN2HEjXlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627089; c=relaxed/simple;
	bh=lJJOa9Gv76m892YY+DKBJ5CUk43bO3IopUie60mpLvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1piJqwMgmi3B1QNTiFCY7445sqLirMAHxd5RiGX0cRqThJuRHeflskEMNcM6DM4eU6JqXmR9vZG+K9EBvM2fc0EcIAoWuHgoLwvLed0qBWoyoxNH0nWDVaTugUBz2mfZ5Go2xvNd6PQWaPT0FaCbpHtiYZgLsMrRv6xFfEwv5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DN0alma1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DN0alma1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C852C4CEE5;
	Mon, 10 Mar 2025 17:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627089;
	bh=lJJOa9Gv76m892YY+DKBJ5CUk43bO3IopUie60mpLvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DN0alma1+hyOEwlVYTAjaDG51lW9vGD97Qoh5f8s6xb4bkyJ8ZjpWdx2CRBE22B6e
	 mClwDGWsKc/NGQKtuffLC5lioqrorysfr2zekVnsteHHmjBq/cfrJTl82cboUdn9WV
	 iw/ZvkeaSdMatxURnEC2su/Fl3Sh0n3Q+BAvqR8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yutaro Ohno <yutaro.ono.418@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 002/269] rust: block: fix formatting in GenDisk doc
Date: Mon, 10 Mar 2025 18:02:35 +0100
Message-ID: <20250310170457.801582266@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yutaro Ohno <yutaro.ono.418@gmail.com>

commit 0c5928deada15a8d075516e6e0d9ee19011bb000 upstream.

Align bullet points and improve indentation in the `Invariants` section
of the `GenDisk` struct documentation for better readability.

[ Yutaro is also working on implementing the lint we suggested to catch
  this sort of issue in upstream Rust:

    https://github.com/rust-lang/rust-clippy/issues/13601
    https://github.com/rust-lang/rust-clippy/pull/13711

  Thanks a lot! - Miguel ]

Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
Signed-off-by: Yutaro Ohno <yutaro.ono.418@gmail.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Acked-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://lore.kernel.org/r/ZxkcU5yTFCagg_lX@ohnotp
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/block/mq/gen_disk.rs |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -174,9 +174,9 @@ impl GenDiskBuilder {
 ///
 /// # Invariants
 ///
-///  - `gendisk` must always point to an initialized and valid `struct gendisk`.
-///  - `gendisk` was added to the VFS through a call to
-///     `bindings::device_add_disk`.
+/// - `gendisk` must always point to an initialized and valid `struct gendisk`.
+/// - `gendisk` was added to the VFS through a call to
+///   `bindings::device_add_disk`.
 pub struct GenDisk<T: Operations> {
     _tagset: Arc<TagSet<T>>,
     gendisk: *mut bindings::gendisk,


