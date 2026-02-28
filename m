Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B554A346E77
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302266; cv=none; b=fHknR3I+YygmZFcZiWtmElKNRhbyIGWjkHojxPZ3KlhvqWY2nCJnuUwB2Z+G37FC694EHepa1WWjmaJH0dpChFGkhAn4uGBHOn+q6mFm98lycSHg5ngu8/7zzra5sY0uapegl/lDJsjeVdQeBSJMqJd+4Fd5UkoqXUoQRQNq9Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302266; c=relaxed/simple;
	bh=uucSd/Px4AStzZWLWuoG0hJj3VgEdsUIsitCWqAKX8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aAqjoqnoRd74uB0/9wZSGHyVazm7eCB6PCoAwLQvA8D8tX7QryKDao8IWDzkjAF5zkphyyRpaQTJcMYdB/6KhKPyeuyjnzC8PLtohmXuYDpYBuwSRttiPwtlqylY1EAHd/FwFUB/2q/sK5PtJcHLPPQWvSNauwyIH8JSWlgwY7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZCmJMMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZCmJMMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470B2C116D0;
	Sat, 28 Feb 2026 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302266;
	bh=uucSd/Px4AStzZWLWuoG0hJj3VgEdsUIsitCWqAKX8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZCmJMMxuzpvDEuDMwGlSuUQ4SLTQkGLDN+E+iE7p95OtcJZ/4TEkvAhJP/HaHa4D
	 C2Yjz0v7i95jMca19S9jT51JERcqS904wszntoey3SQig8kZQi2RVPARhn8/dMcUTU
	 GUd6eJ5nYqAusS9oyxyh8Pn73+PH49c8OXrx9HjUkHIFdJDLRJRyfWQBfA+bN83WnJ
	 oshA5x6TWP68AhRECtSxBhu7I4hqUp1Cj0AlFALTOnNnzZV1xIhBgBxCMguSmYNHVv
	 Lt5WJXSXd+2soSYJzZVO3BYNm0gKae5TY/f8dUwHNGsTnaLXgsfcAkq47H+Apx3+BY
	 PpZ1lEs+F26GQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/283] Linux 6.6.128-rc1
Date: Sat, 28 Feb 2026 13:07:05 -0500
Message-ID: <20260228180709.1583486-283-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1c7555ea8b06a..728e195e6b190 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 6
-SUBLEVEL = 127
-EXTRAVERSION =
+SUBLEVEL = 128
+EXTRAVERSION = -rc1
 NAME = Pinguïn Aangedreven
 
 # *DOCUMENTATION*
-- 
2.51.0

