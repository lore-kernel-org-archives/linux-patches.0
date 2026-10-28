Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216911;
	b=TMV3IkIhk0RX+zKrgl407p67ahxhNoUqDXNIambN4XXNxdOh49Rjt2uRvWdzvRd4/je5
	 j1lfAIjxcVVCaHKvYwBx58W6SZGO3UZXl8pIEA7euGvlzuWA+eeJd8JXw5BBsR/o4NA3j
	 v5GHs3WHcocPdYUiRRnj29PovVWUpeltKfelxZwNjLaalp/BSXDpvr4yYL46EYVxggpzS
	 ZysIvptmqTiFb41tb78G6LMrqIM/AvtD7H4lKQpEkKqSeihFMuirehWR3/2SbHmbBZ9SB
	 gm+RC9H36QZpT/XV6izRDzRXEp2ynL+gjYihqk5Yzy3QnV5HnyM6E0mWVMqBmnEf4xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v7iPdFXvUvooUUVufE/zJAexTDHO7oqJn2POOpg05fs=;
	b=kZr55rQhvgz5+1P10u0NcuOtnXQJRwCEMhjg20JCxSbVvioiJuVNGFch5Jx+BmoOhsEn
	 qwvSZlFRHM59cVgWeTeoDvfKn5EC7luETJ40I1oaMITqYvCY+75XlmJnDSwj7X449sWpl
	 gBEXVCR4NT6ntA4q/JRB4gYzdu9pIyxu+Gvqh2SxAX5dLxP75orW4N0cSXY1vIJrcA3kT
	 OE/4ROITUTovUJOXfsrmbO1Xqwu26XQN3N5/aHT3ETYKGopYbmtwJE3kNAkRfLUn9pW9R
	 WOuvY15s8LU+R5+RoUrMlDwJoAJb1t/eiSxFmbILYHVagNXPaisrxOvIm0SuJfHspaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjuV2UWj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05646606A31A;
	Wed, 28 Oct 2026 19:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjuV2UWj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556101F01825;
	Wed, 28 Oct 2026 19:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216910;
	bh=v7iPdFXvUvooUUVufE/zJAexTDHO7oqJn2POOpg05fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjuV2UWjl2IfH1tStK6VP1ntvTty73XhOwpDF7txxCygjIG9DxnZyFT9F/1J91GFI
	 CEPkI5ZiF9/NQwXJ9zqqGS26FJaKMe+tHxYDSmUwuCqS22Ku6SUqOFUcLSTHYZp1tL
	 Dsh0j5tEqicHbmshjqugfrxB+cRX/lg6jV8kKK/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 1721/1887] samples: pidfd: fix userprogs typo
Date: Wed, 28 Oct 2026 18:03:37 +0100
Message-ID: <20261028170538.623246218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit f1365f97fb7498d805981102eee22d362ae643f2 ]

The Makefile adds pidfd-metadata to "usertprogs-always-y", which kbuild
does not know, so the sample has not been built since the conversion to
userprogs, even with CONFIG_SAMPLE_PIDFD=y.

Fix the variable name. pidfd-metadata.c builds without warnings with
gcc and clang for x86_64 and arm64.

Fixes: 60fb0b1239719 ("samples: pidfd: build sample program for target architecture")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261011223358.2327625-14-sashal@kernel.org
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/pidfd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/pidfd/Makefile b/samples/pidfd/Makefile
index 9754e2d81f70d..d82409f7061f3 100644
--- a/samples/pidfd/Makefile
+++ b/samples/pidfd/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-usertprogs-always-y += pidfd-metadata
+userprogs-always-y += pidfd-metadata
 
 userccflags += -I usr/include
-- 
2.53.0



