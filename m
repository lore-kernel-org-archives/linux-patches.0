Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFDD1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028E4C433EF;
	Wed, 28 Dec 2022 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244008;
	bh=DjK8F8iE3Z01tKYaGE96lJvosdA9ktOtD+1ozokc7oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUnKDKZMya5hDm5nSYJjBlPGcODC5Brf9sVeNiua3gQMag3aqq98/5ZmX7xlbJgE+
	 Ekm8P3h+ETGukr4GuZS61pevm9xbuOBF7FVwDV40JzNGVzg4cbf7mgkl9MmgX91Ivg
	 yybbG9pWyPc0k428A+CMmtcnqaOxYOwhhNhfwlk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0594/1146] fortify: Do not cast to "unsigned char"
Date: Wed, 28 Dec 2022 15:35:33 +0100
Message-Id: <20221228144346.305005394@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit e9a40e1585d792751d3a122392695e5a53032809 ]

Do not cast to "unsigned char", as this needlessly creates type problems
when attempting builds without -Wno-pointer-sign[1]. The intent of the
cast is to drop possible "const" types.

[1] https://lore.kernel.org/lkml/CAHk-=wgz3Uba8w7kdXhsqR1qvfemYL+OFQdefJnkeqXG8qZ_pA@mail.gmail.com/

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 3009f891bb9f ("fortify: Allow strlen() and strnlen() to pass compile-time known lengths")
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 1067a8450826..5001a11258e4 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -18,7 +18,7 @@ void __write_overflow_field(size_t avail, size_t wanted) __compiletime_warning("
 
 #define __compiletime_strlen(p)					\
 ({								\
-	unsigned char *__p = (unsigned char *)(p);		\
+	char *__p = (char *)(p);				\
 	size_t __ret = SIZE_MAX;				\
 	size_t __p_size = __member_size(p);			\
 	if (__p_size != SIZE_MAX &&				\
-- 
2.35.1



