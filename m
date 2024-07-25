Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFC019D074;
	Thu, 25 Jul 2024 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918517; cv=none; b=cdvj4NH8nfuxptDfk1XWqvC+Col3wU0+Ggfe/mMaZ5pgv+6izZ7SN/xK/nWPf4CyQCxeAIyp4YQjGmLRmSyQrKq6jEzpUKlW/GmqKvNvSsOfa1NxRR/4OO9mwUNQ6uJ85fo5tnfrXLlz+zvCRxza6kSml2f8DtZmYN0BFpfQeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918517; c=relaxed/simple;
	bh=Q87Itkeu+oh2QMnsJVyfyGEFzEbLYyPvGcFt+vtW0MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZtr6iZFfEVd4VlF1aLeI27S0UMhvOCaGrwzC3s+Gv3/c9JW0nIjsnbeccHLO3wcXfJ0LPhxng+lENPKPr5UPxGDshrZR/4bYO7HKjaADaCiiUlcZ/Rw7SJpYktwg4GFuuX9cHvJrvVBarSABmQtDTTZ9aEmOWmbxmAgpjv8xs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdVyt89D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdVyt89D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B3DC116B1;
	Thu, 25 Jul 2024 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918517;
	bh=Q87Itkeu+oh2QMnsJVyfyGEFzEbLYyPvGcFt+vtW0MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdVyt89D3B8OKKRjrQW3rURmJO+NEjBdF4L/vPBi2jo4cQ/eFABLC0DcBCJZEGg0M
	 R3V4jVkaAUrib1F9/QEeQ+nLFK+vZeShKabizCSjcFT2apHoNMNG5eisyOgu192mW/
	 sITYJ9mpc2RoK930wPlrfurhQtWGfZ7x0VymeJWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 5.4 01/43] gcc-plugins: Rename last_stmt() for GCC 14+
Date: Thu, 25 Jul 2024 16:36:24 +0200
Message-ID: <20240725142730.528395904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


