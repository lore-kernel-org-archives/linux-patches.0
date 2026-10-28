Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209358;
	b=EK0BaPYU18uBwCp0xSyN1i0R9w7GE4mKS01ucNgANmFL7IMBEjEN+1uoPxz7ZHYc4DQ6
	 xicBK5UjRmHOivvSq3LqjrZhJHXuEiUITdeQVxPfDnV2Ux9ho1HI7Bf4LmDY8+Bk7L7kS
	 ltBilGZ+J42WeL1hkaKeEJSomhx6a+fR5bRkJ/kcCxoq14y0hzqbA5HH6RMVTvcZXXAI6
	 hUBBFiCoWkKSoO95SxYGqLGROZyld3eZNzqhORFIGnbfQFyzHvphSpjXHQD6sxQxWCW72
	 ucLmxprqYPqRlK0KR0NrTBCUFuBg8fRkebVBCKixnTS1kHiwkM3AVlnfqKT4q+ImTLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MRKtcp3BlZ5yjaS8WVVeTz6aFpuUSx9yOvVREbt1yhM=;
	b=m2WiVUWrrwO0IEVtzok6lKrlp0MtjOPyDRR9w797Tmgbs84oOtp5W6MbmbZ3yV2tYlJt
	 maXH1ON2LRHJ+YEr9IU+kUYtpMot4ak9Kt66WQ/X4Kwe6MZ5Y6bFMxISDq3BU3/pYcDhU
	 4M1qK5JY422lfvWZ2toiWicY8y6RE3+MzhEEbRKrmuPNH3G0bAQvzi089oZaSvTRg+WjY
	 Xe4JWXdqkB3idS2h3mf7ZQgfKEEK1CnbXYYXCbj3/WK2K/y5+je8LMG5ab0HVg73E8J4r
	 WPZfc7WcdgyBHgH/+yLW8xhS+Y40E3KZvI3FSgS9DdUhHE3GlnF1cc+6+N86DSLcutA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TF1Qz1i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45052606A31E;
	Wed, 28 Oct 2026 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TF1Qz1i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FA91F01825;
	Wed, 28 Oct 2026 17:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209358;
	bh=MRKtcp3BlZ5yjaS8WVVeTz6aFpuUSx9yOvVREbt1yhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TF1Qz1i0FbYkzCr+hW2uJYKBzZrVSFO0YWsJjJzGOmY1Bq8mPPrwIZNHEu7ApQya
	 dRtAbIB+E9ic6Mic4RQ3HDavsRpxyXxezsatq1e7ojNbU5fn7k1flEdsK+DpsvY4K/
	 3UIy1uNBfUDSo7UqWhABN8Kz7nLdE80lMHcivUNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 443/516] samples: pidfd: fix userprogs typo
Date: Wed, 28 Oct 2026 17:59:55 +0100
Message-ID: <20261028170013.977364972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



