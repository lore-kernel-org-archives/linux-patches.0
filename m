Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB5C171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD82AC433EF;
	Mon, 22 May 2023 19:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784608;
	bh=roCqDH/rrFtOfxVCQCfNrQQhMMOYcsjmHbrYglM5Mhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWUeCHVCgThMy4Nh6dCMaNwPAD7GErZrW1Ry4Q1a3ZygAuE50wJBMu9mCpBdVFGkA
	 a1LqETf5VNKxalkuqJhIDb4kZnoL3D8TbnPnByFJPRuOO/umYiBAN9dPb9mi7PnMAL
	 Z6q/73VN+8BTESGED1/y/y2Vppeit09LpfJ7UAUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Chou <max.chou@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 139/364] Bluetooth: btrtl: check for NULL in btrtl_set_quirks()
Date: Mon, 22 May 2023 20:07:24 +0100
Message-Id: <20230522190416.253238595@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Max Chou <max.chou@realtek.com>

[ Upstream commit 253cf30e8d3d001850a95c4729d668f916b037ab ]

The btrtl_set_quirks() has accessed btrtl_dev->ic_info->lmp_subver since
b8e482d02513. However, if installing a Realtek Bluetooth controller
without the driver supported, it will hit the NULL point accessed.

Add a check for NULL to avoid the Kernel Oops.

Signed-off-by: Max Chou <max.chou@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 44b672cca69ee..7061621faeb0c 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -889,6 +889,9 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 		break;
 	}
 
+	if (!btrtl_dev->ic_info)
+		return;
+
 	switch (btrtl_dev->ic_info->lmp_subver) {
 	case RTL_ROM_LMP_8703B:
 		/* 8723CS reports two pages for local ext features,
-- 
2.39.2



