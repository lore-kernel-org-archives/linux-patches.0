Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0924195A0;
	Fri,  4 Sep 2026 05:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498757; cv=none; b=Wbf0U+DrfWs1kwV/1HzOsrpFcGI+lVX66wB9a76rIpbtz60CG4ohCEdQK2C+X/7UOPE+6GhsmR5wxUgDacUikA0Jd/Z+Q7N57H/SoB3aphXleIqMRlEU21bxcBOdLQZbFVSxNgCeKFwlKX9REVmAl57yWM6SCsW/HrnkVxigEeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498757; c=relaxed/simple;
	bh=zxE2DugzW5DotkqlOPowu49SwXQm+vCElLm1BrNmwBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgJL5QOAvAVrqWVB434tfQqtYZZuVN+LR7pPdSIOckuzL+RnsNG9AJ8lxZjlUX6BrtSvstZ5eu9KYl8JbnOhzOs/6akkVgp7DlhXGOtKg6PtJgfQyu7NcGRqk1ounnsSAyKDCvrZhSU2qyv6GgS0Os/aEG1PQ3cpqosDV/BJ9CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PphtnWjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PphtnWjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA941F00A3D;
	Fri,  4 Sep 2026 05:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498756;
	bh=SQXW2Fx1vUVJWIqIjKn3/OCtjACSM2LcUIq0+/IvcEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PphtnWjQW/AIYhmlf9Npu8hTNYq2k/OHdXv0yVxrOFWhrsbNnK2kUrJMOGaIIAduM
	 HGPlAkMDBuaHjAfAXr7Zf3J6LQp4CP6fqZhhQErfJCl6bnAFzXj1NiTtBSxozuE8MQ
	 LwP+tGoozoGLIUqyO8gXcVPS1upL3EaeWCjZOzdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 123/713] lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()
Date: Fri,  4 Sep 2026 06:51:31 +0200
Message-ID: <20260904045806.591931872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


