Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B40B1586F6;
	Tue, 23 Jul 2024 18:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759184; cv=none; b=SSA6PyVTtD+7KON+XA+gKskELB+4T6wSO6iui8KrIrufr9S7P6K+gMtOBIUxzzDE9uu4CSk3/8NMrGbf3xoFshxTSJtOSUrn5svn5Ir+EuZkculL3i1DA/pvU0i/1Fn0bDDNRqha5mbvv2ghOsOF4vdSN5zYzhd1xcIjJJrn/AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759184; c=relaxed/simple;
	bh=81OUEri3GPnAfaX8GRTdmu/HoPa7IYPp3W6DyT+GV9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bku6o4g9xZgQjqZxZXYg6vXjnv95RKJaLxGcv+gJElg2pIpn4OqeOzhQRSut7Y7zDa8nRG+CNtqqHgnkmQcnWvH64ScoimSeREYqlim/zF4DzXbuZoURUuT8ZOENikSzuicT9ZsIMLURiJ8XXRC38VIVfyV7N/4GIGzV+Wht09I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eK3JbMAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eK3JbMAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4824C4AF09;
	Tue, 23 Jul 2024 18:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759184;
	bh=81OUEri3GPnAfaX8GRTdmu/HoPa7IYPp3W6DyT+GV9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eK3JbMAbvB4A9WUiIvEhR/gnAHzwKo9msCS+mcrT+I6pyC/Pm1SPWNMi6Me17v8Jg
	 OwtW6UEPgkOmdTVVHbFfIW6QhxOP9+H/JmDj0peYdqJtZrfGbvRyyEOY33HjlPrM8P
	 XOy83IOyJk751LiCjcXr5zPeTizZuQZELWlWUHRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 6.1 008/105] gcc-plugins: Rename last_stmt() for GCC 14+
Date: Tue, 23 Jul 2024 20:22:45 +0200
Message-ID: <20240723180403.003699933@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -440,4 +440,8 @@ static inline void debug_gimple_stmt(con
 #define SET_DECL_MODE(decl, mode)	DECL_MODE(decl) = (mode)
 #endif
 
+#if BUILDING_GCC_VERSION >= 14000
+#define last_stmt(x)			last_nondebug_stmt(x)
+#endif
+
 #endif


