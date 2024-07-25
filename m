Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098E19D8B8;
	Thu, 25 Jul 2024 14:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918403; cv=none; b=WImshXQvVn1Koq7OZCU+zhQKg1hphMrkEYYnoqKTSjhCP+i6zoIsvP3ddAePG45c6o/af4ZLQIoJklb/b+JjWFdtTTYyQ7IFELc/XmK3r2no/7wBRROYVA3WDFreJR7Cp3X4iFvvEH51zIisTDctTnvfx08D9ZnH06RS3W6l7sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918403; c=relaxed/simple;
	bh=BBhq5624r8n0DFX9jJsphUkl40luIhVJpnNCsUEgguw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqlN1CgOmkrf4Lx2bGbXRZzJbicD0aSM2wNx4d5ex94Ij6zuvZE93h+WGBp6spZ8ZFo46fYoebB3FjM2jpnhnlhhD/sTdnzBcXVEAHCVGOPxGWhh6jd7XIik6+rxeCTAnU2g15jhF0sd7oNIZvw0vRx9alufDf8uizi7s+lS++o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMDhPx4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMDhPx4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873F2C116B1;
	Thu, 25 Jul 2024 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918403;
	bh=BBhq5624r8n0DFX9jJsphUkl40luIhVJpnNCsUEgguw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMDhPx4y/u1pJo4lITlQmzzs31zIW9YfJFE27tLE0QzmkAumwIQNOdZRseQJOTc5+
	 4Uz5vgdFe0BdV9giSYAVhsklm7shK1PihwG8BGK6RgXDGo+fD5DUZrQZCUYhihEKhD
	 XIekdPLeEXyPCH2LVwwAs87UaT1uM1M14mMt6md8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 4.19 01/33] gcc-plugins: Rename last_stmt() for GCC 14+
Date: Thu, 25 Jul 2024 16:36:24 +0200
Message-ID: <20240725142728.570623587@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -977,4 +977,8 @@ static inline void debug_gimple_stmt(con
 #define SET_DECL_MODE(decl, mode)	DECL_MODE(decl) = (mode)
 #endif
 
+#if BUILDING_GCC_VERSION >= 14000
+#define last_stmt(x)			last_nondebug_stmt(x)
+#endif
+
 #endif


