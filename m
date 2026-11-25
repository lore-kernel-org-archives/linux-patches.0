Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618211;
	b=im016OKBEN8ersyVb9Ku4BC5YdSwopbWwNgiC0CdoOMLbgSvQtAUFgrjRstJkM8SHgnx
	 es27KdhXJT6PCb7mHKjxI9KTTMVxVDzxC1fs/dz3q4UD7KSv6viEDY5/OCPyJxmF7+qeo
	 9GSJQF9ESFjUpJC8mr5v4G0bIX/+uBXD8DX6FaF1gNLONuhPbLLkucu2c5yhm8QFeFPmT
	 i2a/SCAXF5dMINzMiDloO6J892ZYkcndEnOONJQwyjd9dD1GCMLVa6QM3d5JPlMGbdefZ
	 P4cqj8DBk6zAT3wu38a763lGFx+khcOKycByokbpAwgY9WrPeNLVFV7VohyacyhZ37g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+9+MYZJyeazbPwq2OrZu3i0chjnZ+KwDUVUbKN2yeQ=;
	b=UaLSO5WEx8EtNIunteChypzNV/0FhKeKcXfD5PqvLWuZ3bdKKqBiIjeO9iwwYkRUDvoJ
	 +12RWXsJZ2OgfCytQjRUVDOPorwxfZN5eiACVO12+mu/5zzxIfb2HeTmN3Xj+noRiQrOa
	 zLY+LzA5a5j4CLiPhH8DOu3HdxzNm6fwWvsvnf1sGp749mrkmMIGlA9j5xwOtD78fp0Mt
	 yzVCrarLvV4vKUEjMWNPuc3hLrwBN0Kes73kH7rjUOiBk/DzsjR99KpMzpw1D1ZjgG6TU
	 eNnRoq177e9BN9oapaficA21UJ/dq5C17XKj88WRU+e1Tzrp47w6cmPHC9dT3bhUd/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ia562EKm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F373606A31E;
	Wed, 25 Nov 2026 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ia562EKm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095481F000D1;
	Wed, 25 Nov 2026 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618210;
	bh=p+9+MYZJyeazbPwq2OrZu3i0chjnZ+KwDUVUbKN2yeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ia562EKmxkYi9dO2qKN2h+Tx/S+ioGPhQ7Q56F7AwiQrUbX1zw0+YAn92pn8bESiO
	 a+Wz045iFrO2ScBzaWo/cZYbxcrFr8Soh4u7AHPnXWpAALC8QiLz3uOZmXm8yQ9LU+
	 tvTjSHiE0cOONkp/4svIZZkP4Kf852AwQWlwlhY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Wilken <tooangel@tooangel.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0205/1005] Bluetooth: MGMT: Return RFKILLED for Set Powered on a blocked controller
Date: Wed, 25 Nov 2026 15:25:43 +0100
Message-ID: <20261125143826.543455417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Tobias Wilken <tooangel@tooangel.de>

[ Upstream commit 7eac80614300563470cffabf4df2b63616787ee7 ]

Since MGMT_OP_SET_POWERED runs through hci_cmd_sync, powering on a
controller that is blocked by rfkill fails with -ERFKILL from
hci_dev_open_sync(), and mgmt_set_powered_complete() reports it with
mgmt_status(err). mgmt_errno_status() has no case for -ERFKILL, so
userspace gets MGMT_STATUS_FAILED instead of MGMT_STATUS_RFKILLED.

Before that conversion, power on went through hci_power_on(), whose
error path mgmt_set_powered_failed() still maps -ERFKILL to
MGMT_STATUS_RFKILLED. bluetoothd relies on that status: for
RFKILLED it sets the adapter PowerState to "off-blocked" and returns
org.bluez.Error.Blocked for the Powered property, for any other status
it returns org.bluez.Error.Failed.

With the controller soft blocked, "bluetoothctl power on" printed
"Failed to set power on: org.bluez.Error.Failed" and btmon showed
"Set Powered (0x0005) Status: Failed (0x03)". With this change it
prints org.bluez.Error.Blocked and btmon shows "Status: RFKilled
(0x12)".

Map -ERFKILL to MGMT_STATUS_RFKILLED in mgmt_errno_status().

Fixes: cf75ad8b41d2 ("Bluetooth: hci_sync: Convert MGMT_SET_POWERED")
Assisted-by: LLM
Signed-off-by: Tobias Wilken <tooangel@tooangel.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index e88d60acee5ab..b964382a01977 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -304,6 +304,8 @@ static u8 mgmt_errno_status(int err)
 		return MGMT_STATUS_DISCONNECTED;
 	case -ECANCELED:
 		return MGMT_STATUS_CANCELLED;
+	case -ERFKILL:
+		return MGMT_STATUS_RFKILLED;
 	}
 
 	return MGMT_STATUS_FAILED;
-- 
2.53.0



