Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048356;
	b=5a+UNcU9eljJ4Cc3jM3CkSutG6AVpuDRS+t0MHcMab8fLHg61zJmbXnPgBhgJa86OcR+
	 D4+KR52j9GtZFTThVsW9Zkm4GsEwRFKRi1jPGcMeXpHPCX5CISoHn2KrnWVIr6yTiJGu3
	 iWlUiPmGD1uIKuY89frZBOUbMcCmkQps5bU63Vp2Z8QQKq7LKUMFyt+D4JHsxWUjT2mEL
	 5cWzYdpgGj7aAs8eimQK/opW+0JLlu+0+hsn4rIXoetDdR03GYQ0ebQaLrHYgVYDxsUv3
	 i5orGWV51ALGL4fBQjAUV1Vs2QOpOfPUgTTAprED7Z9Vbq1dMsfdlsAGP6DXyWRvB0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ke1VASUfm2luhzkfMtKQuGzDOKcDNANn2QoHvj43xYI=;
	b=x2jh/qGdPfUvln5VWhiGEXCtuwJN65wmJ98ambj2B5u70uBunq9QympTexndArE3UR8S
	 /8WMK7rlwAbgTBsBeCa8VWXWefijivGDLSD59S48c+Xs2pMJ7SIyPU7GM249qmK/C1MDS
	 gkaZ97NLMKNfPMbRvxrN4bXAEEmMkiLqukBIwyM18Qj40WQIvbxREVw5B0pAqC/Yf1PmQ
	 Jswip5HdXkSTEXDGjqlBCfI62Pk+TBFde+x/ESYPyi7bY2ChMqN0KyOSQRBmDbvDXem2O
	 G0JwCoVXGjaoL1w5o9ne2UggvcOGE0turrkg27Qc+0J51/UM/oqO2VRciGevU80YAlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2B5Emxg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A4B606A32A;
	Thu, 19 Nov 2026 00:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2B5Emxg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F471F000C4;
	Thu, 19 Nov 2026 00:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048356;
	bh=ke1VASUfm2luhzkfMtKQuGzDOKcDNANn2QoHvj43xYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2B5Emxg5wmrVYNeR/4+U9FK0L36ZDn8pP+7nRTN+sBplNZmnPuUGhGl64M1eqaRl
	 ubMUdnXLs1XgHGb59gpO+XxVbZekjGQNcnI18qRHx0SWYcRW8Gj+rlIKQVhKuxnwFd
	 jRUok16eqdnJSPWDrTp0O6qgIPJmzU5q8+UO7+tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Yoann Congal <yoann.congal@smile.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1965/2857] kconfig: default to zero if int/hex symbol lacks default property
Date: Wed, 18 Nov 2026 15:49:59 +0100
Message-ID: <20261118150312.159374073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



