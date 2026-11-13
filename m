Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590068;
	b=L5Tsa6/C+CuhnJq7j8psOe3eYN+K5ZKgH6gZUX0FwZ82EoOGALbJrTtYOQl1Q9VZv4c6
	 swilThPwliWym44qJqIlmt4P9JvUUJZp+q3kZXo07wCkyNzDRKsKrXsybyoguCw9BMZVq
	 dJW73jaOvjTzPxrhc8LchG1B9/QVTjidF4paSc5CJIyHNzRZQxnvFWs+Pw9A9WXs+QaKD
	 pYn1d12bwyvTkHmI7ypRioT16XQUNEo2NdVQ23PBj/OEp2iyOg8C3i76yAu2//g7NjabL
	 4k6Q6qFb/3hrnLX48s7TlStXcyx2xs3Hc+M415N+3DaPfUPulUnFOCgXv8Vh9YzXllA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=X2R0+Ayt1a+Smhi+B4ClemVH2DUKUtn0Q1JJ4WUPM0w=;
	b=D+0B/owyYtpwc2t9Ub6guCJn5a0Oau8QG/urWinEAoQaUenZvu8K3lnzGoZi1nKEkEcn
	 iOfO/uK2iaHPOqzAVTKn9Jc6et0NKM/FiS05zr17LXXKvzUWU+/UERe/M13mbqlJ3eLGT
	 A5gnb2793qPupWadGDhZXl9hwNmDGfGSA+w5uRF6cZxHjQB59MDtBAuIKd6gtYnGPnIsi
	 C1SnkxUCfWEZtZFCyV/TXFHawIw6lqTVC30QVrUtg5ibuXuLWV6q12fhoWp8nG4XPr+PN
	 MPq+1Re4RPfkoO6YHnTxcSQdAGyqM9MyDdoADLFhq4dANpiyafvRooKBLzqUzhC3b0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQIj4EIR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEDC606C08B;
	Fri, 13 Nov 2026 17:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQIj4EIR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8531F000C7;
	Fri, 13 Nov 2026 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590068;
	bh=X2R0+Ayt1a+Smhi+B4ClemVH2DUKUtn0Q1JJ4WUPM0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQIj4EIRt7E/SLCDWF3XISkapY3v42VKZsTWVDseqWZo6acOyAx2Ac57Dev95/ct2
	 Lw32j/Vy8Ney+PDWVZ2Tj0OIY9arHjAq9nlRLQ5GdP6EyAdFYmW8ApT5jptd9LkqIa
	 D6ac8VZTtz6Uu6ZSdmEuhavfB39OIvQdYR7BbiUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Pauk <pauk.denis@gmail.com>,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20B=C5=BEatek?= <bugs@bzatek.net>,
	Theunis Scheepers <ptscheepers@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/686] hwmon: (nct6775) Add ASUS X870/W480 to WMI monitoring list
Date: Fri, 13 Nov 2026 10:43:53 -0500
Message-ID: <20261113153824.248920559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 21518579cbdeb4e86a6fffbc3d52f52bd74ab87e ]

Boards such as
* G15CE,
* PRIME X870-P WIFI,
* PRIME X870-P,
* Pro WS W480-ACE,
* ProArt X870E-CREATOR WIFI,
* ROG CROSSHAIR X870E APEX,
* ROG CROSSHAIR X870E DARK HERO,
* ROG CROSSHAIR X870E EXTREME,
* ROG CROSSHAIR X870E GLACIAL,
* ROG CROSSHAIR X870E HERO BTF,
* ROG CROSSHAIR X870E HERO,
* ROG STRIX X870-A GAMING WIFI,
* ROG STRIX X870-F GAMING WIFI,
* ROG STRIX X870-I GAMING WIFI,
* ROG STRIX X870E-E GAMING WIFI,
* ROG STRIX X870E-E GAMING WIFI7 R2,
* TUF GAMING X870-PLUS WIFI,
* TUF GAMING X870-PRO WIFI7 W NEO,
* TUF GAMING X870E-PLUS WIFI7,
* W480/SYS,
* X870 AYW GAMING WIFI W,
* X870 MAX GAMING WIFI7 W,
* X870 MAX GAMING WIFI7
have got a nct6775 chip, but by default there's no use of it because of
resource conflict with WMI method.

Add the boards to the WMI monitoring list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Tested-by: Tomáš Bžatek <bugs@bzatek.net>
Tested-by: Theunis Scheepers <ptscheepers@gmail.com>
Link: https://lore.kernel.org/r/20260322131848.6261-1-pauk.denis@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index 555029dfe713f..1975399ac440d 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1159,6 +1159,7 @@ static const char * const asus_wmi_boards[] = {
 	"Pro A520M-C",
 	"Pro A520M-C II",
 	"Pro B550M-C",
+	"Pro WS W480-ACE",
 	"Pro WS X570-ACE",
 	"ProArt B550-CREATOR",
 	"ProArt X570-CREATOR WIFI",
@@ -1258,6 +1259,7 @@ static const char * const asus_wmi_boards[] = {
 	"TUF Z390-PRO GAMING",
 	"TUF Z390M-PRO GAMING",
 	"TUF Z390M-PRO GAMING (WI-FI)",
+	"W480/SYS",
 	"WS Z390 PRO",
 	"Z490-GUNDAM (WI-FI)",
 };
@@ -1270,6 +1272,7 @@ static const char * const asus_msi_boards[] = {
 	"EX-B760M-V5 D4",
 	"EX-H510M-V3",
 	"EX-H610M-V3 D4",
+	"G15CE",
 	"G15CF",
 	"PRIME A620M-A",
 	"PRIME B560-PLUS",
@@ -1320,6 +1323,8 @@ static const char * const asus_msi_boards[] = {
 	"PRIME X670-P",
 	"PRIME X670-P WIFI",
 	"PRIME X670E-PRO WIFI",
+	"PRIME X870-P",
+	"PRIME X870-P WIFI",
 	"PRIME Z590-A",
 	"PRIME Z590-P",
 	"PRIME Z590-P WIFI",
@@ -1362,11 +1367,18 @@ static const char * const asus_msi_boards[] = {
 	"ProArt B660-CREATOR D4",
 	"ProArt B760-CREATOR D4",
 	"ProArt X670E-CREATOR WIFI",
+	"ProArt X870E-CREATOR WIFI",
 	"ProArt Z690-CREATOR WIFI",
 	"ProArt Z790-CREATOR WIFI",
 	"ROG CROSSHAIR X670E EXTREME",
 	"ROG CROSSHAIR X670E GENE",
 	"ROG CROSSHAIR X670E HERO",
+	"ROG CROSSHAIR X870E APEX",
+	"ROG CROSSHAIR X870E DARK HERO",
+	"ROG CROSSHAIR X870E EXTREME",
+	"ROG CROSSHAIR X870E GLACIAL",
+	"ROG CROSSHAIR X870E HERO",
+	"ROG CROSSHAIR X870E HERO BTF",
 	"ROG MAXIMUS XIII APEX",
 	"ROG MAXIMUS XIII EXTREME",
 	"ROG MAXIMUS XIII EXTREME GLACIAL",
@@ -1404,6 +1416,11 @@ static const char * const asus_msi_boards[] = {
 	"ROG STRIX X670E-E GAMING WIFI",
 	"ROG STRIX X670E-F GAMING WIFI",
 	"ROG STRIX X670E-I GAMING WIFI",
+	"ROG STRIX X870-A GAMING WIFI",
+	"ROG STRIX X870-F GAMING WIFI",
+	"ROG STRIX X870-I GAMING WIFI",
+	"ROG STRIX X870E-E GAMING WIFI",
+	"ROG STRIX X870E-E GAMING WIFI7 R2",
 	"ROG STRIX X870E-H GAMING WIFI7",
 	"ROG STRIX Z590-A GAMING WIFI",
 	"ROG STRIX Z590-A GAMING WIFI II",
@@ -1451,6 +1468,9 @@ static const char * const asus_msi_boards[] = {
 	"TUF GAMING H770-PRO WIFI",
 	"TUF GAMING X670E-PLUS",
 	"TUF GAMING X670E-PLUS WIFI",
+	"TUF GAMING X870-PLUS WIFI",
+	"TUF GAMING X870-PRO WIFI7 W NEO",
+	"TUF GAMING X870E-PLUS WIFI7",
 	"TUF GAMING Z590-PLUS",
 	"TUF GAMING Z590-PLUS WIFI",
 	"TUF GAMING Z690-PLUS",
@@ -1460,6 +1480,9 @@ static const char * const asus_msi_boards[] = {
 	"TUF GAMING Z790-PLUS D4",
 	"TUF GAMING Z790-PLUS WIFI",
 	"TUF GAMING Z790-PLUS WIFI D4",
+	"X870 AYW GAMING WIFI W",
+	"X870 MAX GAMING WIFI7",
+	"X870 MAX GAMING WIFI7 W",
 	"Z590 WIFI GUNDAM EDITION",
 };
 
-- 
2.53.0



