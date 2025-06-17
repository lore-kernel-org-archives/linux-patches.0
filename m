Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C882DFF0B;
	Tue, 17 Jun 2025 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175216; cv=none; b=U3vgx7IHc2+4ACQrX15yHZqbwETPSmOy3LreoUlXt4sJVeiRTKwNGoGBzxdmEJUjLDFqpSRkz+SU4q2YtK0PSLdc+N5aucr3NziffrK45mn/14LMIvdpnR1cGWE+8BPIH7plohFLo1aTSHStrDoU+UNRklJcESmuNn4mE2CbvzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175216; c=relaxed/simple;
	bh=eKNcDznkQdiXkXyLbBF6UjcIQ82pwKswGRhpANW9sSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCGoey6IXE0mbajZJa2ForKXmEEJvapGsWYsAhjTQOFjvIrciHiw5/JUHUFZO1LJeWVc61C5mgz37hjkU13IylQDTYXesa/b/ZFP2RN12PgyIwp8KHF3/VizlmyvBjlyfqYlJsWdATdge0UuAshPnCVBw2izEb0FUco+t1MafKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z172bEMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z172bEMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346ECC4CEE3;
	Tue, 17 Jun 2025 15:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175216;
	bh=eKNcDznkQdiXkXyLbBF6UjcIQ82pwKswGRhpANW9sSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z172bEMvHFnnEqYHV++vR1OTfE3GOI1iktHfLhf38iiEhLR2Cm7B4Y+yR4Iywlt96
	 Y5LOqWc/xR4KD6R5GSeMGerZIBuE8G1VPs5eg3R+9BIOaYv0DzCvq92UNxAUZqPKf0
	 Q1NRCFK5KeDUiHoCcUtwTcV2Un8hybtPrQYvJCSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jemmy Wong <jemmywong512@gmail.com>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 054/780] tools/nolibc/types.h: fix mismatched parenthesis in minor()
Date: Tue, 17 Jun 2025 17:16:02 +0200
Message-ID: <20250617152453.697433830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jemmy Wong <jemmywong512@gmail.com>

[ Upstream commit 9c138ac9392228835b520fd4dbb07e636b34a867 ]

Fix an imbalance where opening parentheses exceed closing ones.

Fixes: eba6d00d38e7c ("tools/nolibc/types: move makedev to types.h and make it a macro")
Signed-off-by: Jemmy Wong <jemmywong512@gmail.com>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20250411073624.22153-1-jemmywong512@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index b26a5d0c417c7..32d0929c633bb 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -201,7 +201,7 @@ struct stat {
 /* WARNING, it only deals with the 4096 first majors and 256 first minors */
 #define makedev(major, minor) ((dev_t)((((major) & 0xfff) << 8) | ((minor) & 0xff)))
 #define major(dev) ((unsigned int)(((dev) >> 8) & 0xfff))
-#define minor(dev) ((unsigned int)(((dev) & 0xff))
+#define minor(dev) ((unsigned int)((dev) & 0xff))
 
 #ifndef offsetof
 #define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
-- 
2.39.5



