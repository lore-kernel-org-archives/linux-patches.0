Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4937EC153
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BD7C433C8;
	Mon, 11 Sep 2023 14:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442931;
	bh=pk6AkanV9ib00L6ReSmA+r7yzWNtyt6VEi55vxspVN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrLVCwq/l3P9e9HdwztOfDG6AMJhUtD5lDKPLIVLiS98QH8Bp0AxqGD+lMsw65/F+
	 tdT7LyTXgJcBRAjX3JA8HQFZwBxNc+UHnIgk9nPBlVQUDkBsliqJsjtOgs4gp8/UJy
	 Tp188ILjqlPcG9BDYbsisP1NdmH/j5lNwfkFlyws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 198/737] Bluetooth: ISO: Fix not checking for valid CIG/CIS IDs
Date: Mon, 11 Sep 2023 15:40:57 +0200
Message-ID: <20230911134656.131429969@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit b7f923b1ef6a2e76013089d30c9552257056360a ]

Valid range of CIG/CIS are 0x00 to 0xEF, so this checks they are
properly checked before attempting to use HCI_OP_LE_SET_CIG_PARAMS.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index dfa45dfb69480..cd07836850758 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1216,6 +1216,12 @@ static bool check_io_qos(struct bt_iso_io_qos *qos)
 
 static bool check_ucast_qos(struct bt_iso_qos *qos)
 {
+	if (qos->ucast.cig > 0xef && qos->ucast.cig != BT_ISO_QOS_CIG_UNSET)
+		return false;
+
+	if (qos->ucast.cis > 0xef && qos->ucast.cis != BT_ISO_QOS_CIS_UNSET)
+		return false;
+
 	if (qos->ucast.sca > 0x07)
 		return false;
 
-- 
2.40.1



