Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055149;
	b=E7HBrWfBXa74SqGKhhfWZzTl0yoCG+A3R04pLn835S6HRmxxfMnOwLNuF7af8KHcuVd1
	 b+nPtiFzHqSJ3s4hRLs3lHSGdd3nCMMyluTrI/ddj3P8iXpoC7u7zobD54Ra82u6yDiY3
	 4spm/Z6llYzERq+CkO2XFT+3eWjy71BlpszeKxFkr+MQ57Mw33CQhGiEjBq8+iQyJ3i3D
	 M8m4bWLhqH0ogFv25nDPeCd1R5s9jPMAGmlZIo+/7jDUm4H9U2Xn9v0sHsDj4hQWEi6Bt
	 MSFbyqw1HeYrj1o4I/uyUJrhqO8beYjavgZ28Zlzyn85Mkq4P44zqjzeRB+NyMBjirg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MAKTzZ32Qe+7uHcHGO6i6EtlFMuHXbVd7dvjKkzQ81E=;
	b=0+5WuTZs/J7ScJIPowLItLxywg8vpgf2n2YsfK4oJKcDL5KPELhCno4LTmW0WNfcQiA5
	 l4icZ7Wx8gYP0XmgyC+Kp2N/jfNhxXqPCZYagZCQNPU1GXA6U/lrDSo2vdWQafHNHuSgU
	 +Gk0OuxCDD47yOiV7xyIZvQwO7nivgnrWutlEQu0n2iUTRYJogBDWIStUwwPx1CecEdPT
	 qitvslSapIqVvdm4c+Kv7/tTY1UkSbchMCEXZTJl+p7aO5miosjsOfNDwurUBJkpduNlZ
	 hfUgo+Oku/kN3hLJPPKO/6q4m9hqxFNDGPyH62mqQxunH4Qpin23j6wjS3tmI511mWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QoztUrkW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56981606A31C;
	Thu, 19 Nov 2026 02:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QoztUrkW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC10C1F000C4;
	Thu, 19 Nov 2026 02:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055149;
	bh=MAKTzZ32Qe+7uHcHGO6i6EtlFMuHXbVd7dvjKkzQ81E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QoztUrkWxgzJHF+RuRnHmztDxCg2t7Ny8msT1KAuaoSjC7RTXY06qzDLLoL0ivW0F
	 4bYWrK7BQN1zPwQRwAX9iEyMWoTvSxjeJ3pOl73F09HW62r4mFimG0qrpMfU/xi/jH
	 tFVX5X2Dp92VEBWVCC3c9v0ZD1kELeG4cH4qVj58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Yoann Congal <yoann.congal@smile.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1528/2214] kconfig: default to zero if int/hex symbol lacks default property
Date: Wed, 18 Nov 2026 15:53:24 +0100
Message-ID: <20261118150113.318765825@linuxfoundation.org>
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
index b978f1d09fba1..4b658116fdef1 100644
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



