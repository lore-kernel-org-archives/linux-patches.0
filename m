Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C9299920;
	Sat, 12 Sep 2026 09:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204674; cv=none; b=D7Y83qgVTbRukWvd/0iHjFMab1QFCbQZnYG6OiDxK9klJwzFPsKohd/8Brfr7PeYTupl6prVSc4JdG2bJ1Y/PwtNRlJ21SW9rM1CjZq/vPbJnjvHj+pi0CidS6LRHMRaR9gATGULAT5xOA3tdMOwG7s1FnvZ6EmMfA9NpTI9f7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204674; c=relaxed/simple;
	bh=9PCTE+tYyjgPd+CXio2t6DoY/DPzISaygT6tc1WRQ/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0LWaHZCMOOqYyCk53q3lnkpXgk/wko919/q2dWTpOtqeopjVNSHzdlbdXD/9CI8UmDuulB3VgJXjg5GUfDqHdNYobm1oqrZ4RYc5XeI6o+jlNJWgOKXMld1gRg7YAzKYcHjsYLUWch/zoEV7hkJ3ktzUeSx8aDQxYQ2wGf7eRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG+9zJCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG+9zJCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11181F000FF;
	Sat, 12 Sep 2026 09:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204673;
	bh=hVHeSXGNTWBP7RgHpKe0FRUem5NaB2ehGxjrciyQs+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QG+9zJCL2DsIZi+D9ppUcAD345GJTo2UoafgEz8fNao4EdPnUbUZADS4BEp2h7D34
	 u1SMtcVf3fbuDQWdwBZ9pfkcxc1UYXS5JzHECc0yjzzK2XHJySHrF22iu7h3UOHJ7R
	 445jn8rQ68H0GAm94Xx2hiIrwWPniJ2KCLe0AL50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1662/1815] smb: server: remove unused DES crypto header
Date: Sat, 12 Sep 2026 08:56:52 +0200
Message-ID: <20260912065728.007318457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c5e640fe346177372ff4a51a45b01fcd48c29207 ]

The DES crypto header is no longer used after the removal of NTLMv1
authentication. Remove it now that the server no longer selects
CRYPTO_LIB_DES.

Fixes: ce812992f239 ("ksmbd: remove NTLMv1 authentication")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/auth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 2d116d60f7f6c..8d22d28a12bf9 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -24,7 +24,6 @@
 
 #include <linux/fips.h>
 #include <crypto/arc4.h>
-#include <crypto/des.h>
 
 #include "server.h"
 #include "smb_common.h"
-- 
2.53.0



