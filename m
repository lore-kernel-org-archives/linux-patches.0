Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C442F2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B98C433EF;
	Tue, 18 Apr 2023 12:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822198;
	bh=+2bpAMDbBUFRnw5Pd4u49sFhwEGAGJoldbqx40xXM9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jn7zqDFgyycJoBmDb4fvpkleaxzkejqJsNa6RBP5AdOTrns9zj29EaML1JHSHZfkX
	 7dFDagiwNZVyl2qjeT+eHh3u4t4TItyZ268I+fxO7Q57CEw/90bSU7/YVf92vQ/qXS
	 1E8NPC0XCDeF2W5sS9Dp6TizwSqdxdVfAZuhnEhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudia Draghicescu <claudia.rosu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 059/139] Bluetooth: Set ISO Data Path on broadcast sink
Date: Tue, 18 Apr 2023 14:22:04 +0200
Message-Id: <20230418120315.991088195@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudia Draghicescu <claudia.rosu@nxp.com>

[ Upstream commit d2e4f1b1cba8742db66aaf77374cab7c0c7c8656 ]

This patch enables ISO data rx on broadcast sink.

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Signed-off-by: Claudia Draghicescu <claudia.rosu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index e68f2a7d863ac..e87c928c9e17a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6991,7 +6991,7 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 		bis->iso_qos.in.latency = le16_to_cpu(ev->interval) * 125 / 100;
 		bis->iso_qos.in.sdu = le16_to_cpu(ev->max_pdu);
 
-		hci_connect_cfm(bis, ev->status);
+		hci_iso_setup_path(bis);
 	}
 
 	hci_dev_unlock(hdev);
-- 
2.39.2



