Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024108;
	b=3ViqugezDm/0ZFROO6GKrZRfFz/BisVDG1uJRHHQtWk3mBAoCfVUUOZVyDs6n8ngicM0
	 Ksp6viEpA9YMv1RstX3xAycnOtYhQNEtqzvMxvTA4GxgjeJpzpFpIsOhVxf1QQlJfi3pg
	 agVLE+wQ8Rw4O73sw5zm+8v73r8aG7OZuDiOnTOoQNl9H0URefWOkM8Ys3snCsRnbO/E4
	 ZQvKKzL95F6iQ5FYP5w5NtnQFGVMaek8Pzj+APKToTXYqykNETocfOWRd/M0d1Dfnb+R7
	 hyeJDHJge70OtiyUs0+Q849Y6Hu5v1IKZs/36mI7M3R6fNEzUwKdLJ5kTOB1ZFKUNBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g/T8OmUV9GsD+mhgR2HZ4NYBqqJ3ca8z7/XPSGWfofI=;
	b=tzGBBXl6Z41D4A4/NN/3i5Y1GnXqS2yieh74Jyxx4J0YlR+TJOtpuMl34TyMJw09PB3m
	 2OTHuHjr0f0qWQDQNnGfMS8IaBjH+T5tOV+Hek9YG7r/EEqL3eXm8psqUG58BfGPXDSJ4
	 WOKdvJ/3PSbr2kbTlTOYc0SpvM3y8lEA+JikPE/ejlh2ZkAaUYA4Ia+JJ5gKnBU+DyJKe
	 nQjSeg5VoT0K6g0b+qhUYJ8uqnE6/i1h9uM+TNSOXzStHzue+m3a8v441TVE17CdjIKG8
	 LOxcG983u8lbMt6FV6Wf9wYgpuEWHb7ZhECS3wuW/hAKvtSYEx/QKtCZFGiV4YkfX5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W0B46KaN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2DA606A31C;
	Wed, 18 Nov 2026 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W0B46KaN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F04E1F000C4;
	Wed, 18 Nov 2026 17:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024108;
	bh=g/T8OmUV9GsD+mhgR2HZ4NYBqqJ3ca8z7/XPSGWfofI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0B46KaNIsDM+IbGbNVGrJym1CDwnYRqWO5ph8jHQOJdeqke9HyM2SXkHwA6unlzj
	 04ahNjNjIG7L4sVGeYPVk1J8AniOGklqXdXQyF1dQjHZdlMoi6xYd/pMwyrKWb2NF4
	 R41U/5CWzL2d5lq54/Nc4zPeSlohXGvLopqlgpQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0567/2151] i3c: mipi-i3c-hci: Fix runtime PM violation in i3c_hci_free_ibi()
Date: Wed, 18 Nov 2026 15:38:22 +0100
Message-ID: <20261118150142.601529119@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 1570265b225757e3684a7c13c36915823f62675d ]

i3c_hci_free_ibi() calls __i3c_hci_disable_ibi(), but the latter
requires runtime PM to be resumed.  The ->free_ibi() callback does not
guarantee that condition.

The cases where ->free_ibi() may be called without a preceding
->disable_ibi() do not require re-enabling runtime PM handling:

- runtime resume failed in i3c_dev_free_ibi_locked(), so it skips the
  IBI disable but still proceeds to call ->free_ibi()
- the device has been re-enumerated under a new dynamic address in
  __i3c_master_add_i3c_dev_locked(), which tears down the old device
  descriptor and deliberately clears olddev->ibi->enabled (to avoid
  sending a DISEC to the stale old address) before calling
  i3c_dev_free_ibi_locked().  As a result ->free_ibi() is reached with
  neither a hardware IBI disable nor runtime PM resumed.

In both cases the important requirement is to prevent further IBI
processing for the device.  That can be done without accessing hardware
by removing the device from the ibi_devs[] table.

Replace the call to __i3c_hci_disable_ibi() with clearing the
corresponding ibi_devs[] entry under the controller lock.

Fixes: 650716f23eac4 ("i3c: mipi-i3c-hci: Fix race in i3c_hci_addr_to_dev()")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-9-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 6bb33193970b2..4907d5d724284 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -494,11 +494,13 @@ static void __i3c_hci_disable_ibi(struct i3c_hci *hci, struct i3c_dev_desc *dev)
 
 static void i3c_hci_free_ibi(struct i3c_dev_desc *dev)
 {
+	struct i3c_hci_dev_data *dev_data = i3c_dev_get_master_data(dev);
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct i3c_hci *hci = to_i3c_hci(m);
 
-	/* Must ensure the IBI has been disabled */
-	__i3c_hci_disable_ibi(hci, dev);
+	/* Must ensure IBIs for this device will no longer be processed */
+	scoped_guard(spinlock_irqsave, &hci->lock)
+		hci->ibi_devs[dev_data->dat_idx] = NULL;
 	hci->io->free_ibi(hci, dev);
 }
 
-- 
2.53.0



