Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060977;
	b=vHK4B5x4jc/+owopXR2UvQbP5Vis/fjpWnlYaMEuGq9ynLmjsNJJJT1IIIhLxE7k156d
	 o+dWaZM34S76vH8xONpswghbh1+N/pMrGPtmFXsz+iqZ+PMcw2mhLTjmz3lCbSVd/Tdi8
	 udohhWmfos54JK68eVwtNwGXsqCkc5wlGHfctnRK3vRqUqVAlTCKoKbykNs3lanD69PRj
	 159wqJQovRaNm5LzyH81nKX+m04QpoqR2qmSmGYuVxpmq+gOCUNYbpt+GVlibgQjMlCVg
	 /tId5q8XqTmIuKMsn/5Ww0RE/yyGlvI9hIbBzp45IavKDaLJkqkN5wCtkcgnyMJwPog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNf14rqRJ9WmPmAuvLOy/J+W0/7cttM19uGodxydB9c=;
	b=4xLJvFCa2SIvCNjkbCC32r4qFuRRYqwfXCHSVD9k1EqQkYhSbN53Md6AVs2AfrM+ETzZ
	 pf0bfX3CQzUAaquacU4y5Cckg1RQ6Mb4DUJCa4Vv5le9u+H4BewmiFZBLa/HSnY9mq09M
	 yHMRtePYDspmvoSeKj6zIhMWNG0SHajh8dTVcvTJFmcIpOfq/pr5rRpdXQkD9eoc8c9Dl
	 OwNKvFth+QiFpl4TA/Yva1tN/v5o/iRJ3v4MBbnMK5WCCjGr+afDyZpuYw0BDls+R5/zM
	 HZZnNWdZqFvLu1R9gs2Bc2nXZ7rr8FV5tme+WAXmAvZMmaukqJHfqP23O03GiRMufMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B60uiOeR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CFD606A33C;
	Sat,  7 Nov 2026 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B60uiOeR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F451F0089F;
	Sat,  7 Nov 2026 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060977;
	bh=dNf14rqRJ9WmPmAuvLOy/J+W0/7cttM19uGodxydB9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B60uiOeRqSLm6qoX/2VxNLLFzO1pbxjjoYWEVWz8JrTRg/ieF6k6hhgA4dTWZzM3N
	 Xv93J7HqwRVplXRnw8Nt5qCmP1m8o1/1jiGnxJYZvBiBI9iGI1angmgoaxH/IN0RYs
	 9nR5i6t5wOiSLHAGoeYmy7d+88Ak/M3IvDGUNdd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Saheed <muhammad.saheed.iam@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0295/1536] Bluetooth: hci_sync: Disable legacy instances ext adv before setup snapshot
Date: Sat,  7 Nov 2026 08:38:31 -0500
Message-ID: <20261107135006.018285973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Saheed <muhammad.saheed.iam@gmail.com>

[ Upstream commit 75722cde87ee24029e93e4e32d85309989f55991 ]

hci_setup_ext_adv_instance_sync(...) only disabled
HCI_OP_LE_SET_EXT_ADV_ENABLE before setup snapshot in case of non-legacy
instances (instance > 0) and never disabled the same for legacy instance
(instance == 0). This would lead to failure in setting ext adv params
with HCI_ERROR_COMMAND_DISALLOWED (0x0c) error like below, when toggling
the discoverable/connectable property of a controller with advertising
enabled.
```
$ btmgmt advertising off
hci0 Set Advertising complete, settings: powered ssp br/edr le
  secure-conn wide-band-speech cis-central cis-peripheral
$ btmgmt connectable on
hci0 Set Connectable complete, settings: powered connectable ssp br/edr
  le secure-conn wide-band-speech cis-central cis-peripheral
$ btmgmt connectable off
hci0 Set Connectable complete, settings: powered ssp br/edr le
  secure-conn wide-band-speech cis-central cis-peripheral

$ btmgmt advertising on
hci0 Set Advertising complete, settings: powered connectable ssp br/edr
  le advertising secure-conn wide-band-speech cis-central cis-peripheral
$ btmgmt connectable on
Set Connectable for hci0 failed with status 0x0a (Busy)
$ btmgmt connectable off
Set Connectable for hci0 failed with status 0x0a (Busy)

$ dmesg
...
[   21.970527] hci0: Opcode 0x2036
[   21.970529] hci0: opcode 0x2036 plen 25
[   21.970537] hci0: skb len 28
[   21.970539] hci0: length 1
[   21.976099] hci0: result 0x0c
[   21.976105] hci0: end: err -16
[   21.976114] Bluetooth: hci0: Opcode 0x2036 failed: -16
```

Signed-off-by: Muhammad Saheed <muhammad.saheed.iam@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index de4db563e247e..654bb2454e20a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1184,6 +1184,32 @@ int hci_update_random_address_sync(struct hci_dev *hdev, bool require_privacy,
 	return 0;
 }
 
+static int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
+{
+	struct hci_cp_le_set_ext_adv_enable *cp;
+	struct hci_cp_ext_adv_set *set;
+	u8 data[sizeof(*cp) + sizeof(*set) * 1];
+	u8 size;
+
+	if (!hci_dev_test_flag(hdev, HCI_LE_ADV_0))
+		return 0;
+
+	memset(data, 0, sizeof(data));
+
+	cp = (void *)data;
+	set = (void *)cp->data;
+
+	cp->num_of_sets = 0x01;
+	cp->enable = 0x00;
+
+	set->handle = 0x00;
+
+	size = sizeof(*cp) + sizeof(*set) * cp->num_of_sets;
+
+	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_ADV_ENABLE,
+				     size, data, HCI_CMD_TIMEOUT);
+}
+
 static int hci_disable_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 {
 	struct hci_cp_le_set_ext_adv_enable *cp;
@@ -1409,6 +1435,10 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 			return -EINVAL;
 		}
 	} else {
+		err = hci_disable_ext_adv_legacy_instance_sync(hdev);
+		if (err)
+			return err;
+
 		adv = NULL;
 	}
 
-- 
2.53.0



