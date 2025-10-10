Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7B221579F;
	Fri, 10 Oct 2025 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102470; cv=none; b=pWh0mzZam+f/YcWAElspsn0+MsQ+FW+ezqCVLG7Yvza5mPPPeUYssOEHP0PntWmnCfz5fO193pI93UFj7w8xOYCdOjmavSRQeymA/QtO6YefgB5+Qhd6sMWdvsy5CsVQd0A94WY4b/CKf9G15ZWjJxRPEhnE8beoBalGU58dFuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102470; c=relaxed/simple;
	bh=TxiKniTyShNILoPK20mnLiWZyUgGLAGdOkY0dmVB1Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaZsgeOk/EurA4PJGjdIhquztIBC74wYUncBD5V7JOsVy9A6YpRoeLE1dbd+pwm9QktD3KG8Xh+IMc7e4sQiu32pBGXYO2gPwO8noNVZ6aI+KQv6QvEwFmM+l2T3v4xUNP0gIiVrNNen+VYvlsZFcUrxAUuOgqvmyT3gxGHEFME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUy2Se/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUy2Se/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D75C4CEF1;
	Fri, 10 Oct 2025 13:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102470;
	bh=TxiKniTyShNILoPK20mnLiWZyUgGLAGdOkY0dmVB1Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUy2Se/HQeHbTRIRPEtk9NaqquSPmCsi0g9lce3ponVWQO7CdjngBzDnveTxPjyXt
	 YKMYsy+CuLQd2S2RKJprJ7O0mgc5cN9OQ+OmpsVAwx0+S34bllt83VWecwOQR+ANMt
	 XUPzWkksNT1OT1BVRZf+EPpwAfVHD9Gq/pl88vCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 07/35] rust: block: fix `srctree/` links
Date: Fri, 10 Oct 2025 15:16:09 +0200
Message-ID: <20251010131332.059379765@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Miguel Ojeda <ojeda@kernel.org>

commit 208d7f788e84e80992d7b1c82ff17b620eb1371e upstream.

This `srctree/` link pointed to a file with an underscore, but the header
used a dash instead.

Thus fix it.

This cleans a future warning that will check our `srctree/` links.

Cc: stable@vger.kernel.org
Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.51.0



