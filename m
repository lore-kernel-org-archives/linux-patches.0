Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E5644C77;
	Mon, 23 Jun 2025 21:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714253; cv=none; b=WmacNFkC5Sjj5Ks+7/HOIdE4z85t7Qjw7dCTtoHppOSitGklGMbc02LY54h1f1FIveOY1qAFrqs9npF9ND7r3CZQ1KY3cl7vO0WXtp2tcm+tp/3L8+L5ZiARJA14+HsrmdcocufkRG4fvj+EkcVnpgxeZZN7vv/LEHiS32CM5PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714253; c=relaxed/simple;
	bh=FxyB3uJ6krmaWHZigvjDrivY80o4UlmrMhS6daBhLp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htboQXMxrdGeWLBGKmDsJKeqwy9dNk+qYXsgz3+FhDR0tR6HaPicPgA4ZaXYhvyoDw65c2TVzAeO038j7K5xrAuiUV4uX9WssRxjhip5AEVV959JmAMRIyBcwhNqC2HGd3p4CQis9TTS+CUrj4h16EEchhF3dJH8o+JJBJV/sBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5hA+gc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5hA+gc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C8DC4CEEA;
	Mon, 23 Jun 2025 21:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714252;
	bh=FxyB3uJ6krmaWHZigvjDrivY80o4UlmrMhS6daBhLp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5hA+gc2AokKmjOfaMOWwa7F3PO1d6sX6APWcunBNxCvxUBM0Cdl97zhhMGZj+HDi
	 +h/w0ZWyep/pDDt5OH6W4uZW2RIttnKJ+rHHwMcihuGnbiYVJ+CMngF8j93NAH5Q7g
	 DEzz6isMh9lX9JnVgkh4U9L7bJ/xNch5cjJwc7vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyong Sun <sunhaiyong@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 372/592] rtla: Define __NR_sched_setattr for LoongArch
Date: Mon, 23 Jun 2025 15:05:30 +0200
Message-ID: <20250623130709.289779825@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 6a38c51a2557d4d50748818a858d507c250f3bee ]

When executing "make -C tools/tracing/rtla" on LoongArch, there exists
the following error:

  src/utils.c:237:24: error: '__NR_sched_setattr' undeclared

Just define __NR_sched_setattr for LoongArch if not exist.

Link: https://lore.kernel.org/20250422074917.25771-1-yangtiezhu@loongson.cn
Reported-by: Haiyong Sun <sunhaiyong@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index 4995d35cf3ec6..d6ab15dcb4907 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -227,6 +227,8 @@ long parse_ns_duration(char *val)
 #  define __NR_sched_setattr	355
 # elif __s390x__
 #  define __NR_sched_setattr	345
+# elif __loongarch__
+#  define __NR_sched_setattr	274
 # endif
 #endif
 
-- 
2.39.5



