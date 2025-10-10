Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3C11F63FF;
	Fri, 10 Oct 2025 13:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102252; cv=none; b=qFG1gxWIhHnN+wSqeLfX0Hw9VbMAlqwTJmNlmop7eedqfdCVV0diccmnGGA1SdWuWs06ZnxqAQc06EHMTRbnnZxFJfO5HGDUqva3q+01lO6QouITezu5E9uVMmMqwXYPgQGcXibVAAwOQwl86U0nckI8iBH/RBgq80fMPG/jFNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102252; c=relaxed/simple;
	bh=NN7AHrie72/4YnSrW/gJfkoI52/BNrwbnDjXpBJP6Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLFsgt+5JwFL7WWx4cy6oj0VussmdgJOlag8zIt2qruFyPsPGIoWoLO7DvlrP34AQtlwF0I4GamnHeuLXw/nbMtKb5u2aHbR5E9zqxk57D5/mTzOFIMjqpoxh9CAZeTOQzworORsFM4CbStcKSHMhYJBhwdogffrEEs2GEI+rPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCvl5CFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCvl5CFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B68C4CEF1;
	Fri, 10 Oct 2025 13:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102252;
	bh=NN7AHrie72/4YnSrW/gJfkoI52/BNrwbnDjXpBJP6Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCvl5CFMlQQx+d0PiZrpIkNKXYFdr8cIhPBce4XdX1QR9HK+Z5lK6cy6AEvzrcxXC
	 0tHcZ98ETJGcrruzyjjuMUEDGTy+8NeIgL0PSLHXm+MxwGVtIThXoXfqdgm2AcR0/O
	 Ko+DypRdHQdW5f2St1Cx+t6AIJzS9Oizn7B5tPU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.17 07/26] rust: block: fix `srctree/` links
Date: Fri, 10 Oct 2025 15:16:02 +0200
Message-ID: <20251010131331.476902319@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


