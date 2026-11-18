Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051505;
	b=CwkHUMWsajXHxlX8GykxkKsIrhRaU3i/zrw9GXhEh+KMSh0xL052FWyJ38ojhWF7I3Pw
	 +uMDi/tJ0HHi42UEurl7Qj8niJnf4UrqFvNNKvWYkatOIP+a3dGilYxdcGz+pbU+I3SoG
	 0gJUDb/aViOg8CNUCnmKDHJCtxzYMiQHlSyGw9P1Gq3BlA1Ig4PptzvEehmS1lwdyujMG
	 FXnI6GuXPeWTu5hG1awt5UD3TiAy9FrxJdq2lrZUz5LAHkqxhR/X+enWVdn7+XpR6xuBs
	 RSywL8BkalUIAQkdfF/Pk58BIS99vgmd8iumfFEwWBr7WKV//FrNRb2twpAZioD4nyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yrv0Ts1t+IZMOOWpPCCjSR/PQ/RbAQujaO2UQxjPZf0=;
	b=OwddNy0zxOhZupAYyWEBKLmTMHX8a/SIdPA35eRVZw1V4IUE4lkcxn1B/M6hAjRkk/rj
	 IH4jQui8MhlQt1ClDbLFvQ1SyccVecUoamb95UUSqgrzeIB661RLBQq910uBPol3D9cK4
	 KOSN5DSozNZ+WMvVHbI2ljtav2xYcUHthLBkbauShaV3gNWuDXKEjl8Ha99kz6D03Vzmx
	 dJjtdn9qIvCOhX5BXoGEcnNS7cRz16+qEw3U7HPsMY5v2D9yw1g9Xv1sF6ciiUKkQBYUw
	 D4Jo4KL51zSQ7OJX442lBjb2PVzAA0ZncF+TGHGI5nG3OPtVsNImtOvdrTlICLenXDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJfFgAEt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D3B606A320;
	Thu, 19 Nov 2026 01:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJfFgAEt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183441F000C4;
	Thu, 19 Nov 2026 01:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051505;
	bh=Yrv0Ts1t+IZMOOWpPCCjSR/PQ/RbAQujaO2UQxjPZf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJfFgAEtCkqMbaZHiRSASO8JgzE8lFK313fRVLY9oZQxKDRCZwkv8VHJSBl/MNS0e
	 wo0ilW+SX8zFXCqV5QQFdw/sSLLc/elSFtL4N34XAEgsyK+9+DwwgbmU5usFNE0tZK
	 E2/XZbRHYYWizgLcZzs9CUbpBrZ4BcYi8DH3WwPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenson Johnathon Reggentin <mail@jregg.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0232/2214] docs: block: fix dead http link in blk-mq.rst
Date: Wed, 18 Nov 2026 15:31:48 +0100
Message-ID: <20261118150019.506305175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Jenson Johnathon Reggentin <mail@jregg.de>

[ Upstream commit b40a680ea4efe4ef2addada63e304a94d19500d1 ]

The current link http://kernel.dk/blk-mq.pdf leads to a 404 error page.
https://www.kernel.dk/blk-mq.pdf leads to the correct document.

v2 to add the missing www. prefix in the actual file change.

Signed-off-by: Jenson Johnathon Reggentin <mail@jregg.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260819192422.42189-1-mail@jregg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/block/blk-mq.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/blk-mq.rst b/Documentation/block/blk-mq.rst
index 31f52f3269714..9a8b3899e5581 100644
--- a/Documentation/block/blk-mq.rst
+++ b/Documentation/block/blk-mq.rst
@@ -139,7 +139,7 @@ completed.
 Further reading
 ---------------
 
-- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <http://kernel.dk/blk-mq.pdf>`_
+- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <https://www.kernel.dk/blk-mq.pdf>`_
 
 - `NOOP scheduler <https://en.wikipedia.org/wiki/Noop_scheduler>`_
 
-- 
2.53.0



