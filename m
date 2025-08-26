Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010F41DE8BE;
	Tue, 26 Aug 2025 14:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217261; cv=none; b=TA4URZJI8SoQhwm/LOE1Aq10xVulDm1YhswP1TkJySmP6zh3/0VBLm5NBBJ5WLbgwQuLnOV4JDhXhgtlJIKTDFmk0s9JXrtXt5W271Kr7wBrZxVKbXSdiuNUXGRpxBrI6ed0WfhKCWYBqPT2+sAFfvJnZkyGeeWDZryhJY7I8Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217261; c=relaxed/simple;
	bh=tWD61AE5KaPgIJ/8L7Wd38qX0eFRL583cUe4cggrP3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TCCkMY+tko7gtQYhOzqtEOB+cCHX9vdTGmscGnXaOPLRoXuvf/q3gBLvQzqVJByMQUTAkP9vPN1qbpQjS///7kDBKmqnN+TTPkyhWK54xD3wYbwjk1zCfXvIlBn41au2ep90hx4/71F9G3L7aJhwkvRKYZc/ErzoqGPaJKiaL6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZK/fLg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZK/fLg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88709C4CEF1;
	Tue, 26 Aug 2025 14:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217260;
	bh=tWD61AE5KaPgIJ/8L7Wd38qX0eFRL583cUe4cggrP3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZK/fLg59N/SRu1rAJgcvFXWhkEHa/+dgnGAAMAKjpQGhLKWMcmVBRmwPthhIAYSS
	 D+o1sbrwzO+CdHQ8kPXIVK/pEmLQzGWk4Jr4DI8hnyIlsXdTBTpqcY5IyEy2EwzpxL
	 1xF3iSwI3AcKI8+hjzZEetCU5EZfL3qjFzhh4p+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RubenKelevra <rubenkelevra@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/523] fs_context: fix parameter name in infofc() macro
Date: Tue, 26 Aug 2025 13:04:47 +0200
Message-ID: <20250826110926.466853665@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e869ce3ae660..40dd74bdd9fb 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -207,7 +207,7 @@ void logfc(struct fc_log *log, const char *prefix, char level, const char *fmt,
  */
 #define infof(fc, fmt, ...) __logfc(fc, 'i', fmt, ## __VA_ARGS__)
 #define info_plog(p, fmt, ...) __plog(p, 'i', fmt, ## __VA_ARGS__)
-#define infofc(p, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
+#define infofc(fc, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
 
 /**
  * warnf - Store supplementary warning message
-- 
2.39.5



