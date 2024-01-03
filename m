Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6CC1BDEC;
	Wed,  3 Jan 2024 17:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZMopjV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513DAC433C7;
	Wed,  3 Jan 2024 17:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301939;
	bh=t0wYXU7gCiA4IDqIjiceBxC065D2VhtSKcQXW4PX+1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZMopjV1LBe0jdkZjt7BAuKE65HZVSjfZFH/j5bxfESdFkoPJv1q9zTaPNGpBf4UQ
	 ZT1ahE9EaesRDk6naF5tNfrNP7xyGkwhgsg82jQVj7zB5twQd/ouztG4skBSjheMT5
	 R+zkWpZs4+NKByXLQG7MXHMEycDmf9IQ2hvY6azY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.10 74/75] Bluetooth: SMP: Fix crash when receiving new connection when debug is enabled
Date: Wed,  3 Jan 2024 17:55:55 +0100
Message-ID: <20240103164854.140372742@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 995fca15b73ff8f92888cc2d5d95f17ffdac74ba upstream.

When receiving a new connection pchan->conn won't be initialized so the
code cannot use bt_dev_dbg as the pointer to hci_dev won't be
accessible.

Fixes: 2e1614f7d61e4 ("Bluetooth: SMP: Convert BT_ERR/BT_DBG to bt_dev_err/bt_dev_dbg")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/smp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3239,7 +3239,7 @@ static inline struct l2cap_chan *smp_new
 {
 	struct l2cap_chan *chan;
 
-	bt_dev_dbg(pchan->conn->hcon->hdev, "pchan %p", pchan);
+	BT_DBG("pchan %p", pchan);
 
 	chan = l2cap_chan_create();
 	if (!chan)
@@ -3260,7 +3260,7 @@ static inline struct l2cap_chan *smp_new
 	 */
 	atomic_set(&chan->nesting, L2CAP_NESTING_SMP);
 
-	bt_dev_dbg(pchan->conn->hcon->hdev, "created chan %p", chan);
+	BT_DBG("created chan %p", chan);
 
 	return chan;
 }
@@ -3364,7 +3364,7 @@ static void smp_del_chan(struct l2cap_ch
 {
 	struct smp_dev *smp;
 
-	bt_dev_dbg(chan->conn->hcon->hdev, "chan %p", chan);
+	BT_DBG("chan %p", chan);
 
 	smp = chan->data;
 	if (smp) {


