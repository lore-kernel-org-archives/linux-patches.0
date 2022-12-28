Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FAA1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9679C433EF;
	Wed, 28 Dec 2022 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245833;
	bh=ipKdulpmmSmjZ0WXk55vOzU802/+Oml+uBFJbdoVsIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEyQnU7H4p0nAZL7v1HLVRUFsMKxW0r6FfGmdqYDo5WHEcmjDVQkSQXqMDGiM+XxZ
	 FuOB0WIes0MqOHR8dx/LxDhuqBs0tuGAugteEtOnkwQ0mr0fKD2nDxg//WO4BN0TEW
	 dpBW302Gh3POAHr9iowImq6hdl6mA2yvB0HGPADM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Pauk <pauk.denis@gmail.com>,
	yutesdb <mundanedefoliation@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0966/1073] hwmon: (nct6775) add ASUS CROSSHAIR VIII/TUF/ProArt B550M
Date: Wed, 28 Dec 2022 15:42:34 +0100
Message-Id: <20221228144354.290178409@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit 1864069c695d475e0ce98a335c62274b81be57b4 ]

Boards such as
* ProArt B550-CREATOR
* ProArt Z490-CREATOR 10G
* ROG CROSSHAIR VIII EXTREME
* ROG CROSSHAIR VIII HERO (WI-FI)
* TUF GAMING B550M-E
* TUF GAMING B550M-E (WI-FI)
* TUF GAMING B550M-PLUS WIFI II
have got a nct6775 chip, but by default there's no use of it
because of resource conflict with WMI method.

This commit adds such boards to the WMI monitoring list.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Reported-by: yutesdb <mundanedefoliation@gmail.com>
Tested-by: yutesdb <mundanedefoliation@gmail.com>
Link: https://lore.kernel.org/r/20221114214456.3891-1-pauk.denis@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index 41c97cfacfb8..50fe9533cf43 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1043,7 +1043,9 @@ static struct platform_device *pdev[2];
 
 static const char * const asus_wmi_boards[] = {
 	"PRO H410T",
+	"ProArt B550-CREATOR",
 	"ProArt X570-CREATOR WIFI",
+	"ProArt Z490-CREATOR 10G",
 	"Pro B550M-C",
 	"Pro WS X570-ACE",
 	"PRIME B360-PLUS",
@@ -1055,8 +1057,10 @@ static const char * const asus_wmi_boards[] = {
 	"PRIME X570-P",
 	"PRIME X570-PRO",
 	"ROG CROSSHAIR VIII DARK HERO",
+	"ROG CROSSHAIR VIII EXTREME",
 	"ROG CROSSHAIR VIII FORMULA",
 	"ROG CROSSHAIR VIII HERO",
+	"ROG CROSSHAIR VIII HERO (WI-FI)",
 	"ROG CROSSHAIR VIII IMPACT",
 	"ROG STRIX B550-A GAMING",
 	"ROG STRIX B550-E GAMING",
@@ -1080,8 +1084,11 @@ static const char * const asus_wmi_boards[] = {
 	"ROG STRIX Z490-G GAMING (WI-FI)",
 	"ROG STRIX Z490-H GAMING",
 	"ROG STRIX Z490-I GAMING",
+	"TUF GAMING B550M-E",
+	"TUF GAMING B550M-E (WI-FI)",
 	"TUF GAMING B550M-PLUS",
 	"TUF GAMING B550M-PLUS (WI-FI)",
+	"TUF GAMING B550M-PLUS WIFI II",
 	"TUF GAMING B550-PLUS",
 	"TUF GAMING B550-PLUS WIFI II",
 	"TUF GAMING B550-PRO",
-- 
2.35.1



