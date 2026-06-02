Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87933BED24
	for <patches@lists.linux.dev>; Tue,  2 Jun 2026 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780440876; cv=none; b=lezv60ZtVMdRI5YYAtIrLZRofXGwX177uGNAxzsIQaQGoDOQezriPIT9fvEDKCwEZNW0/RwxhhtiX6cBnS+1Mv6S6gRxNxB4z8H5LwD3qCv/fQ/hX97mApd+EJ2Os+kB3gh+abHHKuXGV78fobXG8iW+3qMw3IZD6wT5JAw3+mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780440876; c=relaxed/simple;
	bh=X+6iZWTfWXpo410W4glUkXVe/Shkkk6QObVykw+rX6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8n32Ckb7i5mo12aGq7QMkGFRsnWZ/Et4EkE+ieHfS8olW5UcCjhT+5FF00uDSzlo2I+n17TVl+PbDD3f4Rm15IqoloSqanC9cYFbqsSRPMkmsJnxqelmGAjU3OJcQI7eRDOYii4DssFLChb+9Uequ5mAFCORvegAqWUL6kLJXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fytj0eo/; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fytj0eo/"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so3690276f8f.0
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 15:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780440873; x=1781045673; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Jl73xD6zIPi47mu1jowzc4phm5baQXMI7icQsNN3pI=;
        b=Fytj0eo/tFYbhKkFY7knYswVOz9rOI8X6sB38Q5E8QXKjyubpnlImEoTOvjzgFzhOI
         9E72yJZDDvg5HfpxdTdAql76tojqioDUQtbzMmUPD85ovp7uko9MXJoY+n32Un2JeFAS
         dwZya+L9z8MR1PwOBksYQym63CFdxz3D6W/vfPBLRRtzI+MowzyuHLpadXpyoVyL2Rb7
         zsCQmPAj9FiejrH0tD7fp8bIG39+nCz5ojQpQQw0zQEIv/BJaPUBl0KvB51MjPve65jN
         HoGs5t3q85Nx60A0NWmUrB16aAyaliiq2ZQIO1NZGXejf7Lk236sIa7s7VJCyIRfi2AE
         4NKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780440873; x=1781045673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Jl73xD6zIPi47mu1jowzc4phm5baQXMI7icQsNN3pI=;
        b=Qw955ojRxp1q8fBBJnTY9k9Nm+kg97tjxWCgFUrqBdh5aRqcZkN70f0bdFUwOVSITf
         4VqUA+LmiYPUSbPT9GdD3sAEFBWwNbB7jR35u7JznkTtGIH9QhcuxNGkGONk6N4O1Cys
         wWiFEANGjt+uoaYAHDocMlwZHVUBJzjhz/4j9O184h0mxIabufY2bFu1Btn9ohiIFATX
         SMhwHsOu83pRlfJlB5TqPczhYyO7pySrgxB31+dfmKoaWEL9yM7t//ksDLicZqA3TKYH
         w1/gZgJhJXLzHliQ2vyX8wr35gtrzPweJ2ZV2koyPODYnZTPpplfz4+tUexhwrLovw9z
         UEIA==
X-Forwarded-Encrypted: i=1; AFNElJ+/Nni37dH3nfzkJEjJc/I2hoRN7MOCd50iut9zNBHYiWIDAQhUe4CmBH5Py+JNgOGmMsWkf/X/@lists.linux.dev
X-Gm-Message-State: AOJu0YzBArl4EetJEWLOQE8tD5N1UFTLry/wlOjigjR6kPi50rjbZ8aJ
	jheKu90MhE86zmPoUVIbH3H9wesLQX9AwlSHHUpu+M6vaA4dVZwB/tPs
X-Gm-Gg: Acq92OHQ5QsXY7i+hxrtHKCEQVfD81k688Mo7tgoYjKC7ZtpSoMlYlfw++MVuk4JRcx
	sTh0Qrj3BBjGt0/SRNZXSaN0D19bJOhxRdnzRsD9N8dkOMPYEt3cljlzGJWyzPN13weboyGLKJI
	98I6D8XbNlcHzig+qnZmVYbIdtJFMn15OjnGwcFk2djkgBpq6WcqxVANMmJWURdsvtzCKRMOGbP
	So9m95AiBQACQQvyMTMSIfK2XRsHeUXNZ/pndyIt8A9t2vq4iThWeVOqC+RBsDn+BGIKkQ9eHuk
	qh0URy7WnN4lx8N9p8j3nBOk9p22VIdG0nVpnMO0r6H8orYpJoMTTjILixczqkYGTTnFlLZtCtZ
	mFVob+QcOysa4KrCKn70TTRgHCxGJeW1oWLYWQzIDHmM651uLl1fKlxYfyQCJtZ3jDk8g2zf4LK
	DMVcRFE79Eq4QHjIdeJ7B3ktQ1aygXUydJxweHTDq9
X-Received: by 2002:adf:f58f:0:b0:45d:3cb0:5ab1 with SMTP id ffacd0b85a97d-46021873b26mr407422f8f.38.1780440873290;
        Tue, 02 Jun 2026 15:54:33 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f2dc577sm2550100f8f.3.2026.06.02.15.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 15:54:32 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed,  3 Jun 2026 01:54:26 +0300
Message-ID: <20260602225426.122258-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus Torvalds <torvalds@linux-foundation.org>:
> That isn't what Askar's patch ever did.
> 
> You apparently didn't even read it.
> 
> Honestly, I think you are the one out of line here.
> 
> Askar did something I suggested years ago, and didn't remove any functionality.
> 
> It just changes vmsplice to be a copying model (one of the directions
> already was). It doesn't change regular splice at all.

Pedro is talking here not about this vmsplice patch, but about
my future hypothetical patch, which will remove splice-pagecache-to-pipe.

Let me clarify, what I want to send: I will make splice-pagecache-to-pipe
be a copy. I. e. this splice direction will continue to work, but will be
possibly slower. I. e. I will do something like this (see end of this email)
(absolutely not tested), and the same thing for other filesystems,
and also I will remove resulting dead code and remove
pipe_buf_operations::confirm (it will likely become unneeded).

If Pedro sends this instead, this will be okay.

diff --git i/fs/ext2/file.c w/fs/ext2/file.c
index d9b1eb34694a..8edcc3769793 100644
--- i/fs/ext2/file.c
+++ w/fs/ext2/file.c
@@ -326,7 +326,7 @@ const struct file_operations ext2_file_operations = {
        .release        = ext2_release_file,
        .fsync          = ext2_fsync,
        .get_unmapped_area = thp_get_unmapped_area,
-       .splice_read    = filemap_splice_read,
+       .splice_read    = copy_splice_read,
        .splice_write   = iter_file_splice_write,
        .setlease       = generic_setlease,
 };

-- 
Askar Safin
