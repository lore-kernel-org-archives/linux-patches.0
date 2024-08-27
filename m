Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2244312B93;
	Tue, 27 Aug 2024 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770864; cv=none; b=HQVKYlx85e1drtEYZZOdWwR8mAQhrAq/A/YsaeWlBXN98MOcG6adMj/yoGkNs6b3ScGmI13r3SfY0xmT9F8GL2UJ5DAPYwCIiE1GMb6a1++6+oQ8ROzSV6zcJj9z/LzaT24d7oz/7917yPg0rtydntjFedAq+CdtN6A13+4NM6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770864; c=relaxed/simple;
	bh=S/jtrc/eZyOgeTjkcY/vSZ+mDBCjODzB5UhYHiwdPuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1kietqGjS6VCQpZA1wmKN4qgA7x4pH+S2dXvPn4/u4NgB4uSyDJvHFtwVtD+uz4tMDg1vSwfdQJOacxH2Qgzr5y8uT5n0BdT27D8vBaNdXF7DT3NCK9vrDrYNbLB2RNZCKSPDf00mujNdSBC/G4HRHkickd+hdNJ+y7S4nfdMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGYMy07O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGYMy07O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B3CC4AF1C;
	Tue, 27 Aug 2024 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770864;
	bh=S/jtrc/eZyOgeTjkcY/vSZ+mDBCjODzB5UhYHiwdPuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGYMy07OQ8KsZB6u592PjOXVoyc55IMsk0k7rz3h2ax2pL2FRap+hpGgNqHQj0+eO
	 bpA2ZvBKvcrU2e/xKBoiZQI3DbCvR/PH1oYAJj/PQCfHWPq+CBU2WZUa7ZT8o3lWSN
	 asIP+ToYcAYO618ZxyG9Pv48yRyx/cQ+VltyAxrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.10 016/273] usb: misc: ljca: Add Lunar Lake ljca GPIO HID to ljca_gpio_hids[]
Date: Tue, 27 Aug 2024 16:35:40 +0200
Message-ID: <20240827143834.004518660@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 3ed486e383ccee9b0c8d727608f12a937c6603ca upstream.

Add LJCA GPIO support for the Lunar Lake platform.

New HID taken from out of tree ivsc-driver git repo.

Link: https://github.com/intel/ivsc-driver/commit/47e7c4a446c8ea8c741ff5a32fa7b19f9e6fd47e
Cc: stable <stable@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240812095038.555837-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usb-ljca.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/usb-ljca.c
+++ b/drivers/usb/misc/usb-ljca.c
@@ -169,6 +169,7 @@ static const struct acpi_device_id ljca_
 	{ "INTC1096" },
 	{ "INTC100B" },
 	{ "INTC10D1" },
+	{ "INTC10B5" },
 	{},
 };
 


