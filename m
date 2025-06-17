Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4A518A6AE;
	Tue, 17 Jun 2025 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174574; cv=none; b=W3MgkNhBXCXnyA60j/kx8UvxSBNKXD2ldPJqbOLTzsM+QwlqXgYYF1/koia+RXGiQzYk78RVsjuDITjJj5W5/UQykamkLM80QeE6HiMEz1AkINs5pweGG+0EN+uqICOQzSSDlFbl6gy05i8JtoSmV1PNNgPc1qw9PHEZRBAW2lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174574; c=relaxed/simple;
	bh=6AQhV45gVCmHzaE6FhajLni/ZG1G0qMGyKL8T1MNHX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qme3COCyQ7xfwiIdSrVyI+N3Ffj3nBJakjZ4sRwZIvswg6zwe6Qr5XefspMhN7bhyC/Flw+0aHmxDi6r7+xYqkV44Ep6+0XJPAevn5xIAD5DUO1adMjb2VK3gzxKhMvZT6aKf50m39SIS1x6YB3dcnWNXqaVMeI6RBx3uY1Qorg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMPwmAJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMPwmAJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022E0C4CEE3;
	Tue, 17 Jun 2025 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174574;
	bh=6AQhV45gVCmHzaE6FhajLni/ZG1G0qMGyKL8T1MNHX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMPwmAJOVSxq2LEgJwHVYeOEdTLU55254G7/r0Ta/MDT8m+XUNS8Xcy+WQP1HFTtJ
	 v81rSQgSbhMrRrW8xiATHogQ39LASysLG6b1k7cGLjINgoW2plBKlyH+27KeFKNa8S
	 KBc4X7WmBdzOkcSs8I+9Z9mY8k45nDO/pw0IUmW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jemmy Wong <jemmywong512@gmail.com>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/512] tools/nolibc/types.h: fix mismatched parenthesis in minor()
Date: Tue, 17 Jun 2025 17:20:03 +0200
Message-ID: <20250617152421.054801233@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



