Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5FB2264A3;
	Fri,  4 Sep 2026 05:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500522; cv=none; b=Q0fiShZPXJzhM9yPcT+gvUn+bssc2yzIincBfsC/9LwssYB5BHtLdqwJ4CErWWvifFbS3QSR9CYqnKJ6sOhYzuHn8eNmEVEifLXE1FefYLm0etXJS/Cy/GZL0IJFW5PZXvGkGICFa06S4YzMSGQsjjqP8RwRD9rU0E9Utv9kyYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500522; c=relaxed/simple;
	bh=gQTrPVxNvbqIPvN9niUtB/c8Bv6e8AVVD+wy8K6Sp7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpDUK/hBKht0jWouSKxwm+rlcsuklbbWtku2mNowjtZ8N1QCzii5sG8M360ZNknU0T+6aZL1Jfp+vHQENTgkvRPXxHCJHi+1xwoRXsRwe/HrYCZhPfHjCqGLVh0ja0ph/p56KlXr9aFMEUziWvRwIA0al2ErbgIdDOAJcUanTOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOcZPprp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOcZPprp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B8E1F00A3D;
	Fri,  4 Sep 2026 05:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500521;
	bh=cBqZu6H9dBhtNuczuzG+1j3b6PjrQpLsopiVz3n3aK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOcZPprpd/kzwli14Wump4fBSaoHAy5MBVSBHUYwJ+xSOkLN3ppee8XlAQltNhqc6
	 ZJeX3RILly4KDXHIjhdg+BlkZFpkBTkIt9uTPKzK1FWc9JCgxB+kRPNtGljvfQE+ih
	 ipp2aE5OPUxn3IUpkkWVfB/QRy8tze2phE5ijFmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 087/552] lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()
Date: Fri,  4 Sep 2026 06:54:04 +0200
Message-ID: <20260904045749.849173320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


