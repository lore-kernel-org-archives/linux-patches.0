Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FBC1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB531C433C7;
	Mon, 11 Sep 2023 14:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442462;
	bh=5gnewnyw4jnlnRBMqMSpB2sVF/jo454EytG+XIs5mWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLgkol3UokhRxcULVKhs04bx1GUPia4nAxkos5OcGS3wpjn89q4k5LfT/BfqHkkxv
	 xAExKVexil6eZiAVCasnHX3K895yQ6aQ4dM5CCp9HwVbFFGW0PLQazOXTMNdgVni29
	 kk3xxjPA8LSr4RFXSxLJA7unEfhS1NIw6l232APs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 034/737] platform/x86/intel/hid: Add HP Dragonfly G2 to VGBS DMI quirks
Date: Mon, 11 Sep 2023 15:38:13 +0200
Message-ID: <20230911134651.362801535@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit 7783e97f8558ad7a4d1748922461bc88483fbcdf ]

HP Elite Dragonfly G2 (a convertible laptop/tablet) has a reliable VGBS
method. If VGBS is not called on boot, the firmware sends an initial
0xcd event shortly after calling the BTNL method, but only if the device
is booted in the laptop mode. However, if the device is booted in the
tablet mode and VGBS is not called, there is no initial 0xcc event, and
the input device for SW_TABLET_MODE is not registered up until the user
turns the device into the laptop mode.

Call VGBS on boot on this device to get the initial state of
SW_TABLET_MODE in a reliable way.

Tested with BIOS 1.13.1.

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/r/20230716183213.64173-1-maxtram95@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 641f2797406e1..7457ca2b27a60 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -150,6 +150,12 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Elite Dragonfly G2 Notebook PC"),
+		},
+	},
 	{ }
 };
 
-- 
2.40.1



