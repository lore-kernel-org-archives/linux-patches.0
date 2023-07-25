Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1711ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9F6C433C8;
	Tue, 25 Jul 2023 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285581;
	bh=C00KkHY+enJaF1a4oWABZtQ4k+DSDoeFw3y+avdKAHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ansbjlhn4F9V12etIZi34/vjXuKmiTh/0q28YAnYUHsAV7qmqHxz401gCFT+j9kDH
	 LoFnkr76OdzB5F4bZsdZ9pqDu9iJ3gOVaGaJH//VX1XyBwX7gJPOp+xWhZONDDl3vK
	 umKNIVygRojmDP4+d7BkQDt5JxMDhk2n7fHYi/Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 217/313] platform/x86: wmi: Fix indentation in some cases
Date: Tue, 25 Jul 2023 12:46:10 +0200
Message-ID: <20230725104530.434264842@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6701cc8f70710826a4de69cbb1f66c52db2c36ac ]

There is no need to split lines as they perfectly fit 80 character limit.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 028e6e204ace ("platform/x86: wmi: Break possible infinite loop when parsing GUID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 62b146af35679..1aa29d594b7ab 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -1122,8 +1122,7 @@ static void wmi_free_devices(struct acpi_device *device)
 	}
 }
 
-static bool guid_already_parsed(struct acpi_device *device,
-				const u8 *guid)
+static bool guid_already_parsed(struct acpi_device *device, const u8 *guid)
 {
 	struct wmi_block *wblock;
 
@@ -1333,10 +1332,8 @@ static void acpi_wmi_notify_handler(acpi_handle handle, u32 event,
 		wblock->handler(event, wblock->handler_data);
 	}
 
-	if (debug_event) {
-		pr_info("DEBUG Event GUID: %pUL\n",
-			wblock->gblock.guid);
-	}
+	if (debug_event)
+		pr_info("DEBUG Event GUID: %pUL\n", wblock->gblock.guid);
 
 	acpi_bus_generate_netlink_event(
 		wblock->acpi_device->pnp.device_class,
-- 
2.39.2



