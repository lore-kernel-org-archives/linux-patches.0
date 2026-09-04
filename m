Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55739415F3E;
	Fri,  4 Sep 2026 06:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502019; cv=none; b=p5owB8S0GiN7KopX1tFBOljVFegVJYR0E/a0eJr5PAoM3c/FThobwnnl2l1HUO6EW/dnkLvqHpDUGDBIAdunV3nHvYO1fULqe3/nnhhcyaK9nG01LyK0X35sRxvP7BkRd3ijlvydj5mJnVU7pmjQXuB7o1S4cSGFmmoK2KDyEik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502019; c=relaxed/simple;
	bh=7dikoo94OsqRL2WUUeIIGIxovW8El9niqo/XdhMta3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFE8X7zlW4IatqwO/y8aBzb2H5PekFhFyqpCghDt1mPH9SOj3ZaJ97AoQ/tjKgzXNnW/TAGEqLg5ZjhJU/FDZdxr4zARnv3a2/jQ6GkRIfV995ck5N6cbTu5FzVvCs9X1Z3ey5IuG5T/JzmkLevYd2VAN8irOiZtTpqfQKc4fz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dy00d0T8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dy00d0T8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6D91F00A3D;
	Fri,  4 Sep 2026 06:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502016;
	bh=dSW57HP2LRse/n6iFESnzioxgceJG9gc0AefwSV/RD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dy00d0T8Edaa2JzxfaCGfCG3wGX9U2rhOxnnqw5CYjkb99+RFYZEAHvx5JgQSMvB9
	 dW5Lw1mvDNQpwGRyEx/vh9AC6fkMas2D5s6yC7Ljrl+wS5kwVJe7L8UCeeMnGWr8P9
	 dyiZ1HPevoYRzGcCXYC1Idu/V+gbQWLJeCbdOLaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 060/403] lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()
Date: Fri,  4 Sep 2026 06:57:43 +0200
Message-ID: <20260904045736.198694062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


