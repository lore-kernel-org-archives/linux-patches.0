Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060659;
	b=1gk51c3Z/qmuuc6GkEMFnbSlPJKwU7UbqUvxXCBYkfjRDMQOhANIjnD5FSLDws7t5VAi
	 Gi8jWIhsMKudiEdqLvVKBhN9j3uWoO7hIM1l4Nh4i5DWg9l16AM8lsyPJYhevDmaSsNBa
	 yJKUqO418XBVZsY4GU8kPHyamwIXt3D4Pz+hn10bPozB3lUus+frPxjBnnMDsL4kCdiSL
	 0SfoUrj7iWfxERgTnpMifZkm2Jma075WKEgGG6NlP1vu4ExAG5CIahodVFjbULB2SrB0T
	 ugT3ydfhBJXMJ1mvQ1jYpvi1ZdzEqfe47x+U+x8MbpC7IbuzIUoa2K35tz47E5gTVLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4njZOPc/6elVb9m6Fo+3QPsAEre1lgUl3xDgV+EG+H4=;
	b=EEga0kdohtgDQuUSgVBCOEThEW5KfxecwhdDe7A95ZbaUlWIpTZfZT5TJrXkEk7gsVvz
	 fWH8fcX5qTHBZWe3LW/TSW8ROB7+lra9fIG10LwRmS3hokURGSguQVzOjJl6oOlmt4Mnm
	 OvPZy44CFCAQCLZXelrj5102XJbpo9MEe/oSY5W5HmbnF1DoD1q+1QxBPsifyDA/3fREf
	 LMGFRvajfIo1A+mqJoQgwp9hNdW5sWsD7FatObdkdpZlZjxnBySGBPlwCWU+kiu5FsFrO
	 Oa8U5XnxtSvdYF2tUuUsdoQwExU2hqpq8Q//E2M5By5vDvRYktgD3iQ/fqysZvYUjYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAK7CEJv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DAF606A320;
	Thu, 19 Nov 2026 03:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAK7CEJv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403541F000C4;
	Thu, 19 Nov 2026 03:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060658;
	bh=4njZOPc/6elVb9m6Fo+3QPsAEre1lgUl3xDgV+EG+H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAK7CEJviZS1b2qHIBde+PFc/J1wOxSQ8J7c6RS66kdhA5hDe7AikaMEaptok4Ubr
	 OSmlm2JCDPGatLNKJ4udeBUb66RFoBondHsQC9fIZGVuDIGg7uQF3zk1RKv7mj/Vjp
	 2jdQUhAk8/wxR09v8N6kRBbZotbl0Ox9RgXf/gG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Yoann Congal <yoann.congal@smile.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1277/1848] kconfig: default to zero if int/hex symbol lacks default property
Date: Wed, 18 Nov 2026 15:55:15 +0100
Message-ID: <20261118150013.077286216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index d4a8ab6ce0520..33fdcd99cb398 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -341,7 +341,11 @@ void sym_calc_value(struct symbol *sym)
 
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
@@ -749,14 +753,17 @@ const char *sym_get_string_default(struct symbol *sym)
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



