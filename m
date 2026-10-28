Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215885;
	b=I+YKiv9T4ZMvlfkuuW5GPrjt4rJcwAbvRFHgPa3YvAb1TayuYz0bBjwqreOrTwfge52f
	 PeqD9xDrGq7L+T8gLvoJ/MBoXt8OSVoGNz4v0xA+eGUL0KRZddBAf53kuERmTSpoGnwTX
	 Sjv98eISRUiVR+mQyKjAYXUTmx9kg7zMbSkftQ6hDC4IOwmXBi7JE8v8oaxLV5fP3iskp
	 LMyfCvUok2f4k3N4g16mNuYrFhUWqDQPbd+MYMT+NFmzwN9D8XhwOORQIx0DT3STTUivV
	 oMTC7h0ySzOhV1OXtjzAQUacVrD8NlxFpm2gVN/gUwPOupeaDUYtPRrLLxTwRY7+f3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kC/tYBOG7YH/A7xdUJ/pdxib8wEUmXT/Np+mbgh9f08=;
	b=K26eCPoXONtUmyA1H9ouO9QaqW5/WrNQKxYVu6EwIwv1IJqHtYADwGxFvHrp5dhn46+C
	 RID56CV3KbIhM4OyAyp5AigtFojBXdPEDWC3A8K2KTM2CEjLiJN/FeEtYQE16Bj0HRVwf
	 0CeXX9SIQ7gC0rqvcaXqUcRL7A4Xw1laCO2hlpjgdFOLL4J1KpqBRNrLjh29OzFCP97JU
	 nNxKGFT/XCN/AKrDLfGd/RibEHezTyn8g5I6fdZ01nOrVgSifMVIWKDv+BBYVMibE+Z1o
	 y0dDh4c7rz+oAL2zd+i5faasqZcnWrL/OMBVGpjKdCFDCY7mkls3Bw9bLpyN6UuSLqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpWU2Lc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE21606A31E;
	Wed, 28 Oct 2026 19:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpWU2Lc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF331F01825;
	Wed, 28 Oct 2026 19:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215884;
	bh=kC/tYBOG7YH/A7xdUJ/pdxib8wEUmXT/Np+mbgh9f08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpWU2Lc3bxRnszFMR9wKgEqSlxnU5bw8GxdHRdh6cNo1ag/bmMHxpSBcAKqLs0vmE
	 f2FQVKbWa1RSKCylA3U3kBB65tVnRF0l58ub8Q43fLHkq/nFH8U1P4UnImg0Y4Zhif
	 Hl6lQlCcwjWcG0u+2KTdelG1DuxkbY8qkLEUch5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Qu Wenruo <wqu@suse.com>,
	Weiming Shi <bestswngs@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1322/1887] btrfs: lzo: reject compressed segment that overflows the compressed input
Date: Wed, 28 Oct 2026 17:56:58 +0100
Message-ID: <20261028170529.511359065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit b0d27d43791b7a3057c3c4aedf9b4aa033d37c46 ]

lzo_decompress_bio() validates each on-disk segment length seg_len only
against the workspace cbuf size, not against the compressed input size
(compressed_len, the total folio bytes of the bio).  A crafted extent can
carry a segment whose seg_len passes the cbuf check but runs past the end
of the bio, so copy_compressed_segment() walks off the last folio:
get_current_folio() then returns the NULL folio from bio_next_folio(), and
with CONFIG_BTRFS_ASSERT disabled (default) folio_size(NULL) faults.

 BUG: KASAN: null-ptr-deref in lzo_decompress_bio (fs/btrfs/lzo.c:383)
 Read of size 8 at addr 0000000000000000 by task kworker/u8:1/29
 Workqueue: btrfs-endio simple_end_io_work
  kasan_report (mm/kasan/report.c:590)
  lzo_decompress_bio (fs/btrfs/lzo.c:383)
  end_bbio_compressed_read (fs/btrfs/compression.c:1065)
  btrfs_bio_end_io (fs/btrfs/bio.c:135)
  btrfs_check_read_bio (fs/btrfs/bio.c:180 fs/btrfs/bio.c:285)
  simple_end_io_work
  process_one_work
  worker_thread

Reject any segment whose payload would extend beyond compressed_len before
copying it, treating it as corruption like the other on-disk validation
failures in this function.

Reported-by: Xiang Mei <xmei5@asu.edu>
Fixes: a6e66e6f8c1b ("btrfs: rework lzo_decompress_bio() to make it subpage compatible")
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/lzo.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 79875e9e1cfa3..6e6dd4449697e 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -15,6 +15,7 @@
 #include <linux/refcount.h>
 #include "compression.h"
 #include "ctree.h"
+#include "btrfs_inode.h"
 
 #define LZO_LEN	4
 
@@ -390,6 +391,17 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 			goto out;
 		}
 
+		/* The segment must not extend beyond the compressed input. */
+		if (unlikely(cur_in + seg_len > cb->compressed_len)) {
+			struct btrfs_inode *inode = BTRFS_I(cb->inode);
+
+			btrfs_err(fs_info,
+			"lzo segment overflows compressed input, root %llu inode %llu offset %llu cur_in %u len %u compressed len %u",
+				  inode->root->root_key.objectid, btrfs_ino(inode),
+				  cb->start, cur_in, seg_len, cb->compressed_len);
+			return -EUCLEAN;
+		}
+
 		/* Copy the compressed segment payload into workspace */
 		copy_compressed_segment(cb, workspace->cbuf, seg_len, &cur_in);
 
-- 
2.53.0



