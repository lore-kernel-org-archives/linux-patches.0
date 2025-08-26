Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294E6202C46;
	Tue, 26 Aug 2025 13:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215645; cv=none; b=AJDgfyINEAt42Nd4m1yob2/OmmIQn47HfWSSFOHvuozv6V0bl55elITJxR/jVT8xrZmh3cg9E2yPP4i/1uHAZae7ZTEazXvbTUtGmFNT1e/1YiF5gVdHDqppmtQdz8I6EIxaL8sA/SGirKduqDrEsBcIxOXiPnu4cjmIHllOyFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215645; c=relaxed/simple;
	bh=g6PH2d9vDjUZcj0jAkiAyMHXs0YpFaAfrorQl52MAq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cu5ERp32lQRvy1miSPoXg3VNcFEyg9mpYBVtThZF0lp8Vf9qG7KXV48ap/2GEqnROU67K90SDNaYkdGVqjEIzrFDqJZwOGKAquoLS8c3esu7RNBML1uHbD1f+MXtBUSdTW9WYyKkEW6IvhSGNFIJx3+XiIqW8xJPBiFqu1Wo1Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uv0mstgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uv0mstgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3AFC4CEF1;
	Tue, 26 Aug 2025 13:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215645;
	bh=g6PH2d9vDjUZcj0jAkiAyMHXs0YpFaAfrorQl52MAq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uv0mstgI78ak3mnC9N98kUQnOnDe+k7sDFmw5KdEkubaYBXgK4O+K2ZPsYoSmgDbl
	 NDP+OAbaiF+K5K2ZPiolUAbNcRhaYyYGpz8WYueKUv/hZuT2UQLWobi4dTcExkpffA
	 GATn4qVvlQtXYw7+Vurezxp/eWbkj/79yqbWRJKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RubenKelevra <rubenkelevra@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/644] fs_context: fix parameter name in infofc() macro
Date: Tue, 26 Aug 2025 13:03:22 +0200
Message-ID: <20250826110949.279343693@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RubenKelevra <rubenkelevra@gmail.com>

[ Upstream commit ffaf1bf3737f706e4e9be876de4bc3c8fc578091 ]

The macro takes a parameter called "p" but references "fc" internally.
This happens to compile as long as callers pass a variable named fc,
but breaks otherwise. Rename the first parameter to “fc” to match the
usage and to be consistent with warnfc() / errorfc().

Fixes: a3ff937b33d9 ("prefix-handling analogues of errorf() and friends")
Signed-off-by: RubenKelevra <rubenkelevra@gmail.com>
Link: https://lore.kernel.org/20250617230927.1790401-1-rubenkelevra@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 13fa6f3df8e4..c861b2c894ba 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -209,7 +209,7 @@ void logfc(struct fc_log *log, const char *prefix, char level, const char *fmt,
  */
 #define infof(fc, fmt, ...) __logfc(fc, 'i', fmt, ## __VA_ARGS__)
 #define info_plog(p, fmt, ...) __plog(p, 'i', fmt, ## __VA_ARGS__)
-#define infofc(p, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
+#define infofc(fc, fmt, ...) __plog((&(fc)->log), 'i', fmt, ## __VA_ARGS__)
 
 /**
  * warnf - Store supplementary warning message
-- 
2.39.5



