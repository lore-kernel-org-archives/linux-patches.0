Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043457;
	b=ZFYuU4NcFrAjSWjvbgWTdJGUR9w+e5Uc/LgYGUCqT0ZHfoiP05fzwG7VQ1bCqHS3BLeO
	 /8F/r5YWxkwChijOb3A2YXJwyrSggHHWMp+ex/zdiiKXm76zhemd1O7AiaUFUaDqoBDFs
	 eC+l1THntyGEwDj1sZ3atfV8OBFevtX/ifXBrl6kOkQa3l1eQmMDuSF2F6hnEMDg+Wu6r
	 i3+z9DpGGy4PBo0+rXhu9zqz0Pn0kCK929zQbAZWKY4HeApIsSHOG00HCTD1kISpE89bU
	 EUswotpYRU3lnBFnJAdCh/ZkyHHOqph+VYTkZ1LxNh2XrxERHXPe31Pf2yMElKO2aiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A1sBGW/pv/O8tuX7VGTYUlWCH0jCqo4reH+FZQj3hFc=;
	b=dBT3MZKOYYVJ0TX8/C01CXvLT2WyP+2p8inn+oQQc8ePWUIOro3fII9yFBqM4xiiL+1r
	 IhxAnjqVPbTQXiMo1/edPJ11lsD6M+x2odGKn1oVHIXJjcUpOlIHIQ7aPIMlZuvxq7G+l
	 cFM5or3wbW4hrm3pDj+MiiAPgXy9jJ1M7s/suSTe9aN365Q6/pKkl83VZPQSoEYcEumy5
	 lJT/4s/+HeAxzfGuoJ2lKd96bfqAWMY8KPo33l5urp6bZlFj+B9mE/0jmJXT76pIQTJGx
	 7kxSzyhGHInE/0QcZQfqSj+2rrTChBchZHKztMgwoSvBUDC9jurhMEVj/HHG7DzQ7ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=paKQx3bL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F8960A261A;
	Wed, 18 Nov 2026 23:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=paKQx3bL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFDF1F000C4;
	Wed, 18 Nov 2026 23:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043457;
	bh=A1sBGW/pv/O8tuX7VGTYUlWCH0jCqo4reH+FZQj3hFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=paKQx3bLgW1tUyZ083AhMxOS4aZooED7kskgprT44L3S7v4rMOXeww6zunqM7OTsN
	 gXxdOPKCKNwV1BNGyeWA0/tZ2txgBoDzMkFaThvHwzXizstBTrgIVli574ka5SSVhS
	 Q/TRG1FFWJt2lV+xh3CxKh+DhqM2990Og+prfeQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Saheed <muhammad.saheed.iam@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0217/2857] Bluetooth: hci_sync: Disable legacy instances ext adv before setup snapshot
Date: Wed, 18 Nov 2026 15:20:51 +0100
Message-ID: <20261118150209.280284483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index c0c19abd92590..28e7fa689aae8 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1196,6 +1196,32 @@ int hci_update_random_address_sync(struct hci_dev *hdev, bool require_privacy,
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
@@ -1421,6 +1447,10 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
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



