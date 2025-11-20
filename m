Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD7B1624C5
	for <patches@lists.linux.dev>; Thu, 20 Nov 2025 21:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763673243; cv=none; b=ixYX/EItjAehSmWHpTxtrgle8ePxiWTIxWbst8A5gPGjHlFnQQIfVZpnBvbggTp9CBSIilaLW2LR8B8lFqG2EKUuokNLykwCiOf2eBEVmOpnC5GNMHKw0avH1Lp33Kmcal8Ad08YjCmsvAyxhgj4H2DpcrTpWTxOPXIrOO+11oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763673243; c=relaxed/simple;
	bh=cQMX/usI8gqcSln2UFa8v99XXRwzaizYb3BPi10FYFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yrj8igUeIfw1fOpNMRxB0EvnEcqrYeVBbrIQD9rI34+4Jo6wmax+e+2P53kVZJzmQs0jvU6Dkc/Wh3VIgS61tMY9wZtt9ILddRMxRVXQAU9Y4rny/r24I2sj9qnObH9mA4sNIRnFiSVZbJKUNkLAN5gkI31gZ3tmxnVUGn3y92Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UlCQH59/; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlCQH59/"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-59583505988so1876432e87.1
        for <patches@lists.linux.dev>; Thu, 20 Nov 2025 13:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763673238; x=1764278038; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4d7IAZGUxK1m7h2GDkMHE2QpE3zLGipSmtQ9os7xNBI=;
        b=UlCQH59/Y32GTeplAN4HnqCyhVrNeN380OxNEtKWGWqpgV+YO3d8dwr4ww5DpBqEN0
         E1Em5PTbVsxYQWGqtxCqBBawl5Tno9QQaHhsmxJxvXjkpMMwipz9JZ4itMpwEFUHFxxy
         XypjWlX9zVaTz7wqzJXKpu/Or4Xwbmm3WmSoz02OdziWfwMoYPRtsxuOydqyUFcHTPBh
         CPcHB9qet4EBbtHWzbUzHU3l9iiHyzkVAuV8HvTzJhiemkGRxaoO+9KWsfyBlZ0keJ6g
         Yl7I+qp5PvK47sTbkIH+aoH5nzgFcv+D/uLX3hZ8dwqnv3tMjXdEd2e6zVE5j8n5mUs7
         YcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763673238; x=1764278038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4d7IAZGUxK1m7h2GDkMHE2QpE3zLGipSmtQ9os7xNBI=;
        b=U0z6iSy1LumBBqh5P0uxaFTVbkG2yZc6jPyldHoNuFDB5W7WP/giilkJIjTOGPbL4P
         BzlFUuvSKAVfewHLw2JtDL3lQZ5n7LTh+7oAxsQ69AZA3QRMgNeZHoFG+nzcwovuB5Rm
         BHhv+d12vEsIcxQfUB/EPeO6wuOUh8I22P2tKfVWFOh7mhgYlbOw7ibaB7CkvHRik5kO
         WEyjvzs3zHMfH9RXJp6AimulvETV0mCUSPEntm1E0i+OW6oHXqJL7tVluB6nNwuhM4AS
         JzABpCilBZAbXK1VEPJVC4jX424iBzUEK4tj5lMTPz4CpNbV/S2U6OClc8nQVMTdif+A
         vY1g==
X-Gm-Message-State: AOJu0YzE/em+8Gj40ZHdAC9dk4S2KicQaomOAH7qkyyFb6fi9p3CinQU
	fUqBTJ4UIsVwsQ8O1pjE1awGgrMKXFmeD0+xoPcZi0LRAFyAxwUaV+PE
X-Gm-Gg: ASbGncuBReXrLOqcuuBDLUV05/1laWVuWxEf5tQn5ljx1Zm1HUQKzaJYYAjMomLSpDv
	lTuL/81rd8qqqPstwgF9v1g1bQOqMuzjZJJcVm3C7cbYFZXMZXi7v2Wwv35NIglASFHD9ii9kgy
	o2QdnKa02gCdXP7M9HFSA42Yn3ivcXpZYh5ATG7IzrdgB0cWM59myMyVKgABZWvVGpuHE6l4uu7
	NcVoRqo1FPq6AM2tFyyPdro+cZ8eLE2Nug2DqL7usH6v/PbxstKFsiNQzT/6eYP8ss5iU1/C/sB
	FH0rDrV/fHFhjlEMG+jicvL5lVvEA/4AFEDuuOZdwbSePd4XjaneMVcwwL39z9x+aaj/TIE7I/W
	qTlqapPk/BJHWk7nCth1BD+BGzgezumVvujg9BTW3QJAU2zHbzfb6kFWOmRUEOUNKv4a1I3QLrK
	2Y2WWDu6Mi
X-Google-Smtp-Source: AGHT+IGhpshH5PO4QTdDzSqAVgMyMOZ968ZCv3rtjofzqeUqpZ5T2qu6vbZdUcrZQBx0KF/2QP0meA==
X-Received: by 2002:a05:6512:1293:b0:595:8a7d:87cc with SMTP id 2adb3069b0e04-5969ea2237dmr1408150e87.16.1763673238128;
        Thu, 20 Nov 2025 13:13:58 -0800 (PST)
Received: from localhost ([109.167.240.218])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-5969dbc5964sm991716e87.70.2025.11.20.13.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 13:13:57 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/splice.c: trivial fix: pipes -> pipe's
Date: Thu, 20 Nov 2025 21:13:16 +0000
Message-ID: <20251120211316.706725-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trivial fix.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/splice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index f5094b6d0..d338fe56b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1498,7 +1498,7 @@ static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 
 /*
  * For lack of a better implementation, implement vmsplice() to userspace
- * as a simple copy of the pipes pages to the user iov.
+ * as a simple copy of the pipe's pages to the user iov.
  */
 static ssize_t vmsplice_to_user(struct file *file, struct iov_iter *iter,
 				unsigned int flags)

base-commit: fd95357fd8c6778ac7dea6c57a19b8b182b6e91f
-- 
2.47.3

