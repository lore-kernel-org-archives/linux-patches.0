Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256792F3C2D;
	Fri, 10 Oct 2025 13:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102305; cv=none; b=FO7FqAHr7Dqu/4W0hLsUGtXvZqbircChlGMeliJrClMLoDM8mNkbQUP5ZkJBKFQegMBDX1A6jYGHHT+puRpG0WH1ez+0AHiInYeRuOVh/rDwDkx6q0KEcYRIsCc4KGTvYl8EwSerObejfK7iuUJmseTt4iiNrW0MldC+cvSflFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102305; c=relaxed/simple;
	bh=v0ym/9DXTK9zq/kctuk9Inz48kdTAO9oz4qm2/TSkXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5ltcsA56dz8GYZx4sSpTPBWjpz1Wgn86/pkIHBlE2CCX+1eKVq/aBCfqXwVqSRFKgL6pRCsJG/A39Wb+rJrZuHXqJhHKB8/VWhmlS0sUHkpBatsGf40ou5INaoNzNJ4w+i5W+9dMyeqc+pFVwmKhuCBAWYJkdc5YoZlYvnarsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeaAfxft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeaAfxft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2176C4CEF9;
	Fri, 10 Oct 2025 13:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102305;
	bh=v0ym/9DXTK9zq/kctuk9Inz48kdTAO9oz4qm2/TSkXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeaAfxftuZ5MKkzhtDE6K4AquDSCRJjBqqTDckO2jM756PYbZAIjEitU//7r5W9FN
	 0Ug2AgOAbmcG9+NjKe7j0W1vJOLLZaYMasJ7HWDWgeR99EvyPANWVyf0uNwkLWpS5p
	 XdtxUnaBpp7YW9aJuqhFe4YJee+YgvqAUVll1RBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.16 10/41] rust: block: fix `srctree/` links
Date: Fri, 10 Oct 2025 15:15:58 +0200
Message-ID: <20251010131333.797450620@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 rust/kernel/block/mq/gen_disk.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


