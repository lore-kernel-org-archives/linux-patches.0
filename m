Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621304;
	b=tQynxAQhGRA5TluPAto9e1IMIj1NjCanga14D1ub7Mjw+6KZOdt7rwQjSZESyX9w5IC6
	 A9mrfVbBCUGH/eSdyywRRAatb55iBz7QNVW9Qf0Bxm4159rNCI2rMLSxKdf07aqK64GmE
	 j3RAVUat0YNAUlHYnsScwoVTUG/pp1RHLVqPTUe+e33jx/71XcjWMb6nl25F9GiN+soa1
	 H9gvmBgr09j8rWYtwYtN3U/898rtwiO5qf6U1eP13wk1FZS8QHwiZqdRlLui231txUwXO
	 3Nzu3R0RFrL22EtvyDTpX82hr3TPh2LnsfUQhhqSDw8p2kRvQ0gLNmUjm+D6emDMyrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38OZvLOs1Le+g2cLSFRGseT8LMDFeMF4e6Um+3ALkno=;
	b=GqASDXw0z7z7rG+IKqw5Bv0/1i/gLMA0+gNm1i6tOMQ70FvKJTLpY2Uk+3Y5hnrwTZ7Y
	 yn9GiWJ1S0b2JpQxh4eaOPpH93x1MFeeyk/9zPHMuZZECNBDOVb+bpZuy7RMlddNs9u7o
	 oUJyZxgAGrEPm3DnI4xJW80K7aYtU7cnqkzSAIqkLcPYc5NweimRh/bwZ+pzmPYIFyQzN
	 GJNzLajAb7MqV+xi3uknlTZRp5kZ4P158tNNWoiF8IpYjt/FshEXrY3gWlzzHBri5wvrq
	 qDb2DadJtiH+Han2m23Oj8M3H40GjXBLHY1TyHS6Y0x8su9wDbT5rLt4PJoSVD6ddLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8jcs9m4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD69607DE9F;
	Wed, 25 Nov 2026 15:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z8jcs9m4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFB21F0089F;
	Wed, 25 Nov 2026 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621303;
	bh=38OZvLOs1Le+g2cLSFRGseT8LMDFeMF4e6Um+3ALkno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8jcs9m4rlexMaDcPGbRLD3BSSG+jKDk9ireqAmvEGq3LMuZCE8uTu0ioi5k5SBLk
	 LC0HKarkYo5gph0veXTYnSX5Z18XL/ORk7mQ1r68sVuzlAcuueK0TQ56/i8lp+wN52
	 Sf4nOXejV/KWospfsPsbkkHmbv9f+5tt+eglc3xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Wilken <tooangel@tooangel.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 184/990] Bluetooth: MGMT: Return RFKILLED for Set Powered on a blocked controller
Date: Wed, 25 Nov 2026 15:25:51 +0100
Message-ID: <20261125143826.403766167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6e49f77c363f8..484243146f10e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -306,6 +306,8 @@ static u8 mgmt_errno_status(int err)
 		return MGMT_STATUS_DISCONNECTED;
 	case -ECANCELED:
 		return MGMT_STATUS_CANCELLED;
+	case -ERFKILL:
+		return MGMT_STATUS_RFKILLED;
 	}
 
 	return MGMT_STATUS_FAILED;
-- 
2.53.0



