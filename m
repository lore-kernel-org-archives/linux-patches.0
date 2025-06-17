Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5501E8332;
	Tue, 17 Jun 2025 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174285; cv=none; b=mZ8WKmVE8TEEOhOTyZ/T/RJcA8XLXazRxeAK0N7X/sWZJkOlNsVTgIpBRu8Ew8SnlsFFq1qlOxvXmckbpc0/ijn6fJsQ+wgJ1mKi3+p9TzuRNxkFODAFXaJUdg9h0Z/6h1t4+ZEifZNN/PGqMIDLhN77nSzCElMxn5u7XQsQoXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174285; c=relaxed/simple;
	bh=MTDaMxdnyKuNXzyJO8ykFrZly0+C/uquQrjfRiGmB0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ABRLwRq5aRs7yWYbzRHsdmBF04iPLxP1KvW5ZMw8WUuL2RHTROxZdtiuWAa1PI4mGokBvW1+WktaevKId08fm+p/o47VJclM0t8tZbf+lErKyd0g/oZSSN6Fn0GA/VS2gbWHWORbcaxLCdqT9W3So/i8sidrR5zJsdcGEEkorbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5OxYsu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5OxYsu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B5AC4CEE3;
	Tue, 17 Jun 2025 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174285;
	bh=MTDaMxdnyKuNXzyJO8ykFrZly0+C/uquQrjfRiGmB0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5OxYsu28oNm70AYLsCfSQWxC2MIKA8/XXoy8IFQDG/IXuCxyI+RGlGaL/VJQhWSD
	 Fm+iHzh1ZObCkEQ35sfzIlf42M5bAhF+NyfrUrvJwpB54kiPOd2wKjCQvrDube6NT6
	 Y+kPjRJr4ehhlqxtvML3S8syZx8fW6w4/FQFLrjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jemmy Wong <jemmywong512@gmail.com>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/356] tools/nolibc/types.h: fix mismatched parenthesis in minor()
Date: Tue, 17 Jun 2025 17:22:34 +0200
Message-ID: <20250617152339.807395112@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8cfc4c860fa44..053ffa222ffcb 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -222,7 +222,7 @@ struct stat {
 /* WARNING, it only deals with the 4096 first majors and 256 first minors */
 #define makedev(major, minor) ((dev_t)((((major) & 0xfff) << 8) | ((minor) & 0xff)))
 #define major(dev) ((unsigned int)(((dev) >> 8) & 0xfff))
-#define minor(dev) ((unsigned int)(((dev) & 0xff))
+#define minor(dev) ((unsigned int)((dev) & 0xff))
 
 #ifndef offsetof
 #define offsetof(TYPE, FIELD) ((size_t) &((TYPE *)0)->FIELD)
-- 
2.39.5



