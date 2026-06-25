Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA2A37B03E
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 08:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782376635; cv=none; b=Pbi4x98N2MGgXyYA4Om8RMDVtKkKPEiND47jTEZb8gFeDWMdmtgx4sM6Qu3vIoGf66ki09DUZxjO+5bBxbelYhYtCbB5Fmge5Dt37SitlBuotI4L6HAYuj6rMEmTKk2oATXGx/s6A0mo6odQWnB4FWImyi3w59MR2baoEohyhSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782376635; c=relaxed/simple;
	bh=vfuzqAAI4Z7JfbLKu/I0egbH5sPpHBKYRHIHNaxeamI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW0BLVptvVTvL4Ww8RzuD5ez4hFwcb97Yd4HQeha2n6mm9NuwaSO2ubJMC2pQdcn7nam9oO1XwGhtEQMjeF447v/3rQDY6AnNNUErpACp+MN2kNj+TLLUV34x1mZRYW6Y2lFKRkrcHT8ym0dpQHs6V2HBfQ1b5MP/gG0CHnHEsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jvf0NzIj; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jvf0NzIj"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4602e2a0372so1545659f8f.3
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 01:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376632; x=1782981432; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Vxs0grT+d4GM87KSfFWu+blunYqTUopWsPT4iLI/6Q=;
        b=Jvf0NzIjoEzgxkGAJHYowWVD45/rDR4HGAxnVmFciVgNHUPZBT8pFPmZGkWtnyIDMR
         vU6RPnfXfWnfQuNoIrXEehNTMRynwE3UhSkNSsNOjEEdeY0Itt0o2IdV1M5O/dSuIk+W
         9Os2Sm7qr3qd53fbXJlB41eb861D7r9MhYhaWMPsC53qDepjGfS6Q/J2izrn/6Vw7A2f
         OPnJL4xTaOIQ08NaQDertPPbtVysOp6iCOx5PWASXKB67O4jxeCtX2iBe+aK+JHfxOkB
         AEGgmpINW/mGtz2Mh7Qe4iNKTKGQAtfJfhQtpEKP77kLmL9YGC9whsN2qLQ6UcOndnqG
         px5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376632; x=1782981432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Vxs0grT+d4GM87KSfFWu+blunYqTUopWsPT4iLI/6Q=;
        b=gcsNdsvgAi5izdq4ypplSAaD8wU/HXXSCpJ6Mgau7OkjSy00RFxQV4LlxCLitmfOb9
         C3q3P26fPVvwm8PZct+IxH8nnlIiWhXvtiz1P0qwd89Q/F/7KfJtxTjT/7EzaoYUkKhX
         6bUoJYyedwRJHdX7n1nVic3VCZ8j/UE2RGipIcygqSL4T5N85KN91eE+9veOv1yUgA/S
         WzW1ATi926xGzv8vYrlLy+g07Ex7bxbhx5nQjLpvf6jM5OeK0egwxb2gBkJr0w8OoKAk
         AFTgG/5TvuN/a6JjVE44EbyZYLiZ4FHMuMj5/mZP3x8coTAjlkirfzypukev0MfMo81s
         O71Q==
X-Forwarded-Encrypted: i=1; AHgh+RpVvfUC3SeA6gzJlhJkVdGPuRMUyn6e+BidHRtuLHCS5+IyosJ1/yvcNWa0CSo28W4ID/uMCsPs@lists.linux.dev
X-Gm-Message-State: AOJu0YxmOE3Ph7UjylZjrVZOOCq/pvhNs6UGHmpBTYjch7YKigEtAr4l
	OUIO8YCEgx2VtqWOe+UjnyEk31CH4d7+ctrWvY0ZhUw1muK+NTG7RPK7
X-Gm-Gg: AfdE7cnvObr7rJ3i+rbMteiXSX2E0/4Yd+2ZUzhh85WsOC+9Xta/h1rBmDM1pg3qO3W
	o+V2GOUg6wvZlrmFeRgn7evjuz4WcIxMKeWZLgdSXHieIgOh/o485nge2+lFvFfYoUX7anWekZl
	ggAVCg1t9UTwAJWWquMSTgRjjd3I5YV3roxPjBx/5Rs7Hohjzi2Lh2EnsuPwTzMFDdlmIg6Bzz1
	WqRIHblIkdYUmjClUJYNBTmo23ln7d5d9dVLpl+kJscFWOk+cS2AFwcsCIb7DRd+1m1GA2rrdwV
	QWTdrXcoEMHuqFnXES5qqMNA58kpyrnc9wNaSbES7uzol8fbkDWSXKHPayL+PNRC26A3l8y9r9f
	MZSuvFLiJmKu45RPwy5W0B4CGqf5rtLyyFf1va+e7oZiAdTe/wJaBVPj/34RwOs6hJC0I8CXuKM
	XXOXkf0ndP
X-Received: by 2002:a5d:5e81:0:b0:468:4f81:5aa4 with SMTP id ffacd0b85a97d-46dc026de2bmr2181270f8f.10.1782376631864;
        Thu, 25 Jun 2026 01:37:11 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c221d93eesm13786367f8f.20.2026.06.25.01.37.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:37:11 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Val Packett <val@packett.cool>,
	Andrei Vagin <avagin@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 6/7] vmsplice: return -EINVAL for particular combination of flags
Date: Thu, 25 Jun 2026 08:34:08 +0000
Message-ID: <20260625083409.3769242-7-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

See comment for details.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index dbd0debc2..b1f71b142 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1258,6 +1258,16 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		bool non_block = (flags & SPLICE_F_NONBLOCK) || (fd_file(f)->f_flags & O_NONBLOCK);
 		ssize_t ret;
 
+		/*
+		 * libfuse relies on sharing vmsplice behavior.
+		 * So we detect particular combination of flags to
+		 * pipe2(2) and vmsplice(2) and return -EINVAL.
+		 * This forces libfuse to fail back to non-vmsplice
+		 * code path.
+		 */
+		if ((flags == SPLICE_F_NONBLOCK) && (fd_file(f)->f_flags & O_NONBLOCK))
+			return -EINVAL;
+
 		do {
 			pipe_lock(pipe);
 			ret = pipe_wait_for_space(pipe, non_block);
-- 
2.47.3

