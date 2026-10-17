Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305DD1FDE31;
	Sat, 17 Oct 2026 16:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256141; cv=none; b=AraAvM1h7wHVX1/H+knsF4eir5bs86LDuN6cGxRsIWkivf/2VX9lG0j7ijrULkiRlIsSrZyN8+P9XprPDml/Gan3bxPKGoj42XochNxFUMgNpsxGVsMOQE7td5cGVtQ8o4igCo1DamUnyyqjo70wl9yWwAcCidBnQI0Q17L7Jmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256141; c=relaxed/simple;
	bh=mkDD+ol+TzGMF/91W6Z9WIKcIqU7hhHshSZQVCND6/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNgTnn4qtfi8rDdPgA0ve+SrmW/Pbp5vKRsm43Cel8Pn4P/RL6zpVmC5iTSkiAHsJXUjdoPVGkxYQw+iyH0vJfugvzQnoECWyBX46Aw83qberu6fpwe9nC/Kb1S9BJ67ZeyhUiwnFJx8z6QcphK15GUPkJP2jKZVqZ4gh4lSFB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRbOMboF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRbOMboF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4731F000C4;
	Sat, 17 Oct 2026 16:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256140;
	bh=Cg/QA0sItr6qIkww4w1Z0sHa2OFpmO+obrZIAEXujhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRbOMboFBtR+iWif3HgL+9hTyF6qNGphZDsZWDQl/XjMn00ctczyqyJDSIPAGjO0v
	 6xnog7PEbt1X+wAmzmK0JladmC+8tKRy8JmaRXAL0tX6lYtrzkYW+/0sjvfJScazk9
	 GPDa20oumPzGvyFcAqqvLh53Ea7Vym6h8Jxo2ZYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0138/1674] net: ipconfig: Remove outdated comment and indent code block
Date: Sat, 17 Oct 2026 17:40:10 +0200
Message-ID: <20261017160434.700313681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c56b6fe6f0d77..6109ef9e4dd45 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -679,8 +679,18 @@ static const u8 ic_bootp_cookie[4] = { 99, 130, 83, 99 };
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
 
@@ -705,51 +715,36 @@ ic_dhcp_init_options(u8 *options, struct ic_device *d)
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



