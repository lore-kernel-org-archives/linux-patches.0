Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A002572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E2FC433EF;
	Tue, 18 Apr 2023 12:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821828;
	bh=6wchamMSYFZzj3IOxrv4ZyWxAlgKuxNuNT/ag0HJQrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGhnNSZFUTJkewgZlMTCUK3Q1cDVW/shdaMl9JcmSOcQcS57pKajThN4LlUkbu8d5
	 ppNbX9GuYXb8/7YUHXyN8HNeo57IGNzy2bvIpc3m5eXdmc1Oj2O1b+sUFrHSKx85d9
	 1dc+eEorNDdMW7OF+W2JyLb19RR4PXac2KL8mUb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudia Draghicescu <claudia.rosu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/134] Bluetooth: Set ISO Data Path on broadcast sink
Date: Tue, 18 Apr 2023 14:21:53 +0200
Message-Id: <20230418120314.933174240@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
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
index 78c505f528a47..42a3a19b111e3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6981,7 +6981,7 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 		bis->iso_qos.in.latency = le16_to_cpu(ev->interval) * 125 / 100;
 		bis->iso_qos.in.sdu = le16_to_cpu(ev->max_pdu);
 
-		hci_connect_cfm(bis, ev->status);
+		hci_iso_setup_path(bis);
 	}
 
 	hci_dev_unlock(hdev);
-- 
2.39.2



