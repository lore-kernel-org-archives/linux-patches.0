Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65B11C03
	for <patches@lists.linux.dev>; Fri,  5 Aug 2022 15:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF05EC4347C;
	Fri,  5 Aug 2022 15:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1659714175;
	bh=xdSHWCs9h2K8wnnw4cbgM7/350sCkbahN/3I64zs7hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjSFSRsguTf+NTNBYo/0tq72++hnEeBhvVLCv3OzQlJN4jdRnozFGO3Q/SbFUWn7l
	 DVJgWvAJXh5tFs3FijdltTqcvKHIPMBkRLiEIPFCcv4FqGZ0P1omKuuvhKQjvzlB1y
	 LtEkB9GP+z7wQlB2WzlC4EF5lvTt4XZnG0DGA+ZLlwfkocNnZUIteYtwpgIgSv97sp
	 gth4khhEYzPMOwIxzp7cQtaskiSlts9SYPJd53kE4m6KN07vqXZeFDrVFjMm7vJzhD
	 bl9ZR+dKFELzpoOjEmhhzVb1DIf9Y94Am1QX+7OO3MVSGg1GHzpxJnbDS9b8NQAEe7
	 9Qqx+XyCjA9jQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH v9 01/27] kallsyms: use `sizeof` instead of hardcoded size
Date: Fri,  5 Aug 2022 17:41:46 +0200
Message-Id: <20220805154231.31257-2-ojeda@kernel.org>
In-Reply-To: <20220805154231.31257-1-ojeda@kernel.org>
References: <20220805154231.31257-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Boqun Feng <boqun.feng@gmail.com>

This removes one place where the `500` constant is hardcoded.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/kallsyms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index f18e6dfc68c5..52f5488c61bc 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -206,7 +206,7 @@ static struct sym_entry *read_symbol(FILE *in)
 
 	rc = fscanf(in, "%llx %c %499s\n", &addr, &type, name);
 	if (rc != 3) {
-		if (rc != EOF && fgets(name, 500, in) == NULL)
+		if (rc != EOF && fgets(name, sizeof(name), in) == NULL)
 			fprintf(stderr, "Read error or end of file.\n");
 		return NULL;
 	}
-- 
2.37.1

