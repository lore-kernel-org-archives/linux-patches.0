Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209962;
	b=yd8XwPQ7YZAufrEtnO+YdwJQz+GIH19uBliiHssE/iFH30K7qktdk8nAr5QnPJWnkuQD
	 HWTD2FWRoOGHT7/EoD8cLz/vo26BF1BefC8xKs5hHZa9mj9mVdiM0h64gxYG3AvvmszNg
	 meuw0rEDB5C06TT4U3rjT6bjDiaeyrSgGJUP/r6Mtt1i91Hrf8VbG0LsYDqM5k+3giSCI
	 13LO8qTzyjRF39rCaO2uXFzw+RmzcMkNfwABDEGHJPshTWtFC6P7GQpwZmrl553E8Jna2
	 DRB6VFbWIJVtxF0KpnMel7NXMCWbT+HAXbtuo7IhgAAFKcdM3l6qyHQAuwoeH7M6/rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lilPGYOVTMcE5U1YlXRGAL9Nc/i/bAjTtIZ6joq0C1Y=;
	b=i8B3nAabm7aAp6/ERQZFEL9T1jtBG7rQWxVBhsfVHtmlxhrr7MIVLnXa4zdlBcs/TDeN
	 m+ynIyaUk0oPrOBmw7M7mfcgUg2e0ybu3bw9fSx/0pmKs80N9cPVXzGj7Jl9cr0oTImp9
	 PpSkWt0Gran7YZ6CkAWjNeOFhkPe7eL8etKnarPAcwra65yXIhHAGlG4LMyFdwCK1gINi
	 2b2f8mIKn7uF9zkSW9uApBJSbG4CuXvIRAZMnfV1UoXUYXvMzZIjlBLIhbqFwr8Ou2dYl
	 PwDf5fW1U4WYUKcYH9diNImeyk1CwzHXEv2p3ogvColsdqmlq4Ribx510q4zC9CoBoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJXh6O1O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF7E606A31D;
	Wed, 28 Oct 2026 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJXh6O1O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADA31F01825;
	Wed, 28 Oct 2026 17:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209962;
	bh=lilPGYOVTMcE5U1YlXRGAL9Nc/i/bAjTtIZ6joq0C1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJXh6O1OYCqACxOyFVtNlTwpN8faagXiW1qhD8wnLzxCmrMClUiqR3qgwLA3ZM1Ls
	 IBi30/1DteuCUNTEuUDXj+NhPt84hn41W5rPC+GGHyNs44xokWFBEeMkMIVByVayBX
	 N86HMEHkQ3bwjcGE4AuqgqRO9av1wvXNjD2tJV1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 028/168] samples: pidfd: fix userprogs typo
Date: Wed, 28 Oct 2026 17:59:24 +0100
Message-ID: <20261028165943.764633537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



