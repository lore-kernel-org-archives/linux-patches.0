Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A512309B1;
	Mon, 10 Mar 2025 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626489; cv=none; b=XpUUr1CDWyuw1LzbA3qLh3y2Kn5CtNuS+I3tATLIDpvxVIGpRh3PNNsf7uMgjn9rcxA0EpUdsHiwriFia9qzf8yWWp6PWaGelhVfleZb9mavR2e3eKmVfqjfQZ6J+2hVHRq/SYp51p721WEKaemzhbHsnPx2wcOpjbUMiYYLoXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626489; c=relaxed/simple;
	bh=Ix1aJVExGawJ3l5bD+Bi+7m2ITSCP5bIlGi+ZuIR25Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/1D3vM1ONkkUXAFmP+ow4zqNyxRbthb1TkqzaZyw9qaXYD0US5a2DhjKl7un6w/fvjMGTvl2kF2hgap8e1l+sKHE8zZr28eaN5fEjKCQdT4eUNZa4xmvNghiPQlQenLUqTqxeXPATQG8N/yxWAI487hveCNwS9W2Kcy+bm8OTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiA37R46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiA37R46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D31C4CEE5;
	Mon, 10 Mar 2025 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626488;
	bh=Ix1aJVExGawJ3l5bD+Bi+7m2ITSCP5bIlGi+ZuIR25Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiA37R46aA4M3hvQc3Qm5PrOsKbkS7GYi50WJScjkLsy7RGfc8AVZq4AwPnn7KSBi
	 ThAXPLWd+ryNxrQ/j+tO4SGqezWJH7eV4dl7qnG+Rz92kDqjXP7Vxtk25FIEJmmmGR
	 hOXe+gioBlJb869EmIJnrjZKu38x0zF3Ha9xvlAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yutaro Ohno <yutaro.ono.418@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.13 002/207] rust: block: fix formatting in GenDisk doc
Date: Mon, 10 Mar 2025 18:03:15 +0100
Message-ID: <20250310170447.844477981@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


