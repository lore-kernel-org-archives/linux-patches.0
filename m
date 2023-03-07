Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BD6BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0C6C4339E;
	Tue,  7 Mar 2023 17:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210829;
	bh=MUriy0Aq8bDuK/sfBTMpGV4KMRXL3dxl6eDkYtPsB50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2sAOf6IW7BcXjEjLZgBJzlfNtsKUcVAXojgKaXRG5F8Blg81vCtTXNCdevE8fUT6
	 O9LyyxWnYQiWjR425fFjnG6S6iBw6nUxRxPm5MUeJTMXqMYK5f+Mgl/NaMvyvIxFkr
	 NuPPXvdA6cZG416gfsUV/Fjp1WIp3ctP9GbTXQHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0668/1001] platform/x86: dell-ddv: Add support for interface version 3
Date: Tue,  7 Mar 2023 17:57:20 +0100
Message-Id: <20230307170050.600768569@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 3e899fec5dfce37701d49d656954a825275bf867 ]

While trying to solve a bugreport on bugzilla, i learned that
some devices (for example the Dell XPS 17 9710) provide a more
recent DDV WMI interface (version 3).
Since the new interface version just adds an additional method,
no code changes are necessary apart from whitelisting the version.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230126194021.381092-2-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-ddv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-ddv.c b/drivers/platform/x86/dell/dell-wmi-ddv.c
index 2bb449845d143..9cb6ae42dbdc8 100644
--- a/drivers/platform/x86/dell/dell-wmi-ddv.c
+++ b/drivers/platform/x86/dell/dell-wmi-ddv.c
@@ -26,7 +26,8 @@
 
 #define DRIVER_NAME	"dell-wmi-ddv"
 
-#define DELL_DDV_SUPPORTED_INTERFACE 2
+#define DELL_DDV_SUPPORTED_VERSION_MIN	2
+#define DELL_DDV_SUPPORTED_VERSION_MAX	3
 #define DELL_DDV_GUID	"8A42EA14-4F2A-FD45-6422-0087F7A7E608"
 
 #define DELL_EPPID_LENGTH	20
@@ -49,6 +50,7 @@ enum dell_ddv_method {
 	DELL_DDV_BATTERY_RAW_ANALYTICS_START	= 0x0E,
 	DELL_DDV_BATTERY_RAW_ANALYTICS		= 0x0F,
 	DELL_DDV_BATTERY_DESIGN_VOLTAGE		= 0x10,
+	DELL_DDV_BATTERY_RAW_ANALYTICS_A_BLOCK	= 0x11, /* version 3 */
 
 	DELL_DDV_INTERFACE_VERSION		= 0x12,
 
@@ -340,7 +342,7 @@ static int dell_wmi_ddv_probe(struct wmi_device *wdev, const void *context)
 		return ret;
 
 	dev_dbg(&wdev->dev, "WMI interface version: %d\n", version);
-	if (version != DELL_DDV_SUPPORTED_INTERFACE)
+	if (version < DELL_DDV_SUPPORTED_VERSION_MIN || version > DELL_DDV_SUPPORTED_VERSION_MAX)
 		return -ENODEV;
 
 	data = devm_kzalloc(&wdev->dev, sizeof(*data), GFP_KERNEL);
-- 
2.39.2



