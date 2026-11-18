Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020305;
	b=1aLeyTxExRQyTTj80nam3Brt6JhcLMCp07cnG7md8VHYGQYf3d/SlXbjmbrspF4H6MDM
	 l5ICliHrhqgNju1Nn8L2hQl88IbKcOKTDJcve+kjeEXcQQIU58jOKg/mrRwEMBaxIHHTE
	 hDsbisk5bBFghPixCz898aiz8jy/7aJw7om9x8d87pSBtRmRyGCARrG+Z3+DXba+F84Pp
	 4lLvDZg7QVEnTRH7DsRLI1nAoJ2grjKLWEdiEA4Cu+3kCYi1CnpuYZFrhpVlqVmGzoM+J
	 pYWwzQLFFA3aQnrr7rEXBAqgaI4DKtoSPmByxyOe4SUfgerQsrHxofFQmE1xpy8AE7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bPP788t3HxN7KFGpw5pLMw7nkBUJzvalWnVery5aUkU=;
	b=uw4CS2/4tgv/plhhsYXQvtpqrKpvg9sd0gWcS1hqpFeBfLoun7iS+0MJami3rAtHA3i1
	 nZQ2mioPYDxFDaWTNY+YaEmn5joaJvaiNJFefWyJwqvrBIhhugdpxKix2CMY+9LNG4DgP
	 UwCgN38Ae0L1aEoTRObALrZ8K8+0lZ6bsHu292T+BLbw8qGOJ4Yta53l08AOZpgW/c2Dd
	 iMlGSrbYwKf3RG/aPN5YWemG7fIhvVv3o7NWNFwmoAoYmcm5EVAZXSX2kOMw2pnO8egks
	 if0/qau1h2zNDM25wGj54/bCJKzhZhLhSFxtUsSNZ5ZJ/vZujt+xnf8krAty74Jm7dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgw23y42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3C0606A325;
	Wed, 18 Nov 2026 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgw23y42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6711F000C4;
	Wed, 18 Nov 2026 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020305;
	bh=bPP788t3HxN7KFGpw5pLMw7nkBUJzvalWnVery5aUkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgw23y42CnSxFpK1bNLfroDRfrvZMY6s0xx7T9JU+O5tQMlwgkIK4y0td2DBS38nh
	 0+uLIJOu68mMhVUyDsKs0smrz9iJxhrzpmqiLj483FtfFQd/BZeK+PMQ4QWcV7xGyN
	 QKyTfKmrloa9LNrxm/H7lHBYsaq/COn0UJOyM35g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1904/2651] Bluetooth: MGMT: Allow connection rate request as peripheral
Date: Wed, 18 Nov 2026 15:52:24 +0100
Message-ID: <20261118150355.363501667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 47493e62e8a8522a250537ed2ce026dd7d9163b1 ]

Load Connection Subrate only issues the LE Connection Rate Request when
connected as central, but either role can initiate the Connection Rate
Update procedure, e.g. a HID device, which is the peripheral, does it
once the HID host requests a HID SCI mode with the HID Control Point.

Issue it regardless of the role.

Fixes: 19129d7037be ("Bluetooth: Add MGMT Load Connection Subrate command")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 23b65ceea8955..11f01b8d53f80 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8334,8 +8334,10 @@ static int load_conn_subrate(struct sock *sk, struct hci_dev *hdev, void *data,
 		hci_param->cont_num = cont_num;
 		hci_param->rate_supv_timeout = supv_timeout;
 
-		/* If the device is connected as central check if the
-		 * connection rate parameters need to be updated.
+		/* If the device is connected check if the connection rate
+		 * parameters need to be updated, either role can initiate the
+		 * Connection Rate Update procedure, e.g. a HID device acting
+		 * as peripheral once the HID host requests a HID SCI mode.
 		 */
 		if (!i && param_count == 1) {
 			struct hci_conn *conn;
@@ -8344,7 +8346,6 @@ static int load_conn_subrate(struct sock *sk, struct hci_dev *hdev, void *data,
 						       &hci_param->addr,
 						       addr_type);
 			if (conn && conn->state == BT_CONNECTED &&
-			    conn->role == HCI_ROLE_MASTER &&
 			    (conn->le_rate_interval < min ||
 			     conn->le_rate_interval > max ||
 			     conn->le_subrate < subrate_min ||
-- 
2.53.0



