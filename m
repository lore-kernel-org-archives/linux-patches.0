Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2552FD1CE;
	Tue, 12 Aug 2025 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020498; cv=none; b=NQbQAxZcqU5entt7IUNjS8FQMzFLUMCRuNKFsMh0T07TvZ38W8pT0ucpLkYRcxQf2lZ4md4Mb2iyod1VOWLp4qM9rfcF0LT+XvL4PgXQ5QY+u6pRGTLn9WPVk8goTa6aO2vHOiaOpJamIMjWGLuxq5uldNBJPCMxmTou1zFyZBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020498; c=relaxed/simple;
	bh=zo+Hr0DuGZKx8eXxla33YenwmvBfS7BwxfRZAu5dBAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIbCZbesa7oiLZ70Jp05MpbWeZdguhYrGIbvKZ4H30MS+qN6PK7nOsQGPVPRX7PPncU3Bm+vWnK9GY6Q+bBAcBU7uZekfeJ28qEfHmHUqvxQziA86MoAXxsa7rqYoeWicx3njFbGB2TJiin29hUALAYriFVGIm8y963DBujxlMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKI5lV3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKI5lV3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D517C4CEF1;
	Tue, 12 Aug 2025 17:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020498;
	bh=zo+Hr0DuGZKx8eXxla33YenwmvBfS7BwxfRZAu5dBAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKI5lV3nRe4sFnEBcMtTPhest0YYQ1WI540ByAikP/YEHKhYECDziQCsW0b0KgcAH
	 IXgZa4s9F0Mev24g5MQLs/bx/EtNwuhwIdE8PHTR2mgDjD4VPi4iUsz5FYz0rHzdIX
	 feW4Bax3isMafhC4ckFtq/gCPDYhh5uufdCW1WU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RubenKelevra <rubenkelevra@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/253] fs_context: fix parameter name in infofc() macro
Date: Tue, 12 Aug 2025 19:27:32 +0200
Message-ID: <20250812172951.454369534@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 13fa6f3df8e4..c861b2c894ba 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -209,7 +209,7 @@ void logfc(struct fc_log *log, const char *prefix, char level, const char *fmt,
  */
 #define infof(fc, fmt, ...) __logfc(fc, 'i', fmt, ## __VA_ARGS__)
 #define info_plog(p, fmt, ...) __plog(p, 'i', fmt, ## __VA_ARGS__)
-#define infofc(p, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
+#define infofc(fc, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
 
 /**
  * warnf - Store supplementary warning message
-- 
2.39.5



