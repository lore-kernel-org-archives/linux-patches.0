Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093EF86338;
	Wed, 30 Jul 2025 13:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753880853; cv=none; b=hZLoxruh/BAcEa940vdn+PhTMLGV6ycO+saIOA95B6VPUi5SE44JW6YGtWk5sL3F11D3Lc99B+FXs5fGtU1wTkQKgUzWQG423Ael2PVanjraIR3NdrUU90330Sbqp0Hb9NSMJ3TufL1zYoSTcMuKWuxQAMj5nh0EBvvbfYtjFMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753880853; c=relaxed/simple;
	bh=pxUeJv29yRg6Dx7iPk1Ji2QVfn9F9xAJgdgxpSSJiqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tExM09ITE+pATBBBdGKMi7wd2FhgRIP0Dc7E4+Q4IykikTHhL1aduB1idL8BDf4KPaJkzgT1S1IBspaDL7NuMWgAmcNc2YwcDTkqFqXIDykWW4QKDrxT42GVvdCAjaH+F2+N4tHpAh+joePD/bR1nrbqM/4QFsEP9Mo4P16LDFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DR8jBGJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DR8jBGJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2909BC4CEF6;
	Wed, 30 Jul 2025 13:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753880852;
	bh=pxUeJv29yRg6Dx7iPk1Ji2QVfn9F9xAJgdgxpSSJiqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DR8jBGJ/KsozFTtd9LNrKeQK8dpxYwyg23wiKvPFMDGFGh9C+74tsr8/hoz6iPAc1
	 IYwmcYgd7iqjpW31MV/H9gXtTZhYlVTNcBEwi2IwBCUo5Je61Eq2lmojumgMx8naZo
	 mbWQXxTK8AdmZSpTZ83ddmdURTVIsBGmEFEw5Jb8lRGtdqipQmV2dsq19tydBFyUCp
	 N2MnJueXLfT8wKpdwyJpM/AoSgkFrnu960kO1YNF+evu6MwJNVI17l2vbvfDPg2Zdj
	 URVvZ3aUYG/E8LeumNfLjBnV3HZpUhzzVAJtf917AiTzfJiYaEM3Oe8ahkClNZMhna
	 O5RyRRymlOHuw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/3] rust: block: fix `srctree/` links
Date: Wed, 30 Jul 2025 15:07:14 +0200
Message-ID: <20250730130716.3278285-2-ojeda@kernel.org>
In-Reply-To: <20250730130716.3278285-1-ojeda@kernel.org>
References: <20250730130716.3278285-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This `srctree/` link pointed to a file with an underscore, but the header
used a dash instead.

Thus fix it.

This cleans a future warning that will check our `srctree/` links.

Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index cd54cd64ea88..e1af0fa302a3 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -3,7 +3,7 @@
 //! Generic disk abstraction.
 //!
 //! C header: [`include/linux/blkdev.h`](srctree/include/linux/blkdev.h)
-//! C header: [`include/linux/blk_mq.h`](srctree/include/linux/blk_mq.h)
+//! C header: [`include/linux/blk-mq.h`](srctree/include/linux/blk-mq.h)
 
 use crate::block::mq::{raw_writer::RawWriter, Operations, TagSet};
 use crate::{bindings, error::from_err_ptr, error::Result, sync::Arc};
-- 
2.50.1

