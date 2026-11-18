Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017906;
	b=YMCaaNo+bnTZKYaUs64i+4ayACkv0h88klz5o6aZvWsTZf9LY7htTNr9I8py1Cqfb6hM
	 rZL8ETEyTNMnJwUc8vnwYPrAFXMjpkcZRnek8jrgW+yynM+m4gdlswXKRk8iiQLLzaa5H
	 n7WAGnXWpCZ/DpZGhEhhQpM7jCxNB40Ww/ALNKBFJ6npLylOZh9PZJDVNOddPvJDceYV6
	 B+X3CyQg8Dc6Xs3kQNql6Xn/udzdNp3Q8sl+2DBtTXr0xuRGZx7ZXiChDOUNkXdZqZzZs
	 au/jjdPV3cvisMF8S2DMyMCBH2POZ8eE+pSTced/RCkR6OfzfT8No5FY55hY/Ws7sWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=emB6qpjIMtjeMPYatTyiPX0xCIic0WAMkOEZKvOEul8=;
	b=eDUbFGuP4F6Nn9ku3B36sMSHtG0HH9QgAFJbF8V2lDRTvepelE9H1Y+lFgMcMTt/0CX8
	 0uqDjLDFG9l9Cj9YJXhwl7b7TOvpAi5WTW0wLFr0j4bi1WPoS9VynP9WfLZtzWiU+JskW
	 RGwDvlty4ErwTQrmWSbYvwkpi6cojFawXRQbo+KHLLALPCoiNUACzfvHuU2AcTrF2fmKR
	 RcWDGE/sni7j4D51VeNGYEuWbrlp9bBz8Ke6pnMtM+nS5HiOXMe4s662jndxUnv2CEoZT
	 tJBca9f6xkhknst2rzUIM7caRx2X/wr6t9IX1WWdA61AriBndrUj09USdgpolXvRTZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1hxNEuD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8901B606A31C;
	Wed, 18 Nov 2026 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1hxNEuD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8881F000C4;
	Wed, 18 Nov 2026 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017906;
	bh=emB6qpjIMtjeMPYatTyiPX0xCIic0WAMkOEZKvOEul8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1hxNEuDfw/ndnodWTKmZ11WRBVg5dY5OLExVCiQSqSC7ryUmvL4qPsf+Z/4WVka6
	 +1zj/ZGiOJHt0ia3mrpJts1hWw3UzphvQaDr7iP8Um2YwqCr+J8JwApyTMpDlCYPbW
	 4ZvbNwaVcS/cvF6V5vy1W0NreCZbLaLqJb8GvfOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Askar Safin <safinaskar@gmail.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1052/2651] kbuild: Mark usr_gen_init_cpio as no-dot-config-target
Date: Wed, 18 Nov 2026 15:38:12 +0100
Message-ID: <20261118150325.844067276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Schier <nsc@kernel.org>

[ Upstream commit 14e2c1f5431a03478ed4bbf2e72298c769f375ac ]

Let usr/gen_init_cpio be built also if there is no kernel configuration.

Askar Safin reported that gen_init_cpio may be of use before any kernel
configuration is available.  Add usr_gen_init_cpio to list of targets
that do not require a .config file.

Reported-by: Askar Safin <safinaskar@gmail.com>
Closes: https://lore.kernel.org/all/20260220191150.244006-1-safinaskar@gmail.com
Fixes: f8e05c10631e ("kbuild: Add top-level target for building gen_init_cpio")
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260928-move-gen_init_cpio-to-scripts-v4-1-f437a33c40ac@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 51e278ccea9c5..d0ba6f0aac017 100644
--- a/Makefile
+++ b/Makefile
@@ -298,6 +298,7 @@ no-dot-config-targets := $(clean-targets) \
 			 %asm-generic kernelversion %src-pkg dt_binding_check \
 			 dt_style_selftest \
 			 outputmakefile rustavailable rustfmt rustfmtcheck \
+			 usr_gen_init_cpio \
 			 run-command
 no-sync-config-targets := $(no-dot-config-targets) %install modules_sign kernelrelease \
 			  image_name
-- 
2.53.0



