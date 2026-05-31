Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BEA1A683E
	for <patches@lists.linux.dev>; Sun, 31 May 2026 01:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780189342; cv=none; b=sXeX7AE4USw9k1zjDQxoLkvW8Pd0p9xG8PtsiE1COpEQ7SFQ3A1f3mmGMxPe9Gkzt+KEvvFsEdwXj0pjJk7VruS7BmUR45RrQ7A+DEQAuahSBCYqk966uLPnOIA7Un4U36S7S+eMvyasZHqfN1//t+gXNmjhKft1AooGvMyU2gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780189342; c=relaxed/simple;
	bh=vsb+QThfs2Jw6QSiFQtsk0PMTT4LF7TO2lj9pLcB1Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxKjMukZw0O23DOxmTz14c+GkXY5LoIV7WPcGR+7grV6v0+qOfEDN/4dvy+uWyFan3WF2w5qpte+sZTmOBw9e0uMJ/FEO2wXekWW53MLa+CN/HtVbwwdEHz7i1dtGgCFqzqfQrJA3iDbYH4jWq+XpC9zTFWd+hOyCJrhoxJKHYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TUB0XTDo; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUB0XTDo"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490a7876f8cso1431875e9.3
        for <patches@lists.linux.dev>; Sat, 30 May 2026 18:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780189340; x=1780794140; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BcbBqWTkzkDxwNMdgJ7xVJp7N/TN/+GdHi920u4savY=;
        b=TUB0XTDoxYVN6obfyqDrnrO+tJmhqKM4K8bP6bcKMsFLRwA6hHxe4bzQBllpdj+HyD
         w4gJQX/Y2WL+xMiOClkrW+2MrGcvmEVKHfn2e9ZNmN+P0doMpj5EM7ntg5UUBkzjPvUo
         Q34OIjdm5T7tFFU4w3OgG9wmIOhei3QDj4+3KDu1TH2LQK+qrJtcD9vhBIA1Vo8sBmEe
         bN6GhK6jtVHeZzkVZKL+10Y84cs9tTBUhk7tQyYJ/EKV2lg4040sfqc5BNPjhcW7o0iJ
         PJm+zhLQC19TOthwTOfm/Gx9bC0LlHAdMxgvk4LtNsOoIBYZ6wFjlkCv1eK4GAcoyeZ8
         W2Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780189340; x=1780794140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BcbBqWTkzkDxwNMdgJ7xVJp7N/TN/+GdHi920u4savY=;
        b=lt9tswywctSQk18kBXAHoAvH45le7TKC4A+CNm6SxDvEqjx/BVE+zM7N8GoUcXFhw8
         SaoeKa/nMAA9JsCxlB4lRW//OLgYstjglQFS4VoSp9Dc4Y0O7kXZZjog++KuNE/TzPPh
         6RYDwlQJQQTNXOMFvZ4C+gz38QV14M64VWqih+6hf160flsYax2Aw4vyojHSU8xKvPBL
         vZnXsJ7OTWY6QvjzAM8w0HkVoFJF+sWEZrKu/stjWj2jTpIR5Bpub4wUckjqrI1lWPU2
         DD9cJX8KE1jdhEOwLDZFo2o/qcmhyNUkIxS79fD3AXdXKE3ub19bwuHQGnGTW47A7Tvl
         Iivw==
X-Forwarded-Encrypted: i=1; AFNElJ/XHgS1JUaaKzMta586b3yEdEMyF4g8rbp7DJ4NPdpDoFZcq22EXP2/rZgqYz4igZFloR96jVWm@lists.linux.dev
X-Gm-Message-State: AOJu0YzS8/ZL90ei1d9wRJCNk05Per0ToBgptkclueHCDArWEnfjL1MC
	oF5R0aVs/uThRwXHmcY1e+Z5a7AwORvV2atzM1mTf22iRY9bh5zqi1bj
X-Gm-Gg: Acq92OHtSsqF9JOPbNUExbOYz+txqpvJMWtZrT2xCJ4ZMkDQf9v0rpeHYxS5Ct3SiVF
	UjrQpB42QxSA2GoyudZBxjbWtQLa5YNZSwjUNpuIUMgAXHp+AbIF7QZAWmUzMmG/v3U87MRu9tW
	fYRTE4VLbx/wp0MUv61oCg0CElBOUvUnXGaEipj1krddJddy53ZoukQCC2NwPdsrFVq02nK5qGl
	1yph1OmtgpipW7R12GnYydviegkFUGYebPkAhj121jRhSNcPt+dAbpfTZGTkCNqNOmNsFTLTcmo
	8fTwvFL6yqFDGKw58RmAzrDGe8XOj7wVIJ1lyUx0mZCIYkTf9SZFMZ58YK22TmafxCReplhARLJ
	6fbThhknqTIuLQP2p1XplsjGxTOTe9i6vU9hgtioiTN6gULy+B2QjOKyki5+/kH4HsfbGlRHKKg
	RFnioNwpHtRaqeD6De+kXqHQkjZflS2w==
X-Received: by 2002:a05:600d:8648:20b0:490:9d5c:a3e0 with SMTP id 5b1f17b1804b1-490a29215ebmr71216825e9.9.1780189339981;
        Sat, 30 May 2026 18:02:19 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4909c103908sm45297445e9.22.2026.05.30.18.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 18:02:19 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	patches@lists.linux.dev
Subject: [PATCH 1/3] tee: fs/splice.c: remove unused parameter "flags" from "link_pipe"
Date: Sun, 31 May 2026 01:01:05 +0000
Message-ID: <20260531010107.1953702-2-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove unused parameter "flags" from "link_pipe".

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/splice.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9d8f63e2fd1a..59adbc2fa4d6 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1849,7 +1849,7 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
  */
 static ssize_t link_pipe(struct pipe_inode_info *ipipe,
 			 struct pipe_inode_info *opipe,
-			 size_t len, unsigned int flags)
+			 size_t len)
 {
 	struct pipe_buffer *ibuf, *obuf;
 	unsigned int i_head, o_head;
@@ -1962,7 +1962,7 @@ ssize_t do_tee(struct file *in, struct file *out, size_t len,
 		if (!ret) {
 			ret = opipe_prep(opipe, flags);
 			if (!ret)
-				ret = link_pipe(ipipe, opipe, len, flags);
+				ret = link_pipe(ipipe, opipe, len);
 		}
 	}
 
-- 
2.47.3

