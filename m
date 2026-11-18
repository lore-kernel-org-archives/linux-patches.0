Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020269;
	b=4ZgjhtY8eGG3/vU4EN315fkxZEq5WfsnLzGsCAhtvJTosnrQP2nZtGFr0rBw3D/yAkg3
	 pl1MzK4Ilvu/YrYaQVt9pvQgvlgbDhfKNjajYqMeNnHMZDPYqLNnq+P0MXdu3c+P/a0Mh
	 r8Zyw/BBae2tEozqwuTgFX+HueMd7KeDOfLbZzE6LRQF1sYPV6w0uHFLWKj7gOHJXm3yL
	 +MS9hVZSZS9VQ7a1rbiwT9u6OwEQ2NFAeV9l3H8SyNQ6tIgqyTcogyC6g4gkpUlcDU5ou
	 3ift4crthoXEUMhaDDqM7DpXVVQIAVoH7QK3LL2rPCJLYhpS0/dczE5X36N4riiuAug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mw+oRt4I/bUIA2KXykDx3clGCcD+jmqL8f1gxxvLKL0=;
	b=jtUlogsz5u100DR22WTAhWFz1pONwUwGTOtyH5thILQrBmRN5Bwt73CU3K5mRPRDj7uV
	 srf70+J4cvlyD1Z7epQ1XxodXz3mmzVuP5Z5t4TSE78eqREAia4sCOQ7V/tUHbCYZ5IX4
	 Owxr9+5g7vv2ob49J8vP4i8yRg8xCs45Sl9iBkVqC0yO8jEXdKYm2Ipv62zMAi9fdWEol
	 W3EuB+AoTJTVJr3d+2b7IC7N9IS3q+0OgUTSCAmfaxRj3r3fYvOxA3r1I6snIuhjRkWg4
	 KBFUWZxFh1Tn+1iJnS26zPSlXdzhISjVyFPNr1W40mVJ+0A4t1RnRHPKWv8eSUhdrOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDjJJCNZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CB9606A320;
	Wed, 18 Nov 2026 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDjJJCNZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D931F000C4;
	Wed, 18 Nov 2026 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020269;
	bh=Mw+oRt4I/bUIA2KXykDx3clGCcD+jmqL8f1gxxvLKL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDjJJCNZawUbtIhxUisDHPv5RdBG2NbWJlueHIi2N9cBndzTShBd7ewIGG2hFljYg
	 PLt6Q0gWlypIZoLEHUUcXQFFXriSzjJVlrK91iYkZweuDdWgdFEF/wfJCQc8Cx6ksy
	 myLFjEhkFCNirQK4NNz9NgFfFWGUZZMk0mGQlWOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1892/2651] Bluetooth: MGMT: Fix leaking instance on Add Extended Advertising Parameters
Date: Wed, 18 Nov 2026 15:52:12 +0100
Message-ID: <20261118150354.990794172@linuxfoundation.org>
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

[ Upstream commit f7f0d0a9eb6e4616c0b3a2a95498b5204c5543c9 ]

If queueing the command fails the instance is never removed, despite it
having already been added or modified by hci_add_adv_instance, so remove
it as it is done by add_ext_adv_params_complete on failure, signaling
it has been removed if it was previously added.

Fixes: cba6b758711c ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 492b86f39bdf9..09fa3202f28ab 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9348,14 +9348,15 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 				       data, data_len);
 		if (!cmd) {
 			err = -ENOMEM;
-			hci_remove_adv_instance(hdev, cp->instance);
-			goto unlock;
+			goto remove;
 		}
 
 		err = hci_cmd_sync_queue(hdev, add_ext_adv_params_sync, cmd,
 					 add_ext_adv_params_complete);
-		if (err < 0)
+		if (err < 0) {
 			mgmt_pending_free(cmd);
+			goto remove;
+		}
 	} else {
 		rp.instance = cp->instance;
 		rp.tx_power = HCI_ADV_TX_POWER_NO_PREFERENCE;
@@ -9366,6 +9367,18 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 					MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
 	}
 
+	goto unlock;
+
+remove:
+	/* The instance may have been modified already so remove it, like it
+	 * is done in add_ext_adv_params_complete, signaling it has been
+	 * removed if it was previously added.
+	 */
+	if (!adv->pending)
+		mgmt_advertising_removed(sk, hdev, cp->instance);
+
+	hci_remove_adv_instance(hdev, cp->instance);
+
 unlock:
 	hci_dev_unlock(hdev);
 
-- 
2.53.0



