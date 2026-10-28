Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212815;
	b=4Om0VpC8e2CFSWTrK4UwN40RTiE/3vhKQwSAqFahomYdfWPGLu6Jv4C6hX789nFcufId
	 qBXS68Rofh1g+95quDARzycGxwyNx5PybxzSK0Z9zQlavZ+G6laXHYBiNQ9m2rk1NMe4n
	 4ZKnF+pFvh4pEaIdefPwRmno3exxwj3/BvMdu/6KUftKVh24yIFs0cZNgndGao4H/RTVu
	 wnk8zZ8TWuMqvkcZKs+vTThIWt06soU/NQJNgNwNpVxvnczHHs0EzKEmKx79rpTfCa3bn
	 2E4t/N0jwYrb8RXmoIMODxvnXvhhtmEjLthlWvaa5SPIb6mTAv+3Y40i9kwXIQX+Eog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ihKs/0fGrLhRGOnDBcI1/YJssryCFrLllCj+Ze4JHUw=;
	b=jCKoy9eZQ8ClddL3CSd7owRM4Ffmz7AkiETgHz2OQKNMSIObbkXX/4b++XyyXn8QjfLe
	 aSw6aKeUmoNY02hDaDcs8uMWDgFrR4oV0256169Wti3Pca0FQmVjCLw3NWh9CwczpC5uO
	 KPK55zE2tvjcCe/BiwVq7fAsrNY74sxXscPnwonjrQsNzWQWVru/qvBqXRXoend7tffy4
	 uY/zt13sVD7K45W57ynsx3akizYIsF2yId+hvzjX1f6RTnQuvjds8Z/vLiQmd+NeBfO91
	 dNZj2QNglnqbgq4EEXslHzLbY6jZnqG2bhhW98D4dq1egl3WxfJlAP1m4hvdwZbejrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dd3JgWT2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D7E606A31A;
	Wed, 28 Oct 2026 18:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dd3JgWT2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023F81F01825;
	Wed, 28 Oct 2026 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212814;
	bh=ihKs/0fGrLhRGOnDBcI1/YJssryCFrLllCj+Ze4JHUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dd3JgWT2WlbVE7o3N0l3MopmsNzn/WgTWExvAcAaUaKRg8LhQm6t+rKPXOG/U14cA
	 EXrXFrLmTg/2CZoC3LYspup03S7/x54ahXTuNfPtUNNTWAGUfjsuN75kKkDqkZ/mLR
	 BFJonv6Ql1gUJFT2gxMsqE4FQ2xzzfSKvYkvLy4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 0285/1887] usb: typec: ucsi: Get the connector fwnode based on reg value
Date: Wed, 28 Oct 2026 17:39:41 +0100
Message-ID: <20261028170505.715240895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 6c51f09c6db5868a5090e8dd4d7764660c87f1ad upstream.

ucsi_find_fwnode() currently maps UCSI connectors to Device tree
connector nodes based on the order in which connector child nodes
are described in DT.

This can fail because the ordering of child nodes isn't guaranteed
in Device-tree. For example, DTB may contain connector@1 before
connector@0, causing connector numbers to be associated with the wrong
fwnode. As a result, role switch and Type-C notifications can be
delivered to the wrong remote endpoints.

Fix this by using the "reg" property of each connector to match
its corresponding fwnode. While at it, if the reg property isn't
present, then fall back to the old method.

Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: stable <stable@kernel.org>
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260916042808.2879079-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1092,10 +1092,21 @@ static struct fwnode_handle *ucsi_find_f
 {
 	struct fwnode_handle *fwnode;
 	int i = 1;
+	int ret;
+	u32 port;
 
-	device_for_each_child_node(con->ucsi->dev, fwnode)
-		if (i++ == con->num)
-			return fwnode;
+	device_for_each_child_node(con->ucsi->dev, fwnode) {
+		ret = fwnode_property_read_u32(fwnode, "reg", &port);
+		if (ret < 0) {
+			if (i == con->num)
+				return fwnode;
+		} else {
+			if (port == con->num - 1)
+				return fwnode;
+		}
+
+		i++;
+	}
 	return NULL;
 }
 


