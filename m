Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015011;
	b=iB2YoFRqKfsnJ8mq8LGC0zDQ0Ww3qb98G1voRfKfNWZZhTmZsP8o0X+boP2E3I0SayUO
	 G1a9r1O8u4uhQEO+Ep1c9wgAe9jCscpcvAPL7oLtwIghwwbq+Shc2YslCVkBBvxw8QtaL
	 2CtSxPxYnCbLxIuzt1knoHRaeizmoXCgzm4S8xYUGr6EjdUSA+u1kDKP7tk7tF9P3rhq2
	 al5V3HiNN2JZOcEH8HIBa0daY+xdwgl2BbZgeZdQBGEFiM8YFldY+dw7lflSFmtFnwuCV
	 467sCV+1Tyye/ng2OezUjdwQf9JZu41nxZmcIsk/3DvV8viy/mDbZVTTVK3hWN48DRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K7p/g54w2hkXUZepIy/QI+kflIAZwzsRPIlPSld5AIM=;
	b=xbQnc6hk0bEJAAZizDRkfOPprk+eFBdXMHHLsG6OCDnl2ASRf2kzZ+XK6jI7VOYISjM3
	 Hy+yHzXxG+l5643HbaEO8Y8hHSlG0ElMk0nXrlnY3FWUpqp5O8ofCLBESXyja52P4OU0F
	 uclq1ELIWEqx+7I9ToCCJjSATkKu3pnam8rDitGKV1AbJd+oy0Hh880IKjwM85qBPc3sI
	 TEQJiieVBml0R7B4qBR2j+geqiWfPyuVGUYpwAlUsi+JQgDNCu8zKgSrwhmqlkS86SvYY
	 S3AY5/Qz0di0pflBXc4bom7f/6QPLZHipwIEclXJf6lHtkx19aDhOFen7mxd99milrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcH4mzTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC00D606A32F;
	Wed, 18 Nov 2026 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcH4mzTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEF71F000C9;
	Wed, 18 Nov 2026 15:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015010;
	bh=K7p/g54w2hkXUZepIy/QI+kflIAZwzsRPIlPSld5AIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcH4mzTdRnJJ/DLbAB8mHDbH1++k0ewjK9pfVdpQ7TbBkcyK71UcojXZVvceCmzUL
	 QMJjRhY5+GEQQBaL6fiNmuv8ugl9U+qJLafj1ffYVSZbdGQbN66yBzqh0tEKF5LzmH
	 +6ivCiaFCVgXMhQU7CwUwvyyNfyMQQc9GUNy+oas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0021/2651] Bluetooth: btusb: Build the driver from multiple source files
Date: Wed, 18 Nov 2026 15:21:01 +0100
Message-ID: <20261118150248.751272532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit be58267a34ae562a4a6932f68f1487bceb0345d7 ]

Allow the driver to include vendor USB-transport-specific source files by:
- renaming btusb.c to btusb_main.c
- making btusb.o a composite object

Used by Qualcomm QCC2072 support.

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: df5e35f1663a ("Bluetooth: btusb: drop BROKEN_EXT_SCAN quirk for 0bda:a728")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/Makefile                  | 2 ++
 drivers/bluetooth/{btusb.c => btusb_main.c} | 0
 2 files changed, 2 insertions(+)
 rename drivers/bluetooth/{btusb.c => btusb_main.c} (100%)

diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index e6b1c1180d1dc..8b436c6de8b76 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -51,4 +51,6 @@ hci_uart-$(CONFIG_BT_HCIUART_MRVL)	+= hci_mrvl.o
 hci_uart-$(CONFIG_BT_HCIUART_AML)	+= hci_aml.o
 hci_uart-objs				:= $(hci_uart-y)
 
+btusb-y				:= btusb_main.o
+
 CONTEXT_ANALYSIS := y
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb_main.c
similarity index 100%
rename from drivers/bluetooth/btusb.c
rename to drivers/bluetooth/btusb_main.c
-- 
2.53.0



