Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01516376BCD;
	Sat, 12 Sep 2026 13:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219761; cv=none; b=qWPzhSIqqE/E13sdzAxvXKF8ygoe27QYob23uIP41t/eRRPMQrI2hfKqAw7Qj2qptDq7TR/NBLbz/+It2xRTP5U47olXJ5g4UA2UDfLDcXaIpME173lTbXW2RVMLOTt1gPXVhks94jp53RaSwmp1zzEtIlclIvCwXwdo470l2u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219761; c=relaxed/simple;
	bh=RxUHigGhbVP2ObGk63PPZJ5iYG77T6+Lh5q9WwNlDtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOdngYwWziI6N9YegNmtFOUbuvSV9R1NXwMy+vdQkU2SFWjEjieAy4T3i26EFGFTeGrbli9IkJmp0eWSN7LWoW7W+aLvcE7xzL24GkGUrS8DI2rbyvx+wb60uiMS2dfk6WvLhYcyvEAQDEQUHvVHxsSJqI2vO7LDfuaRxEK70Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLlhxvt1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLlhxvt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188451F000FF;
	Sat, 12 Sep 2026 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219759;
	bh=5gb06WWrKaBLnuWf1PpuYpkN1UBJqcq0kc2yf65Z3O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLlhxvt1Lw0ZZuOhQc3PhehD/YKPSFPY1l5ZITQAuAfQ5SQXMTslT9lqrJNVtz9+e
	 y7S0hQWqp8SXv3EE57bWitMOeEW+I/wBipeK2rBtIHFn8h93dIHFK1Yaqlu9n6/o7b
	 hOtL3CFL6jw0G94SXlY8mbAOe+HPplnDSBSRfNnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0040/1424] lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()
Date: Sat, 12 Sep 2026 08:41:12 +0200
Message-ID: <20260912065608.201770633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


