Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1000E11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DECC433C7;
	Mon, 11 Sep 2023 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444557;
	bh=78ni0kbTx0POg0XnLhC/vMAeqKmtNkTpXY+nxrByBrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lANguFn6dVwsE06WTPwwPX39+ByRzHEP1IeG/fvqunwJCA1mcWsXPwoe64MHgM4H5
	 KZrjKm5spZIKjpUhYJvSJMW5RLK3WaA+Y4ibSRxhaArz6KsS70BLjaMyyxKJAQfFmz
	 +NMtCQuh0GAaiMnzoEN9frvp/RoqGQPNIJLniIqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/600] platform/x86/intel/hid: Add HP Dragonfly G2 to VGBS DMI quirks
Date: Mon, 11 Sep 2023 15:41:08 +0200
Message-ID: <20230911134634.638748502@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index df533b277b999..b96ef0eb82aff 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -131,6 +131,12 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
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



