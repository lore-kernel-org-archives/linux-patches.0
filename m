Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F54980C
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 13:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA48C433B5;
	Tue, 27 Sep 2022 13:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664284553;
	bh=lLVeSTRx1wtOeyOrw5Ac0zU5OsqN3eIH/yKi5nlw5oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfobuIomzOqA7iIuZRwMLdEfiteOj4BxAZJ0aMBI89dEj2rpxMzHYgkUfekjz5oEk
	 GDWO5JXvIzdJOGZ7jQRBhtL/d1Jb8wW17CVZXx3O5IDl1SF6q725XAJL7U66hx0U6h
	 gFt6S6/6GzvhQmX9t0Vzy1BNdAuD3UQhmefACmtrPuHxVaoM38xhDpb2bT+tEJ7VxP
	 QcY81qnFcwCssmazYJJBTcy/OPRPQiXkzZZ559uWuBQFy2pvcD9tjaGGcefBPADY/9
	 mpRmWo720SVO1W7NMc1Ym2w/GG00/y3PIPdNq62ebHmpkmcuDwmCHIs9FA2RtPUdGC
	 qnekh2e+bbSAQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH v10 01/27] kallsyms: use `ARRAY_SIZE` instead of hardcoded size
Date: Tue, 27 Sep 2022 15:14:32 +0200
Message-Id: <20220927131518.30000-2-ojeda@kernel.org>
In-Reply-To: <20220927131518.30000-1-ojeda@kernel.org>
References: <20220927131518.30000-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Boqun Feng <boqun.feng@gmail.com>

This removes one place where the `500` constant is hardcoded.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/kallsyms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index f18e6dfc68c5..8551513f9311 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -206,7 +206,7 @@ static struct sym_entry *read_symbol(FILE *in)
 
 	rc = fscanf(in, "%llx %c %499s\n", &addr, &type, name);
 	if (rc != 3) {
-		if (rc != EOF && fgets(name, 500, in) == NULL)
+		if (rc != EOF && fgets(name, ARRAY_SIZE(name), in) == NULL)
 			fprintf(stderr, "Read error or end of file.\n");
 		return NULL;
 	}
-- 
2.37.3

