Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126CEFC19;
	Thu, 25 Jul 2024 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919052; cv=none; b=ta6wReuootI3YMxgTbl1qNTqLhFbrKpbT9szWQ4LfSh/aQD+GWTkQZqLOwiL3TizSi5AD92y4hyKykRX3Tu7WEcrUx6SoJXc1NCurE7ZIzeOwqENBUCSRkeE4gIGJfmZ8OJtFI/suID5INnc3xa0xmT7SSztEsgfhqCMOMc2B2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919052; c=relaxed/simple;
	bh=EuySZPdNE+eRw/Az/90Z2+SSoyyBVSJTC0gDHTz74t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS74078awL6cSMwuAv6I6gkcKyhvCnnhM1sCcChbb/Bs2gKUqRPwm5YWuOmtH0ni6IAvppVQtY6CVZzbffY6rAIiL6lcdbsiMAq1glaNszIvoozsfZORQvgnrIF43L0gT4TDi+TYyYHBOXZG3vy8bDyLG2o4gVXynhESeThTpIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cr4wcyur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cr4wcyur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70234C116B1;
	Thu, 25 Jul 2024 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919051;
	bh=EuySZPdNE+eRw/Az/90Z2+SSoyyBVSJTC0gDHTz74t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr4wcyurt6A/7e7jWdCXKnlFr+5KZez2cexQAmEIbE8sEXtfv4roZwEyNLMZMB01f
	 mS7Jn4EifkRvyAtxkzErMNvSUxA6i3VeE96x6UkFnmYeMyUkzFcITakKbyvKMK73R2
	 6W0unV+BaJCzLvBc8Dmh6s3Aq5aFGvtCjkcHYWw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 5.15 01/87] gcc-plugins: Rename last_stmt() for GCC 14+
Date: Thu, 25 Jul 2024 16:36:34 +0200
Message-ID: <20240725142738.480817874@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -570,4 +570,8 @@ static inline void debug_gimple_stmt(con
 #define SET_DECL_MODE(decl, mode)	DECL_MODE(decl) = (mode)
 #endif
 
+#if BUILDING_GCC_VERSION >= 14000
+#define last_stmt(x)			last_nondebug_stmt(x)
+#endif
+
 #endif


