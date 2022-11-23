Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090A31C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559D6C433D6;
	Wed, 23 Nov 2022 09:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195619;
	bh=hjdF7tiMIelbbfSFs+dcstCCLuL2lsK2PLVN4UEC764=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aevyXi+YYyykGNgiw7/bYRol1Wx/YmvMEK07P+DNsssitlxeMYnMtK+JzURYLxX5+
	 7S6C8BWTlJ+miC/yZ3FjDDMUhrc0xRYrnzcQOAUKFh7bgta8gnAC1I1uCTuEiYwF2r
	 vomGxLUYC4DZMksPme0FJ7rlQiU8sP3fSEb3QFDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tadeusz Struk <tadeusz.struk@linaro.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 137/149] uapi/linux/stddef.h: Add include guards
Date: Wed, 23 Nov 2022 09:52:00 +0100
Message-Id: <20221123084602.872382606@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit 55037ed7bdc62151a726f5685f88afa6a82959b1 upstream.

Add include guard wrapper define to uapi/linux/stddef.h to prevent macro
redefinition errors when stddef.h is included more than once. This was not
needed before since the only contents already used a redefinition test.

Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Link: https://lore.kernel.org/r/20220329171252.57279-1-tadeusz.struk@linaro.org
Fixes: 50d7bd38c3aa ("stddef: Introduce struct_group() helper macro")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/stddef.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -1,4 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_STDDEF_H
+#define _UAPI_LINUX_STDDEF_H
+
 #include <linux/compiler_types.h>
 
 #ifndef __always_inline
@@ -25,3 +28,4 @@
 		struct { MEMBERS } ATTRS; \
 		struct TAG { MEMBERS } ATTRS NAME; \
 	}
+#endif


