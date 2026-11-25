Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625374;
	b=RGR18nJhUjURkaW+grI+dj5fqKw7MOymGEoXTzlzKZ31YH1yW482RVKHbhUkTbr/kl5H
	 RQMPhCwiaHY4irjor8MiQBfejix4w3Up1kf/Y0pr5Z9ejJXLaANB3kPWzRF/mA+ccUPii
	 d3vcKJSsCESZl6yL2pqOxTVdmZHc8TfonGHrOOD9qlh1CG8JsiJ969Us2zA+1rwRC88R1
	 6dFUnhstttgPT4W/0lgzOrQW5809tBxJINSFAOAzgq4DVJ8xapsDXbPlPyphq/eZk57ss
	 QOAfwaej0QlH/O3+vrKci6UCkog3T1KpQpDg8WgK5HsWWrpGF9RKHpErK/caiEzfLCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9+m+BFbgsrzDCAEhrgZeXbgiim0k6WOlux+5APXZtgA=;
	b=Mm6uxxfnD5ACC6YlScKjCExVwfLqqyA3dEAjv3uXAzk0birpgGmfGO3KdYrz87JhVgnO
	 T9Db5a5PTcD6KLQqmxphN2SuMgxQZq+pxpBXenncDk1xUH26mEhDw226YnxwT+juIYtU4
	 csWqMo6eA38QFTsi+25W/ThzlWhi81yrVJR+xTlJr27TzH2HHHm+8yL4zGwtKZC0RhVr0
	 D8W2vSibJ1WXUn3BppZRvC/YcqRjmlQyq/oUNcgnlQmTTtTAxPx13G9x3OXKrHtAw/3EQ
	 S7Ae6IgRRgoWQX0sTW+XS8otoW3CJUWkp2orFLncsTTk8WBiC40oP+6kw80Qj38yHBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiNX44cx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4774B606A31E;
	Wed, 25 Nov 2026 16:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiNX44cx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186101F000C4;
	Wed, 25 Nov 2026 16:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625373;
	bh=9+m+BFbgsrzDCAEhrgZeXbgiim0k6WOlux+5APXZtgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiNX44cxCoCmuxD37ESVwgakDVYdVX6H3K4A564XgBHAKXYVtwC/9Gd2cU4ONlNLz
	 wEW4W6I4w9Iyu1xo/7Np86vGunHeLFj+oIrFlP7y4t8ho/bgb4lEDnDxPMVzAsdYXN
	 YaCXsWQ9ch5SemPKV852LWL6bWjaXzIvntpAdDsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 494/816] Bluetooth: hci_sync: fix mesh adv timeout units
Date: Wed, 25 Nov 2026 15:34:02 +0100
Message-ID: <20261125143900.626093194@linuxfoundation.org>
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
[ sashal: Kept the tree's msecs_to_jiffies(timeout * 1000) for the non-mesh case instead of upstream's secs_to_jiffies(timeout), since that helper isn't used in this file here, and added the mesh branch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index e51af37b10152..3793fc359a9ff 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1731,7 +1731,8 @@ int hci_enable_ext_advertising_sync(struct hci_dev *hdev, u8 instance)
 	 * scheduling it.
 	 */
 	if (adv && adv->timeout) {
-		u16 duration = adv->timeout * MSEC_PER_SEC;
+		u16 duration = adv->mesh ? adv->timeout :
+					   adv->timeout * MSEC_PER_SEC;
 
 		/* Time = N * 10 ms */
 		set->duration = cpu_to_le16(duration / 10);
@@ -2191,7 +2192,8 @@ int hci_schedule_adv_instance_sync(struct hci_dev *hdev, u8 instance,
 		hdev->adv_instance_timeout = timeout;
 		queue_delayed_work(hdev->req_workqueue,
 				   &hdev->adv_instance_expire,
-				   msecs_to_jiffies(timeout * 1000));
+				   adv->mesh ? msecs_to_jiffies(timeout) :
+					       msecs_to_jiffies(timeout * 1000));
 	}
 
 	/* If we're just re-scheduling the same instance again then do not
-- 
2.53.0



