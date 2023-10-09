Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7341E18E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLW5cSqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A62C433D9;
	Mon,  9 Oct 2023 13:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857025;
	bh=jkvDx5+K2+lo0MKcZcWTC3ju5DS25KUe+EoX2cGlxqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLW5cSqete2/vtrTJGUJcnxgPokb825xOFhuL/F67+CUh4zpw1PxkvLTtJyjbsTHX
	 jpSo0Og8w/DzLfGHhkXMKSoC2l+vnsVobNRGZp1qCj2vYB+8JFmFPtrmHSHtOJzBI+
	 OFqDhszMzuR5VJoy/FoNrcjOu5Piej6gL6J4Ci3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	linux-input@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 071/163] HID: nvidia-shield: add LEDS_CLASS dependency
Date: Mon,  9 Oct 2023 15:00:35 +0200
Message-ID: <20231009130126.010931258@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 058574879853260a22bbec1f94221dfc5149d85c ]

The hid-nvidia-shield driver uses functions that are built
only when LEDS_CLASS is set, so make the driver depend on that
symbol to prevent build errors.

riscv32-linux-ld: drivers/hid/hid-nvidia-shield.o: in function `.L11':
hid-nvidia-shield.c:(.text+0x192): undefined reference to `led_classdev_unregister'
riscv32-linux-ld: drivers/hid/hid-nvidia-shield.o: in function `.L113':
hid-nvidia-shield.c:(.text+0xfa4): undefined reference to `led_classdev_register_ext'

Fixes: 09308562d4af ("HID: nvidia-shield: Initial driver implementation with Thunderstrike support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e11c1c8036769..dc456c86e9569 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -792,6 +792,7 @@ config HID_NVIDIA_SHIELD
 	tristate "NVIDIA SHIELD devices"
 	depends on USB_HID
 	depends on BT_HIDP
+	depends on LEDS_CLASS
 	help
 	  Support for NVIDIA SHIELD accessories.
 
-- 
2.40.1



