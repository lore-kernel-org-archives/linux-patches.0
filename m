Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15FF1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Crte5m94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6133EC433C8;
	Wed,  4 Oct 2023 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443854;
	bh=vWX884+Z2AQ/3kFJS+MhbYFtMGvWvR2DjyHaH4k6Ku4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Crte5m94dvLow9naDGKV89TV65Bzxz4SIkkIZW7kiDsry65g6ae6rxcpaVf9jf0Qz
	 8Hj2W0z+9ceZFbFi8e0v1qDshsxWX1TLrl/m1bLCO12bGxZJgUte3w5AR99wHZj6KL
	 32rQwcDHzZZEHRTzBLMnzlGBWDn3CeAPMoo0VwYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 043/321] uapi: stddef.h: Fix header guard location
Date: Wed,  4 Oct 2023 19:53:08 +0200
Message-ID: <20231004175231.165026385@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 531108ec5b5cd45ec6272a6115e73275baef7d22 ]

The #endif for the header guard wasn't at the end of the header. This
was harmless since the define that escaped was already testing for its
own redefinition. Regardless, move the #endif to the correct place.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Fixes: c8248faf3ca2 ("Compiler Attributes: counted_by: Adjust name and identifier expansion")
Link: https://lore.kernel.org/r/b1f5081e-339d-421d-81b2-cbb94e1f6f5f@p183
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 32a4ec211d41 ("uapi: stddef.h: Fix __DECLARE_FLEX_ARRAY for C++")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/stddef.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index 7c3fc39808811..c027b2070d790 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -44,8 +44,9 @@
 		struct { } __empty_ ## NAME; \
 		TYPE NAME[]; \
 	}
-#endif
 
 #ifndef __counted_by
 #define __counted_by(m)
 #endif
+
+#endif /* _UAPI_LINUX_STDDEF_H */
-- 
2.40.1



