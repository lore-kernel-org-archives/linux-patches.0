Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208377;
	b=zuR5EOdC8enmy4pFpya8niF9lACqqAv4h8YYvEyRm7ZRD0GrhXYQyGCdYRXEzYHtwMXg
	 YWbUmjzYt0YtFqveNrmJvTnVe916oTWusXvSaCdGtjbibWnBgsDdyxLNJf90UFAD9MzyY
	 a311lHKPVRUNha+1jiN7JuHzraveLLSK6x1VzkZccYliMAU4vpuFQCwkwoDODdktCfRN6
	 tUZJWofCqxxhzmCT7s/rPL1IDBEhtA2jG96/4XdA9YCnh7ps2bMgT9p/30PcqDfasrPlo
	 TMyOO1RJ4MI/vvIg/64335GB8iWsXpDWmBgGi1p89TxlfnVB9x/tCWhbKijh8/FN3JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wfYD7dXa1ZMkX5wp0bCb5Z7cvkSsWmEy1gRCBL7r9jo=;
	b=rDzAE8toB0V3xM4BLEtMNEhcmwHwx7VKEz5IXrIlhPEdRHOseCJWFuIISOuyptGgOLcj
	 RO7EjHsIr57LDcOPh9rwG1eq3Fb7XOc+hsndIugQC6i4yCZbBAPRu0QRXWHy+IoAYNfXR
	 c8WiKuf6NfeywUf3iej9lMtIHnMVRI0zm2g4Mg2WsOOUtV1S6F38Q9BLxAze66yJKsI9i
	 jM1z9qOSprD8i1IXC3k4w/jwc0Vp4ad67rTotUkobScF79WWF5CzAnOQ6tjH8I/IMQyuv
	 6kmCQwSkFFn5HJNb2gx1LAX2NYuzBMsNwwX5LoBIL4hXqFzJwvcC6TCSBP9183Y+2Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vMI1tz/2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2140606A31A;
	Wed, 28 Oct 2026 17:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMI1tz/2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AF61F01828;
	Wed, 28 Oct 2026 17:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208377;
	bh=wfYD7dXa1ZMkX5wp0bCb5Z7cvkSsWmEy1gRCBL7r9jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMI1tz/2RAI6iqlIoySmHc3kC2LhfCqbdy9MLLwOFyyVGYeR9a/bhKj3cwAmKzJDO
	 JSjU0zUktGLPyzCljcfX4r1z8H+oHXjftlKp16RCIhCyA9l43k/3HO+VY6dtMoVvx0
	 yV8bICY74UJw0gGMww9VLF9Tfdo5mDdfSfRL+xaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/516] params: Use size_add() for kmalloc()
Date: Wed, 28 Oct 2026 17:53:27 +0100
Message-ID: <20261028170004.832761899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0fc79cbc937f2a754a302a710a94b68c61d0a89a ]

Prevent allocations from integer overflow by using size_add().

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231120151419.1661807-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/params.c b/kernel/params.c
index 30c0a7388024e..b930d3a4677cc 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -11,6 +11,7 @@
 #include <linux/moduleparam.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/security.h>
@@ -48,7 +49,7 @@ static void *kmalloc_parameter(unsigned int size)
 {
 	struct kmalloced_param *p;
 
-	p = kmalloc(sizeof(*p) + size, GFP_KERNEL);
+	p = kmalloc(size_add(sizeof(*p), size), GFP_KERNEL);
 	if (!p)
 		return NULL;
 
-- 
2.53.0



