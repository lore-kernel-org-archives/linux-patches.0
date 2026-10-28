Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208354;
	b=MLRRLTiwhqcbY9MXu4jMvbYfHetO/ziOrp/YjBKQrW/wkGxUcBHULuF54mpcru4iVOWe
	 5AYkT0x0oHo0ha0609riCO9GeYmTRaatquCeZ4aEIiwfceZOvJhl+k8RVk+wa6xFCEQSx
	 O0qyokogYXQNnIXxNiHbwZmLE1NVYH3y1DB4kn0mVo8x9kz9G0+PhB8wbWdIl0wDXMqY4
	 z8FcwQ+uqE70BrMkpOKbM2bCmvf7ZaHAexAMUkgz28fU66sjNLd4O+uw7NEdzIJK1JdIc
	 47a7dPpIwgxdWtRysYJ1NAbHimzjOfY2iEQiQ5+yybnkeGFK7ldsDTNdz/QTAp/a1sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4VZiOAh8E25BwYdkmD4oOMVTLYqQfb/GuX66oQCFx8M=;
	b=1K6koXnTdTENUUSgO0JFj3y7vSDec/87wsgfqyfy9dwDEnPW/DOhcxHlYh/v8xjcVMCw
	 hQpsxfVxdvYUwMaSsg8hmPSIimRNOVEioxXaBEQB8g6dlYf7ikWWUiZDd9rcUntGXjFru
	 C4zWmvPgCt+lRXc7Zrv4sW9E9WUiS1zgmIpDcqLIwgA4j9emWY6EgfbiU61MtckLxatew
	 O107aYU2eySKdwEknV9dfFBPvW20Cbqyxn6HPdWH/wad0nPNiGK4sWFgyGLLKQeJOj/03
	 50q3wNuaaxqELc/SAkSiF1W0Gc3ViL+ltPYsJtgqsi2Vvnc2cL1VxA+smQmS05n9Owg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whfBoXa3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB63606A32C;
	Wed, 28 Oct 2026 17:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whfBoXa3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF581F01829;
	Wed, 28 Oct 2026 17:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208354;
	bh=4VZiOAh8E25BwYdkmD4oOMVTLYqQfb/GuX66oQCFx8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whfBoXa3B4pu/W6eEc1g3J5SmzFG4gH3+UTljlMw1xPpqAyY1wYvw0TkOzHZqrq9x
	 GIRRd/8JNI8tWgJGD1o9mmoDWllRKWrziBNDrv04GRjtkgCbBTfyIslGPs5EuTb56N
	 94pxu9n+CBynJzN7G43xwCQpw2mOKiQe3iHqO9sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Miroslav Benes <mbenes@suse.cz>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/516] kernel/params.c: Use kstrtobool() instead of strtobool()
Date: Wed, 28 Oct 2026 17:53:25 +0100
Message-ID: <20261028170004.787021877@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit def7b92efd868a6c78da86770704c1a03506016e ]

strtobool() is the same as kstrtobool().
However, the latter is more used within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/params.c b/kernel/params.c
index 0df4a315760d5..9f0f059571a0a 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -4,6 +4,7 @@
 
 */
 #include <linux/kernel.h>
+#include <linux/kstrtox.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -310,7 +311,7 @@ int param_set_bool(const char *val, const struct kernel_param *kp)
 	if (!val) val = "1";
 
 	/* One of =[yYnN01] */
-	return strtobool(val, kp->arg);
+	return kstrtobool(val, kp->arg);
 }
 EXPORT_SYMBOL(param_set_bool);
 
-- 
2.53.0



