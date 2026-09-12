Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EA4278161;
	Sat, 12 Sep 2026 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226709; cv=none; b=ORwEJhvURg/6R0I9OXY/Vy18WWF7gcz4WWpfemBszsIdgCccAZ3eqXYQqHmgCMG4svHk53ZysODVGf7Do92gx8COobWH77Ubip2+sysqPzKUNLwWsBRL+y6u/PS6h29I402E+7dAn+k6a6zaqjMzOCy5acSLsVar8/7aOz6gwnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226709; c=relaxed/simple;
	bh=jE9Ln/qakG5/Wnyj2Egi5TwYNNyCfhNolpr2jkWEr3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meKwpOB98hUe+QjOuWbHzvM5ATPcVkSiYvb8T+uQ3HyT38XCkLvcFM+iOildnHTZAj9c6xCGC1k4XlcwoiB8aFtGnFP7NEwNmfbFacJ5lalMN91Cu4/r04I7Z7e13c/V4KLIF5L7Yd84YdSYrK6S4e4v7DW7KsH7b3Dx0owWeDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUkheM9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUkheM9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145431F00893;
	Sat, 12 Sep 2026 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226708;
	bh=yR+I49wzZMtz3uegy0h/6e1vBemnSFPdbSJNeIRkrr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUkheM9CScpWWyl6i6vGTGBM4fCQM6p3T1cuqoetDW6L85h2RVyUH/h/Nq6GEvXGN
	 1195LzmUmb4xhqLT6DJSA1hk9RGzkyNXBPdJ4b/Mtr/DxhUDF4pgeOxsJDt2OWMc48
	 QmoRLGubQRVtl5DTf4/jqc3/eUs/X3taWdrnN8VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0032/1191] lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()
Date: Sat, 12 Sep 2026 08:46:00 +0200
Message-ID: <20260912065548.846325858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol@kernel.org>

commit cec0d03fe785380540dc1b4d07c80f67ae2ffc78 upstream.

Patch series "lib/ucs2_string.c: fix out-of-bounds read in
ucs2_strnlen()", v2.

This series fixes an off-by-one out-of-bounds read in ucs2_strnlen().

The first patch is the real fix, the second patch comes as a bonus and
fixes the code indentation.


This patch (of 2):

ucs2_strnlen() checks the current character before checking whether the
caller-provided maximum length has been reached.  If the input is not
NUL-terminated within that bound, the loop can read one ucs2_char_t past
the limit.

Test the length before dereferencing to prevent an off-by-one
out-of-bounds read.

Link: https://lore.kernel.org/20260723-fix-ucs2_strnlen-v2-0-9ea94e32a358@kernel.org
Link: https://lore.kernel.org/20260723-fix-ucs2_strnlen-v2-1-9ea94e32a358@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/ucs2_string.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ucs2_string.c
+++ b/lib/ucs2_string.c
@@ -8,7 +8,7 @@ ucs2_strnlen(const ucs2_char_t *s, size_
 {
         unsigned long length = 0;
 
-        while (*s++ != 0 && length < maxlength)
+	while (length < maxlength && *s++ != 0)
                 length++;
         return length;
 }


