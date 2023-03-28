Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DD78BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5335C433EF;
	Tue, 28 Mar 2023 15:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015624;
	bh=VPK43WTU3u1Y+HzGZcYVPGCanzSOJSkJMhKfBtCLQoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjsrZaZ4hEB+cFoWN4K+enlVZKS5wavgCtiC4ySgbp4hLuK+SFjN6dLHkSpPMmTrK
	 zzeOqUiJb2yBFpi1ze3yT9mxiPWv2XSO3aXfj7bphVSTaDweJOhKsnklXRlIhTyePF
	 r872R6D9TgcK+QdIVUEEHBeQj3/qae8+fpW5ZPh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Gix <brian.gix@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/224] Bluetooth: Remove "Power-on" check from Mesh feature
Date: Tue, 28 Mar 2023 16:41:20 +0200
Message-Id: <20230328142620.768463984@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Gix <brian.gix@gmail.com>

[ Upstream commit 52dd5e964a55c98c1b0bcf5fc737a5ddd00e7d4d ]

The Bluetooth mesh experimental feature enable was requiring the
controller to be powered off in order for the Enable to work. Mesh is
supposed to be enablable regardless of the controller state, and created
an unintended requirement that the mesh daemon be started before the
classic bluetoothd daemon.

Fixes: af6bcc1921ff ("Bluetooth: Add experimental wrapper for MGMT based mesh")
Signed-off-by: Brian Gix <brian.gix@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 0dd30a3beb776..7576db8eb83e2 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4627,12 +4627,6 @@ static int set_mgmt_mesh_func(struct sock *sk, struct hci_dev *hdev,
 				       MGMT_OP_SET_EXP_FEATURE,
 				       MGMT_STATUS_INVALID_INDEX);
 
-	/* Changes can only be made when controller is powered down */
-	if (hdev_is_powered(hdev))
-		return mgmt_cmd_status(sk, hdev->id,
-				       MGMT_OP_SET_EXP_FEATURE,
-				       MGMT_STATUS_REJECTED);
-
 	/* Parameters are limited to a single octet */
 	if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
 		return mgmt_cmd_status(sk, hdev->id,
-- 
2.39.2



