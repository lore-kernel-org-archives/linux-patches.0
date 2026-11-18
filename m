Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039876;
	b=un/rCFrTVdaz/61QLLmDmyhr+5RbIMqMEwDVx3RHaUdHrj50UXygjA5BQWn1dEYnoSdH
	 vBWN1zKGM6AXY2xYkjHROgYnFq+xj9aiLtUPqKAAhIlB5PcyNJJE1JX4847P4stm3gBbo
	 gA4LuD4dHYWPOdpxB8OnaSSlk5mEJTqztqCJXdHPOjlIWYSzSWOBqHG1PhM73V377Giv/
	 wc+U8k+FM+4ugwe13iQUbr5jHbibfyFAjItDNHqktkwkzsw++QcQpobKqqIyoYJuKEDCr
	 ygeKCBmSV2Ngbb7aE6UEiLq9xz5kWZPFMNxVQI+QOB5IOQVb5DtiYinEiRTgCSHhgdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tdYMpo+5nJ7jwhqqf3xbhbhJFZeKrajcObJgDObY9C8=;
	b=Tijn009mXtDG7wkFLw4hbp1c0pWxdungBfR0CI2bQC1mJAO2t7YPk246pwohSyeASr3N
	 zX3JyKoffhGJ4JJTgP17ZtgWkSmmTyZsRgeu/MTZcevOYrFLGI9k04iqn/526yFu57Z50
	 uXR8aB+ZZSsaqhK8BRA8qWF2ylvSqMybl/L53k3z41zOMpiWZh6XRB+JbsmjzlYg0Yi14
	 Va8KPbxFYT01B60Fc96BeroXbm6nJMMfIzc24K8zn9FyV7FGqZC/dOptThSu77at1gSMu
	 84KWSF9XyjwietFc2Ukj+O/vaA5ius+IoSEHieB0Gc7oGGHchaU1+zmoTlIsbLw1Uug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYc2WIxM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E647606A338;
	Wed, 18 Nov 2026 22:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYc2WIxM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3551F000C4;
	Wed, 18 Nov 2026 22:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039876;
	bh=tdYMpo+5nJ7jwhqqf3xbhbhJFZeKrajcObJgDObY9C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYc2WIxMUL9V0mKc/RzstybacsdX54qk6sBzmOlkoeWbGFGZURWGKR6j4z2TSdo9r
	 jX7RKCuFBHEuKJ9XlOXzFzNA6VFBdq8vFPf2hqvam6AKAdyLHxu7r/+AvHKr4IE0nx
	 miPyEoeIE2lKhh1mmDIc+kj5VXDHwFFdj6PKL7XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Yoann Congal <yoann.congal@smile.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2256/3318] kconfig: default to zero if int/hex symbol lacks default property
Date: Wed, 18 Nov 2026 15:47:58 +0100
Message-ID: <20261118150429.504970626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 6262afa10ef7cc8fdf39b81a36f9546b68810431 ]

When a default property is missing in an int or hex symbol, it defaults
to an empty string, which is not a valid symbol value.

It results in an incorrect .config, and can also lead to an infinite
loop in scripting.

Use "0" for int and "0x0" for hex as a default value.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Yoann Congal <yoann.congal@smile.fr>
Stable-dep-of: dbe1ae2304a3 ("kconfig: fix extra output from savedefconfig on out-of-range defaults")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/symbol.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index dc8edb0ac5236..0e44990ea0dda 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -351,7 +351,11 @@ void sym_calc_value(struct symbol *sym)
 
 	switch (sym->type) {
 	case S_INT:
+		newval.val = "0";
+		break;
 	case S_HEX:
+		newval.val = "0x0";
+		break;
 	case S_STRING:
 		newval.val = "";
 		break;
@@ -759,14 +763,17 @@ const char *sym_get_string_default(struct symbol *sym)
 		case yes: return "y";
 		}
 	case S_INT:
+		if (!str[0])
+			str = "0";
+		break;
 	case S_HEX:
-		return str;
-	case S_STRING:
-		return str;
-	case S_UNKNOWN:
+		if (!str[0])
+			str = "0x0";
+		break;
+	default:
 		break;
 	}
-	return "";
+	return str;
 }
 
 const char *sym_get_string_value(struct symbol *sym)
-- 
2.53.0



