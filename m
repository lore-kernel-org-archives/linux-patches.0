Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026711;
	b=MT6nfA1CdH9WTvgvrZnscW/JmF9ByoxB60WGow5ah000TkNwoe+9Yz+BrXLubl148A9b
	 Kd0xYqfECdmqFeV/PKRmjOXRzjOdiW8R3jjHTfCa1pJuObqTnWd1Z8IYOiTr01T/3CgxD
	 iYgqyNw5SSh+k/8tT3NFeXYl//HQ3Qde5MToCDY+Dx4x9M1K3DF3W5DiDNKCYNgAZLKZb
	 3fCRebkPJ3GQ9jepXRMdWvyW9zhhl+aOe2vi9yujYa9BPhFEEiSnxc/JWFyaB1aTw6SjM
	 cmjM+gZioJXLyTkrFR1MmLVJcnYPslpc4dKwj/bMBLN7EzuV2sPB/Cb+MT3esIePPvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ng6OZf38MCPFtmEKwC6y8/3FhPx4ik2S96I2W0oeXCc=;
	b=puSul7HEqAgA5Cj4O2Zd9dc3+iAervTT4iNiNIAQI1ZyJPNNqepj5d/Us1VeU0DVG1ey
	 /mVlgRVqs93zIUxpo2R3o5Qd8NzviT9h6vTQRxX25XLowM8yyIIlDyf78ClPUiTTAtNA4
	 H+igHY8RmnbxI3c+MabAnM3Hey9+BqcuG9yccMMwGE5uCZ0j7QaR6k+9u/v1VX+Do4Cyt
	 8ZkMTM5XM5jEBPRIj5oVOXOIA9sy0Pv5NDr/vLFnP8TVQetmtJ5NSaM//Jl7yKkCqaLUH
	 uvrH8/Jx8f6hWQkSeHN3hySXQykEanNJZrx+aia9DE7HQIAPogk+3z9L2MCVStCuSiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTJPt7ot;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCEB606A325;
	Wed, 18 Nov 2026 18:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTJPt7ot
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C921F000C4;
	Wed, 18 Nov 2026 18:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026711;
	bh=Ng6OZf38MCPFtmEKwC6y8/3FhPx4ik2S96I2W0oeXCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTJPt7ot2mTFXTcniIgJbSN96EbIKhFujNhlkLBw578eUULBkP9D1ngWnh9DTqK84
	 UUCJl+fbKUOs1ls/y3bgV+ryqWtSQuX7GX5/Dl/Zwa7oM9pXfLtnc3FYJBNtya5TTb
	 Nec6YQpkhGhrKXju+iA8qswzGGp52YnxnejC5Vzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1532/2151] Bluetooth: hci_sync: fix mesh adv timeout units
Date: Wed, 18 Nov 2026 15:54:27 +0100
Message-ID: <20261118150217.631833723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 8a8d51eeedebfa5aaaae7720f2fb2aa1a67b8587 ]

Mesh adv instance timeout and duration are in milliseconds, see
mesh_send_sync, hci_add_adv_instance.  hci_schedule_adv_instance_sync()
and hci_enable_ext_advertising_sync() ignore this, and scale the timeout
wrong.

Fix for mesh instances by using msecs_to_jiffies() in
hci_schedule_adv_instance_sync and fixing the scaling in
hci_enable_ext_advertising_sync.

Fixes BlueZ "Mesh - Send cancel" test failures.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Assisted-by: opencode:qwen3.8-flash-next sashiko
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9cb1cdbff3fd2..8bedfab14cdf2 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1694,7 +1694,8 @@ int hci_enable_ext_advertising_sync(struct hci_dev *hdev, u8 instance)
 	 * scheduling it.
 	 */
 	if (adv && adv->timeout) {
-		u16 duration = adv->timeout * MSEC_PER_SEC;
+		u16 duration = adv->mesh ? adv->timeout :
+					   adv->timeout * MSEC_PER_SEC;
 
 		/* Time = N * 10 ms */
 		set->duration = cpu_to_le16(duration / 10);
@@ -2124,7 +2125,8 @@ int hci_schedule_adv_instance_sync(struct hci_dev *hdev, u8 instance,
 		hdev->adv_instance_timeout = timeout;
 		queue_delayed_work(hdev->req_workqueue,
 				   &hdev->adv_instance_expire,
-				   secs_to_jiffies(timeout));
+				   adv->mesh ? msecs_to_jiffies(timeout) :
+					       secs_to_jiffies(timeout));
 	}
 
 	/* If we're just re-scheduling the same instance again then do not
-- 
2.53.0



