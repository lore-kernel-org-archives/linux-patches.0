Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AF8353A9F;
	Wed, 30 Sep 2026 15:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782557; cv=none; b=ikt/f92H6IX4ilGav23aH8p+cj0kJ08l761I4S2rssZ83gLw+TthRVTaf8KJgogFY/2GR0lxP03VetZfxDsMH61tG6RQo2vYzf+GI2SjgQvd+nFRSVMqgd4zD5jEszemRKm9MdZSnY5u9DQ/Uox4GJb57feYBqkbxo1aS5zU3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782557; c=relaxed/simple;
	bh=sa2II61VVsDw8Y2H8VNK2nl/BHNhlj4JhoxYmqLBcP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fZ0FdGF9KCr4uMWEKOsU89D6jZzJulNsilmkbNgcPOZWEWUAl4VRTt3J7UyHoifsxcu8yfmMD8XXSPZfOP/RxbfU2QyryULHj+iPYhoTtKmEDTP6eWDu6c12po7MYNIYhah4fO7VJcY3ZjMEK+NzJ/lDX5wdB+kn8aVXPKBrcoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FhG0wHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FhG0wHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0D51F0089E;
	Wed, 30 Sep 2026 15:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782547;
	bh=FU8dLSj4/WpKCFF3cR3Ae6rq1LRcBzNhAwprUTGI99M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FhG0wHqHDoxa9wqTlkrr24JUFqISbhWRx8rVMvAnf16lnNfDT0Tw0iygZyNBq/YP
	 D0quu4e/wDiJuNNFcjPuHnzMQKh4ux/1708Qq8iNonjnF+VFcD1LS6JUtj6xMpfwJF
	 irOgrnG2U7Md/GB4c8HQN6OUbYu1m3+N8rCeNGTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/595] soundwire: only handle alert events when the peripheral is attached
Date: Wed, 30 Sep 2026 17:19:38 +0200
Message-ID: <20260930152349.567079874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 38cd651ebce7065a81c7e950d9e2ea1572304605 ]

It doesn't make sense to handle an alert event when the peripheral is
not attached. The slave->status could be SDW_SLAVE_ATTACHED or
SDW_SLAVE_ALERT when it is attached on the bus.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260520025720.1999367-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 0e0a19030c35b..bd770e49f3142 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1697,6 +1697,10 @@ int sdw_handle_slave_status(struct sdw_bus *bus,
 			break;
 
 		case SDW_SLAVE_ALERT:
+			if (slave->status != SDW_SLAVE_ATTACHED &&
+			    slave->status != SDW_SLAVE_ALERT)
+				continue;
+
 			ret = sdw_handle_slave_alerts(slave);
 			if (ret)
 				dev_err(bus->dev,
-- 
2.53.0



