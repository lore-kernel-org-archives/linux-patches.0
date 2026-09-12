Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D6D2C1586;
	Sat, 12 Sep 2026 11:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211884; cv=none; b=V+UYr0spzUcfLwH6utZRusYKbTS/reZKGwgkF601I2+Z0QrnyyQQq2HWQl8CfzYh1iK0mcqGo3VXkjEwmecOTgZ2B4ThLpMoIvd8mfautYHTZ3APozRXwTTmyAXgxYIb3FSJHvjidNnVYbJpW3q5c7HOK7qTyT8Wva3QjxGu3cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211884; c=relaxed/simple;
	bh=o8bcDFB1ejf+0naRN5Sp+Ll+DpC6P/XXXCRI/3t/sXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIF77P7mQ0fd/0pOXu6Mt8VoGttkEppEcHvg+MYo22NATedJmEiuy0D9DXCjZAWbEjZeJ5qUmRKub9R62jeg5HohHoYPXR5BYwhZ80+tIHDgV6qac01lPxTpA4QTZyYFSf+eBtTmJWzvY9o3dRHWvistdM1o0kiDOVR1XORlnDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfJPWl3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfJPWl3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F761F000FF;
	Sat, 12 Sep 2026 11:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211883;
	bh=D2iB78ZUUAPvMmQhBWg1XJtR88PaHC6gnTzmWYxMTis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfJPWl3pb1ZvGCT1OvlUaV6BTbzDGzzUOV7nI1M0dgB4k7ticiKdC7QGCqBsnslVd
	 8I6ictpuDVc8AdJE9YKS4Y26fFOuZ8XT/SxbUgwl7plvaia+anzfE6fYFCynRlPE4z
	 ZoO/XlhRxuDOfsPRT/Q0ISS8Ou0C3S4Qc4gosShU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1322/1518] smb: server: remove unused DES crypto header
Date: Sat, 12 Sep 2026 08:58:11 +0200
Message-ID: <20260912065653.435129512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e85d7b0ded30e..9844aaad7ab3d 100644
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



