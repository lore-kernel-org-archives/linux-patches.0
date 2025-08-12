Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5BC2E7BD4;
	Tue, 12 Aug 2025 18:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023245; cv=none; b=Q5q1MIgYqqvZVrey7BXb4pkqzoWYohVAkb3Xt32iqYmUanpQV0Y5ovmkZHbTjwVPONA85XLx/tKInyFAGXFZcwnhlP2QGFjN+2lNDox3kg4qRzb0B/olEQhYfFSTO5X+5wY+i8i+3vqIqAebaHopvsD2wNXZvS/an7fO959HJVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023245; c=relaxed/simple;
	bh=lnxadOWVv8xpr8z0FVu2GCFBkD9yL4UpZQuvIQMQcsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mAu250W4jGn3GV112BTKHIjWy6P6Sxa9ouGLCCxZrot7eVDzHMCvtP5C85t6CfCZYILsS8vMMKVVWWu2w7AkTAqKWnH613w74Y8QAyfR8HSXcBcnkDrr4aPl8h6P9THUarlifOEW6mRkJFgKiUX6ptHA5Upi2F3fgzwb9qzXJw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrPDiUlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrPDiUlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42C1C4CEF1;
	Tue, 12 Aug 2025 18:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023245;
	bh=lnxadOWVv8xpr8z0FVu2GCFBkD9yL4UpZQuvIQMQcsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrPDiUltkmoA/R1efkIcTe4zlLU+hByzT5JV6jHFnAceQG71UqKHK+B3nqSphPEf1
	 AkooMZl7G+4uHE0CJNK/xNYbVFOM7h5jfYLpUmOh+RnsbXhabtaaY+GwS6cSDx33Rx
	 tTS2pcPXwTed3HC416AD30vSVBLD0g2kxiNq2lXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RubenKelevra <rubenkelevra@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 003/627] fs_context: fix parameter name in infofc() macro
Date: Tue, 12 Aug 2025 19:24:58 +0200
Message-ID: <20250812173419.445566584@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index a19e4bd32e4d..7773eb870039 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -200,7 +200,7 @@ void logfc(struct fc_log *log, const char *prefix, char level, const char *fmt,
  */
 #define infof(fc, fmt, ...) __logfc(fc, 'i', fmt, ## __VA_ARGS__)
 #define info_plog(p, fmt, ...) __plog(p, 'i', fmt, ## __VA_ARGS__)
-#define infofc(p, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
+#define infofc(fc, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
 
 /**
  * warnf - Store supplementary warning message
-- 
2.39.5



