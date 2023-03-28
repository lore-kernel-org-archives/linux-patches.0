Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996688BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E01BC4339B;
	Tue, 28 Mar 2023 14:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015563;
	bh=N7tw/XkKlUjbTzNo+huelrGZjhonDkw2S1z1Nf+rjJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sbefa8jImxsKtrAkZrvVCqqFNGWjmmJJDhF4PqYs4LgNGON/GWy3I1vuqfqzHSrsy
	 hroAuB07QHQcxwVwaMmSQyWYcER+m+j3YKz1OLIbU+HRa1+o27ZRTR5DspbfWqtANA
	 iTl7ohdYzXItMM6jb8qHaiKn0Nkb7Ecw0yvr0dFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archie Pusaka <apusaka@chromium.org>,
	Howard Chung <howardchung@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/224] Bluetooth: mgmt: Fix MGMT add advmon with RSSI command
Date: Tue, 28 Mar 2023 16:41:31 +0200
Message-Id: <20230328142621.189710667@linuxfoundation.org>
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

From: Howard Chung <howardchung@google.com>

[ Upstream commit 1a0291f81529e8044fb29845a0196ba47af894ce ]

The MGMT command: MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI uses variable
length argument. This causes host not able to register advmon with rssi.

This patch has been locally tested by adding monitor with rssi via
btmgmt on a kernel 6.1 machine.

Reviewed-by: Archie Pusaka <apusaka@chromium.org>
Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Signed-off-by: Howard Chung <howardchung@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 7576db8eb83e2..fc4ba0884da96 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9346,7 +9346,8 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
 						HCI_MGMT_VAR_LEN },
 	{ add_adv_patterns_monitor_rssi,
-				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE },
+				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE,
+						HCI_MGMT_VAR_LEN },
 	{ set_mesh,                MGMT_SET_MESH_RECEIVER_SIZE,
 						HCI_MGMT_VAR_LEN },
 	{ mesh_features,           MGMT_MESH_READ_FEATURES_SIZE },
-- 
2.39.2



