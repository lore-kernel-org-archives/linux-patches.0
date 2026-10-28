Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212436;
	b=lR/E2n+hKYK/ZpnIVGeSY+Z2hqc9/CqCuuaFrEiUBFKG9rRu4emfNpzSIhrh4wsfG8RX
	 3v8y2pjQve4vn8SO4JQMzPdh+kwN0ZjDzO7defSFxTw8yS3GoYjZ+al/+s7Ko37MOPMqf
	 QfV/ktPU2R/klBCyE3S9EbctHQvI6EsvYilwZGhgElIMo6o9dpUqvr7VB6z//qkAAA96K
	 bhocs2BWCKjE1OG23IBKOudZLoJ7+7ZtcU+/uQcYE9y0OumF6x/GgqPy2tqhP1FzbQfWP
	 +pea2E9+PNEjjwjrQj2qG38SAtQlZ62XoY8J7a//E8AzjabgYvOCLAXKoV6KyepdKsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XdJf0cIil3/gL7x+jjKI3h6nNQQjqi+hk+U2OBAW+lY=;
	b=AkAkfEhiFIxg3huvAWjeeZw/COOLti1X933YnB5CSTVLclrpc1SAGqGBB9EuGbdn9P0e
	 R6S6aUd1fQsjpl5iUYuEFm2ONXr1xy7jYO2AFHhfSdIfIv4mCeS6hhfXjbizARlBv6/gE
	 tFwYJyrumq2Lp4iBRp0glwAiEhV3AgP17t5Arh59wxFAIKIA0JxMBsPRpeyg+GBe00SDD
	 4vrwjD20bE7Ct/+7a+cRzTCNwb9rnzwfzG9aGPD5TygQf1bPK3tPpWnPAhkEpAMmUI0Qp
	 ZLTwUDIG2cam3V7qCaziwrnIGlGUO+2juXbSQT5zj/V9FIrGfQ/KJyAk7d+/2CKfB1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hoc5g1aJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02041606A31A;
	Wed, 28 Oct 2026 18:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hoc5g1aJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520AF1F01825;
	Wed, 28 Oct 2026 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212435;
	bh=XdJf0cIil3/gL7x+jjKI3h6nNQQjqi+hk+U2OBAW+lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hoc5g1aJU+m4d7Spj0VA3+K3Nl95lBLakcL6ECyGQE9rrfkQZzHhEU226JZ4BlaMy
	 CXuz9McymeEeJ6eyBMRtWXoS6nuBi25Jqo/9QHKJbcrmhdAycapWFNCYLgkPbGj/wj
	 q/KfeLW3X6FrKXE+v8s4VywpZn9dSPvnYRwi+zGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0151/1887] net: ipconfig: Remove outdated comment and indent code block
Date: Wed, 28 Oct 2026 17:37:27 +0100
Message-ID: <20261028170502.670540871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit e405b3c9d4aaa10972525fe2ea5cf94224020561 ]

The comment has been around ever since commit 1da177e4c3f4
("Linux-2.6.12-rc2") and can be removed. Remove it and indent the code
block accordingly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260109121128.170020-2-thorsten.blum@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e47a1958e12a ("net: ipconfig: bound DHCP option construction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipconfig.c | 89 +++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 47 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index e90bc0aa85c77..a7f5182c97fba 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -676,8 +676,18 @@ static const u8 ic_bootp_cookie[4] = { 99, 130, 83, 99 };
 static void __init
 ic_dhcp_init_options(u8 *options, struct ic_device *d)
 {
-	u8 mt = ((ic_servaddr == NONE)
-		 ? DHCPDISCOVER : DHCPREQUEST);
+	static const u8 ic_req_params[] = {
+		1,	/* Subnet mask */
+		3,	/* Default gateway */
+		6,	/* DNS server */
+		12,	/* Host name */
+		15,	/* Domain name */
+		17,	/* Boot path */
+		26,	/* MTU */
+		40,	/* NIS domain name */
+		42,	/* NTP servers */
+	};
+	u8 mt = (ic_servaddr == NONE) ? DHCPDISCOVER : DHCPREQUEST;
 	u8 *e = options;
 	int len;
 
@@ -702,51 +712,36 @@ ic_dhcp_init_options(u8 *options, struct ic_device *d)
 		e += 4;
 	}
 
-	/* always? */
-	{
-		static const u8 ic_req_params[] = {
-			1,	/* Subnet mask */
-			3,	/* Default gateway */
-			6,	/* DNS server */
-			12,	/* Host name */
-			15,	/* Domain name */
-			17,	/* Boot path */
-			26,	/* MTU */
-			40,	/* NIS domain name */
-			42,	/* NTP servers */
-		};
-
-		*e++ = 55;	/* Parameter request list */
-		*e++ = sizeof(ic_req_params);
-		memcpy(e, ic_req_params, sizeof(ic_req_params));
-		e += sizeof(ic_req_params);
-
-		if (ic_host_name_set) {
-			*e++ = 12;	/* host-name */
-			len = strlen(utsname()->nodename);
-			*e++ = len;
-			memcpy(e, utsname()->nodename, len);
-			e += len;
-		}
-		if (*vendor_class_identifier) {
-			pr_info("DHCP: sending class identifier \"%s\"\n",
-				vendor_class_identifier);
-			*e++ = 60;	/* Class-identifier */
-			len = strlen(vendor_class_identifier);
-			*e++ = len;
-			memcpy(e, vendor_class_identifier, len);
-			e += len;
-		}
-		len = strlen(dhcp_client_identifier + 1);
-		/* the minimum length of identifier is 2, include 1 byte type,
-		 * and can not be larger than the length of options
-		 */
-		if (len >= 1 && len < 312 - (e - options) - 1) {
-			*e++ = 61;
-			*e++ = len + 1;
-			memcpy(e, dhcp_client_identifier, len + 1);
-			e += len + 1;
-		}
+	*e++ = 55;	/* Parameter request list */
+	*e++ = sizeof(ic_req_params);
+	memcpy(e, ic_req_params, sizeof(ic_req_params));
+	e += sizeof(ic_req_params);
+
+	if (ic_host_name_set) {
+		*e++ = 12;	/* host-name */
+		len = strlen(utsname()->nodename);
+		*e++ = len;
+		memcpy(e, utsname()->nodename, len);
+		e += len;
+	}
+	if (*vendor_class_identifier) {
+		pr_info("DHCP: sending class identifier \"%s\"\n",
+			vendor_class_identifier);
+		*e++ = 60;	/* Class-identifier */
+		len = strlen(vendor_class_identifier);
+		*e++ = len;
+		memcpy(e, vendor_class_identifier, len);
+		e += len;
+	}
+	len = strlen(dhcp_client_identifier + 1);
+	/* the minimum length of identifier is 2, include 1 byte type,
+	 * and can not be larger than the length of options
+	 */
+	if (len >= 1 && len < 312 - (e - options) - 1) {
+		*e++ = 61;
+		*e++ = len + 1;
+		memcpy(e, dhcp_client_identifier, len + 1);
+		e += len + 1;
 	}
 
 	*e++ = 255;	/* End of the list */
-- 
2.53.0



