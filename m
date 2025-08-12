Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1752E4248;
	Tue, 12 Aug 2025 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020750; cv=none; b=qw9EI5mqoGkq1+Z68d1i08+76K6Wd3j/sM3XtVqTGNJEKkgoSRpfBEBMILytKTmS1cxRYgqej0qjzDGbvBN1iqLTcaX+b+ih2CYCUisBzDFT4EsHnsIIiIq+xuuYK3hqKA8SfqX0D4i0moOO9eCdrK3ASv4e1bYbHsm1hys8bJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020750; c=relaxed/simple;
	bh=Vn7aCdDZWQ7Kg4A1sLI/2t2ARggEIddigYwsQFn1HMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R2XcfnWgvkTq96F9/Cd6Qhm6BQLWjZKiJLqYwSHiUOPVDY9FPJQE8QEiuF3ID4JE3mclrRon5PHdyvEOAqYttwBoTOx8F8o0CryEfRgGJioI8u8RxDiGOd9RNlg2QvqvO5QkIXEHikD5h7kvgaI2t112GzfX1UM8ARS6oFPqtxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdFcLkiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdFcLkiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2B9C4CEF0;
	Tue, 12 Aug 2025 17:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020749;
	bh=Vn7aCdDZWQ7Kg4A1sLI/2t2ARggEIddigYwsQFn1HMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdFcLkiYVurGnBca/ksa4ZJazJ0Oi7MDChX6HPfmVT10qN+ntiy94UGnn0GXCHWiG
	 maFeoxvcES8OubyY8RJbAg3HMDMOxsPqmcQ7vli0RVR7M5NJKMMluO09WJ1Z/DWWvC
	 0v2OGoEjXV8zXO2IDpD26yDDV4+D2m0T0sNR+tOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RubenKelevra <rubenkelevra@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/262] fs_context: fix parameter name in infofc() macro
Date: Tue, 12 Aug 2025 19:26:35 +0200
Message-ID: <20250812172953.284688506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RubenKelevra <rubenkelevra@gmail.com>

[ Upstream commit ffaf1bf3737f706e4e9be876de4bc3c8fc578091 ]

The macro takes a parameter called "p" but references "fc" internally.
This happens to compile as long as callers pass a variable named fc,
but breaks otherwise. Rename the first parameter to “fc” to match the
usage and to be consistent with warnfc() / errorfc().

Fixes: a3ff937b33d9 ("prefix-handling analogues of errorf() and friends")
Signed-off-by: RubenKelevra <rubenkelevra@gmail.com>
Link: https://lore.kernel.org/20250617230927.1790401-1-rubenkelevra@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index c13e99cbbf81..c9eae7117001 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -196,7 +196,7 @@ void logfc(struct fc_log *log, const char *prefix, char level, const char *fmt,
  */
 #define infof(fc, fmt, ...) __logfc(fc, 'i', fmt, ## __VA_ARGS__)
 #define info_plog(p, fmt, ...) __plog(p, 'i', fmt, ## __VA_ARGS__)
-#define infofc(p, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
+#define infofc(fc, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
 
 /**
  * warnf - Store supplementary warning message
-- 
2.39.5



