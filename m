Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF0C4B5D8;
	Wed, 20 Dec 2023 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9PqSB3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D437FC433C7;
	Wed, 20 Dec 2023 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088845;
	bh=wYNmEUGGhNrz14mG0lyFrXp5CTOL+X1ZQAYHAQETSmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9PqSB3JLtfnO/LNvL19co4W+88dMAg40D6bgiHJxAZigDGapwX7MC0rU33fRhR2A
	 DTQwmZZgyF/YHpC4YY4D8RyMRCFpRUySTftiK3Y6Mbssw8xoS8wXo7BImdR7+gHQH7
	 LlW3dTPevJ2VQz20GEVIqgaDxfX8kdN6eGBMRsHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 079/159] ksmbd: remove unused is_char_allowed function
Date: Wed, 20 Dec 2023 17:09:04 +0100
Message-ID: <20231220160935.062059551@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Rix <trix@redhat.com>

[ Upstream commit 2824861773eb512b37547516d81ef78108032cb2 ]

clang with W=1 reports
fs/ksmbd/unicode.c:122:19: error: unused function
  'is_char_allowed' [-Werror,-Wunused-function]
static inline int is_char_allowed(char *ch)
                  ^
This function is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/unicode.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/fs/ksmbd/unicode.c
+++ b/fs/ksmbd/unicode.c
@@ -114,24 +114,6 @@ cp_convert:
 }
 
 /*
- * is_char_allowed() - check for valid character
- * @ch:		input character to be checked
- *
- * Return:	1 if char is allowed, otherwise 0
- */
-static inline int is_char_allowed(char *ch)
-{
-	/* check for control chars, wildcards etc. */
-	if (!(*ch & 0x80) &&
-	    (*ch <= 0x1f ||
-	     *ch == '?' || *ch == '"' || *ch == '<' ||
-	     *ch == '>' || *ch == '|'))
-		return 0;
-
-	return 1;
-}
-
-/*
  * smb_from_utf16() - convert utf16le string to local charset
  * @to:		destination buffer
  * @from:	source buffer


