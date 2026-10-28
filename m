Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211750;
	b=1ZP14P/qRAWiF6aQ4EVZBUWGp4fWLMy7TyZwAo76jnGDQ7TOib3//xMvUwiBC4HpyNy9
	 JZxHKOJBrsS92d2mZXmLGRUWarHlHdjzzwekGgROWvUTgzLmkzSAMfgmr5b/iAPSu+l0z
	 fKAZrkd6H/CiWytZFy43LbCBp1DDhVeEUm+YZNepkeJCA2ulPR8pgUl6NSFu1qTPDTWpF
	 BKR7iGHzbojEIHOeeu69ZHyfNfM4NSME7qZMOIrasJe3r1errWAbkTbu2hpwCyg5mdHR5
	 n3C1w3sBwT5EhOx9fKzbGJENLQVXGNj7mFVd4aC+IA7p11v8UcGEfG7KgypOkayUP1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xfX3nFMZBoiwHOzhmvw5lQERsx7q3VnC1QBoKUQ/Pag=;
	b=UtjLiqJkxBbDhmpzJsDfwZyMMN4DjzMQQg0dPc9/VqdTmxTKjxKDmZGd3PreucEJSAxe
	 XzQkEwFFd8eeKk7ZlU1R8UlQW8vTiKLY74DFt4cDqoX5yx/FIelt38XfLeYHnUBOmkR1P
	 PYuF/tVcrL2PYe01BEeiv/z7uCG1DzG5rOa5a3C2qiSODYNRY/hFm1WQ5GJs4ViZAQ9pA
	 Sy7ODWBSdpT1RzbxaqWXN1Q92BVeNvq5vnP86xjmbMYjAAlbk002XWKhyp8NDgPf+dJ5Y
	 Sb3gsWvxPlzHfrjJblem+udVS6c1rAyCxf3+HIy9hcioiPxLB0PTWbYXNizS+e2DmYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sy3E698K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55B0606A321;
	Wed, 28 Oct 2026 18:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sy3E698K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D767D1F01825;
	Wed, 28 Oct 2026 18:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211749;
	bh=xfX3nFMZBoiwHOzhmvw5lQERsx7q3VnC1QBoKUQ/Pag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sy3E698Klx7CL3fv4aHI63VX3YZ7L4RLRcKIzz3b3br3of1Un/1VQ0flymZ7Lsgqp
	 Xl2DpjJZY/gfWnDwdjntf1WYfu8JVPmdf0O0jaGWIPMnlIv8vK7hZr9foa30bLiinN
	 tiNYc3QhD6WzJM8DP4SwQu0j6WEw+lFLliziXOVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 487/571] samples: pidfd: fix userprogs typo
Date: Wed, 28 Oct 2026 18:00:34 +0100
Message-ID: <20261028170019.583329974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



