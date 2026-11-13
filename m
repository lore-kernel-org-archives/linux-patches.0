Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590972;
	b=hK/YXe9otRF5nadc1q1nsbhHkxJUdVpvwZfS8dgmqExO19RBY4IwzvB6mMVHwyjvzK5P
	 xmNoUj73aRDbwe270WmfmSfqgpj75VisCjNslmvOrzWsA7Y6TDv80AjlsotVlDcu29HLA
	 4qPD1Z0sHHD8eqmfUH6ci31sDZ7HtUmNCkGpnKKAvsMoCXSXIXUaE4RciZ2uMMK/b2Hih
	 hw4tMYT3BZRQxDMO4aAjqw97s3GSubNbGpYgMFgyw7GOhtsE8211hqzZKDdGaWDkTBy5a
	 nSyKQZQZDA25x18qdS1Huk8/Kna33Gidj9nieyUXa0r7etW/nel5O8pDnmvoMYHqJSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KySVHTu01w/w2MgAMmKG43IZnH3i+yo+2mOm7bxGeiU=;
	b=regK/9hxmV0slmCde5SE0cfxPZ+7xcfZoD/K0wQae1VRfcP/edSsQXR+grndgNV0kWZ+
	 PiI/z9BAzK2lJq3C+d8ZSa3icRI1jgbYt5Np9174ruPbYZhYVDp9GAXJzKAGW/4KxEIMx
	 Pd+NSo4JbRdg9QsY25fGRTna0Tho8Qo0TFQGXiBcWfBS5eoFrB6CHVyVzUP13tKNxfynS
	 6pcrkbGk/txMJP+nmkhWBt4NXhhyOZhw+AFF78OPNPnh0IrpA0m7jCCZ9iNJg/1oD927I
	 00Q34ub9JOpan01Jp34wk70j75pBLqoV5doGvqSKDWOTvAtlnokHp1CUAE+/biOGsxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IDQdpLa0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE49C606F729;
	Fri, 13 Nov 2026 17:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IDQdpLa0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB061F000C4;
	Fri, 13 Nov 2026 17:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590972;
	bh=KySVHTu01w/w2MgAMmKG43IZnH3i+yo+2mOm7bxGeiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDQdpLa0noPqwaEENrUTEml40LC6syb12FwJL6ksgns+u2FEYrKr+aZ3/A/RTQKsp
	 Oo5PIrmEUta0DAQA+nyl5O1wJU/SFZvDx4OgagZjmjMY+nGTcLH+woIcCbtYzsNbAf
	 grgEOOveJkyXYs11PGUnLWwN8gFfkAvA4to9Bu/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Pauk <pauk.denis@gmail.com>,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20B=C5=BEatek?= <bugs@bzatek.net>,
	Theunis Scheepers <ptscheepers@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/670] hwmon: (nct6775) Add ASUS X870/W480 to WMI monitoring list
Date: Fri, 13 Nov 2026 10:44:21 -0500
Message-ID: <20261113153815.184918741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8016f146d90df..4b0003280f11f 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1158,6 +1158,7 @@ static const char * const asus_wmi_boards[] = {
 	"Pro A520M-C",
 	"Pro A520M-C II",
 	"Pro B550M-C",
+	"Pro WS W480-ACE",
 	"Pro WS X570-ACE",
 	"ProArt B550-CREATOR",
 	"ProArt X570-CREATOR WIFI",
@@ -1257,6 +1258,7 @@ static const char * const asus_wmi_boards[] = {
 	"TUF Z390-PRO GAMING",
 	"TUF Z390M-PRO GAMING",
 	"TUF Z390M-PRO GAMING (WI-FI)",
+	"W480/SYS",
 	"WS Z390 PRO",
 	"Z490-GUNDAM (WI-FI)",
 };
@@ -1269,6 +1271,7 @@ static const char * const asus_msi_boards[] = {
 	"EX-B760M-V5 D4",
 	"EX-H510M-V3",
 	"EX-H610M-V3 D4",
+	"G15CE",
 	"G15CF",
 	"PRIME A620M-A",
 	"PRIME B560-PLUS",
@@ -1319,6 +1322,8 @@ static const char * const asus_msi_boards[] = {
 	"PRIME X670-P",
 	"PRIME X670-P WIFI",
 	"PRIME X670E-PRO WIFI",
+	"PRIME X870-P",
+	"PRIME X870-P WIFI",
 	"PRIME Z590-A",
 	"PRIME Z590-P",
 	"PRIME Z590-P WIFI",
@@ -1361,11 +1366,18 @@ static const char * const asus_msi_boards[] = {
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
@@ -1403,6 +1415,11 @@ static const char * const asus_msi_boards[] = {
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
@@ -1450,6 +1467,9 @@ static const char * const asus_msi_boards[] = {
 	"TUF GAMING H770-PRO WIFI",
 	"TUF GAMING X670E-PLUS",
 	"TUF GAMING X670E-PLUS WIFI",
+	"TUF GAMING X870-PLUS WIFI",
+	"TUF GAMING X870-PRO WIFI7 W NEO",
+	"TUF GAMING X870E-PLUS WIFI7",
 	"TUF GAMING Z590-PLUS",
 	"TUF GAMING Z590-PLUS WIFI",
 	"TUF GAMING Z690-PLUS",
@@ -1459,6 +1479,9 @@ static const char * const asus_msi_boards[] = {
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



