Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A02D19AD91;
	Thu, 25 Jul 2024 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918853; cv=none; b=peMm7Z7osUpEAtI6ucHp9pG2nZnO7GgsRKqxw73Ytt1jwOAcE9NSPtVbesZxMTAbevqa21xnYrzIHzjH6i4ohjjYJsPwfz/Jwy81JTBfAESt65JgipERdtNeTII7QDFzQBNrFk3CiFNXxDUh5MEAc176L6IwKRm3T6o5LHCA8rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918853; c=relaxed/simple;
	bh=Wocgy+wmWTiHlBeJpHTojMstwwAKhHzNd/OZm2NoyB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbv3pmBSKEMbpx7QMnXB5ScjTi8wZHhhSbEO/eGAPn9KphUoRyWuq63+tBK4fWyWq7Lzttmli+hH8dbY8g9BvGX2yI3/tJ3guq+goHUMUtV6yc59U5HdiZrA4ZqwNQjoeumOj4nm1ZC6ZvPSwOE0EMKGlNQcK7qnBfO83vL4u68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMzleGpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMzleGpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EB2C32782;
	Thu, 25 Jul 2024 14:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918853;
	bh=Wocgy+wmWTiHlBeJpHTojMstwwAKhHzNd/OZm2NoyB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMzleGpLnFFBKRptpWfpPzWvjPYYAxE8bpb/rt9Wch18nDx45J1Nks6dMDLylCZ/b
	 WmG0p+/n+Eq+iJZf5Ahz2G9Ptx8iW30glS6OrdrpkmMnvHgNg4qma+yhc6Ur7wZFAu
	 oZTXlZ7Kk/s90MqiWK3e372RTuSXykjIMcSYkfTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 5.10 01/59] gcc-plugins: Rename last_stmt() for GCC 14+
Date: Thu, 25 Jul 2024 16:36:51 +0200
Message-ID: <20240725142733.320110727@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 2e3f65ccfe6b0778b261ad69c9603ae85f210334 upstream.

In GCC 14, last_stmt() was renamed to last_nondebug_stmt(). Add a helper
macro to handle the renaming.

Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/gcc-common.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -980,4 +980,8 @@ static inline void debug_gimple_stmt(con
 #define SET_DECL_MODE(decl, mode)	DECL_MODE(decl) = (mode)
 #endif
 
+#if BUILDING_GCC_VERSION >= 14000
+#define last_stmt(x)			last_nondebug_stmt(x)
+#endif
+
 #endif


