Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624339;
	b=fyli2P0JZssKLMIQFQ9+NOSDEaZTaILROfMO1dOicsCHXAx7hY8R0ORdxMKGp9mbsKH1
	 VjLV1dfr3xAvKRk+kqlsnKx3WOmxD59AE4N1iMbYzqy6ze90DmeLYii+wVNzvmOnN9O+j
	 y7zBQmS50aArX0j4P6C0ghDtw5e2zrjnO0ApduKj9PDIFVgnEFz22dTXKjUZdB3pd5mk0
	 sOkpXJWssD0j50k2ADUlWsRHWw+9lUE6AImc9XfmrZyechxteBh2z6HOiCQxLZnbphO4w
	 oQzNw5L1rTW+FYAql+W1c1Ou9/WaZW02xtfjVe0vdxOuLMlaL23MgRQAaVoymoLOOHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86ifAsgDsH6DPH7a3NOwiA5bKKRbbFDvtrpYd5litic=;
	b=QCZZwXhQAMVFDH7O5FwpqHJrEIw83aZflVz0mkAwzTGeJxLtYlojSheXg5RvXbFpIajL
	 NguAKNLQokLkmJgLyVImy89JHoiAiLj87VNDeGwNmtsZAUi2gsdvbPJ4C/7dyZhZ6xW4p
	 DWNzhO00vHcsCWuqWhqn5A+1JL5Dpq7w7Fail5zmOY5N4fx91PTBBhRr1tbihGS1Xwugo
	 nV4Nv4RZHfo14JhtoBtQvO20egF6dFeq41HDVCE1CaT4A7r0Mqbi3Nc/JKQPjxIN8nyRn
	 OzS6qiJVFnyAF4wKlF5OC9Yw7SnZpmhi8yQFWYcdRMa96We47BpCmPT+lfKl9ilC06Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhXSbveW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E665606A33C;
	Wed, 25 Nov 2026 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhXSbveW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDE91F000C0;
	Wed, 25 Nov 2026 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624338;
	bh=86ifAsgDsH6DPH7a3NOwiA5bKKRbbFDvtrpYd5litic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JhXSbveWNIZPQzI3ko9Pf1yzuNb+LEXEE2PRgBqeRLsIbGYo2Fxarz730C5In3v9m
	 wVbVI9umh5m3oobXAALfP9agb60sg+uE9b9AhAUr0bGTOqDhU8RYQ84As+KPJjG8Lc
	 Fu3W92pcMw/L+cd2rseEZ1fVVDKO2ozjRMpvyMrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Wilken <tooangel@tooangel.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/816] Bluetooth: MGMT: Return RFKILLED for Set Powered on a blocked controller
Date: Wed, 25 Nov 2026 15:28:28 +0100
Message-ID: <20261125143852.900051549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index a9570bd4f33dd..ec54d383510f4 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -305,6 +305,8 @@ static u8 mgmt_errno_status(int err)
 		return MGMT_STATUS_DISCONNECTED;
 	case -ECANCELED:
 		return MGMT_STATUS_CANCELLED;
+	case -ERFKILL:
+		return MGMT_STATUS_RFKILLED;
 	}
 
 	return MGMT_STATUS_FAILED;
-- 
2.53.0



