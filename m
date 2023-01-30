Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FC828EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22EEC433D2;
	Mon, 30 Jan 2023 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087380;
	bh=7XHLPMU1fY9bHhjTAB2VACPgkQ6SnlET8O2RT5Crodw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSziEjBfbGDCpx5Se/eadiZ5coJscf4OnbJr9O5FeTPjp9oJc0xAQJ8KKM6hsqqlM
	 Hnbt1fJtncKj6Y43iqX876oxGkOD2p2/HByBtYXOrZmAxiKMBC3/fxy8aVwrs+gHcb
	 Zn8Zhtt3xNCqNEwzTZmWyztaJSdA/MB3ybKvO8jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henning Schild <henning.schild@siemens.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/313] platform/x86: simatic-ipc: add another model
Date: Mon, 30 Jan 2023 14:50:23 +0100
Message-Id: <20230130134345.459326679@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Henning Schild <henning.schild@siemens.com>

[ Upstream commit d348b1d761e358a4ba03fb34aa7e3dbd278db236 ]

Add IPC PX-39A support.

Signed-off-by: Henning Schild <henning.schild@siemens.com>
Link: https://lore.kernel.org/r/20221222103720.8546-3-henning.schild@siemens.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/simatic-ipc.c            | 1 +
 include/linux/platform_data/x86/simatic-ipc.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/platform/x86/simatic-ipc.c b/drivers/platform/x86/simatic-ipc.c
index 2ab1f8da32b0..b3622419cd1a 100644
--- a/drivers/platform/x86/simatic-ipc.c
+++ b/drivers/platform/x86/simatic-ipc.c
@@ -47,6 +47,7 @@ static struct {
 	{SIMATIC_IPC_IPC427E, SIMATIC_IPC_DEVICE_427E, SIMATIC_IPC_DEVICE_427E},
 	{SIMATIC_IPC_IPC477E, SIMATIC_IPC_DEVICE_NONE, SIMATIC_IPC_DEVICE_427E},
 	{SIMATIC_IPC_IPCBX_39A, SIMATIC_IPC_DEVICE_227G, SIMATIC_IPC_DEVICE_227G},
+	{SIMATIC_IPC_IPCPX_39A, SIMATIC_IPC_DEVICE_NONE, SIMATIC_IPC_DEVICE_227G},
 };
 
 static int register_platform_devices(u32 station_id)
diff --git a/include/linux/platform_data/x86/simatic-ipc.h b/include/linux/platform_data/x86/simatic-ipc.h
index a4a6cba412cb..a48bb5240977 100644
--- a/include/linux/platform_data/x86/simatic-ipc.h
+++ b/include/linux/platform_data/x86/simatic-ipc.h
@@ -33,6 +33,7 @@ enum simatic_ipc_station_ids {
 	SIMATIC_IPC_IPC127E = 0x00000D01,
 	SIMATIC_IPC_IPC227G = 0x00000F01,
 	SIMATIC_IPC_IPCBX_39A = 0x00001001,
+	SIMATIC_IPC_IPCPX_39A = 0x00001002,
 };
 
 static inline u32 simatic_ipc_get_station_id(u8 *data, int max_len)
-- 
2.39.0



