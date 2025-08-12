Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C96B1EF38C;
	Tue, 12 Aug 2025 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022032; cv=none; b=fY4l+HvPJorJxVAtHQ4hvw0f88UbcQAenX0HvoeVIU0mUdtVz40Dkixoy6zpBQjiw4XuKnMHqZBBEUNKLm11/D48IwGpo+nCQuayjEh4iOW5BApHLHk1XisTx38yVS3rgWaqx7uGUath19n5XMgaZ7tD8HUNA63gvVqXW0OMahE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022032; c=relaxed/simple;
	bh=fONZAvpwSYFc2ebhFG5CoieefQhMQvwu83BSrttVrL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ep9XKy7lM398P2DBOWYY6ehdfJd9aL+SORDaNI2gkpGcht+RDUIy6/fsqBN2UXt6vvW17UUPDOc7XlI8ZBIdx87MBhvsHb8fZTEWrYAwAw0KpO42U0qYAJYjuonq/BykjZbe189XU6PYe/REpLAYH9K6Lc1zZ2ktdl5ModZG6P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXDflS2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXDflS2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795EBC4CEF0;
	Tue, 12 Aug 2025 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022031;
	bh=fONZAvpwSYFc2ebhFG5CoieefQhMQvwu83BSrttVrL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXDflS2Yts3VuxK5YpbwJxby+xNrGhLCKAv94urACKwVak8SUMFdAyiZKbY+JJc9x
	 pTtikbOi4AN7Gn1vmOUuQ7m8Bv7akOxR/8duHbCMPbuWdmifDLOnpWoHaApgJAF6aR
	 d6tYzrXhRpBjEjuUcZ4WUWSK4yzZsxZ8LV7dL20g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RubenKelevra <rubenkelevra@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/369] fs_context: fix parameter name in infofc() macro
Date: Tue, 12 Aug 2025 19:25:06 +0200
Message-ID: <20250812173015.093878835@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4b4bfef6f053..d86922b5435b 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -202,7 +202,7 @@ void logfc(struct fc_log *log, const char *prefix, char level, const char *fmt,
  */
 #define infof(fc, fmt, ...) __logfc(fc, 'i', fmt, ## __VA_ARGS__)
 #define info_plog(p, fmt, ...) __plog(p, 'i', fmt, ## __VA_ARGS__)
-#define infofc(p, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
+#define infofc(fc, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
 
 /**
  * warnf - Store supplementary warning message
-- 
2.39.5



