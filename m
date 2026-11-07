Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064626;
	b=aw3txTEg1C6PjNSsynF0/ZATpc4fl665ThJx3IRpF1zHrsI3A/olcYpDkh4vTgDaQcs4
	 nAnG9LbIitP+m75o35Nx6voZ0sPqA9PrS/Nl334sHF9p37fdIW6EfbSHtR7v+Uu02Pj1q
	 v7CDmUxeIDIf1mt8c8YBZ47N9M0Pdt4tyMw+LXA5Wygx+E28SCc8SiiDZgT8NOz2qsPm3
	 jEtntn5BW8J5EIRtv8MvUNVYVESGUmu5vMI6vLkJ/qicMtsIQ/I1NQ7HOURnwIsGKPa/p
	 6pu84l38VY3+sTkWOKScEoj25vWTW84dJE7vz8gB1stE6aVN7rcdpDU/HRLNygPca/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a24KP7CK+A4JxKLPjDbgI3gTAy8YQeV5blJCmdXRxw0=;
	b=XE1YEDb4/hWTHoLvu/3w0/Wy0w5VPUhMS43bsP2UB/5rLe8Rz+FSyAgfNCunoS0oIlY2
	 KtJowbUlZe8LFOpMI134bNAJN/1Ypvg/CTQbZzlXipB1l47o9q7ZXjCHQBJhOOePwqfRl
	 9/eJQxxRxgO4nKPdjNA3OqwEEe9rE/59CUUZjWuhklW2G6lsfe4jhtffVlSnER32ZaFW/
	 wNl36OAW/hxV1K1EknBmvWI+onCWOZSz6s5ZMV+aTytelbL1noV3IQTGJuv87PUIL1fuh
	 ruTYImJDOyzCFSeilRY/JgSKCfvn8YnTz0vAW79pdPgJxWoOnuJZW/AI5/zABTM+hEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkL9Lbxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232A3606C008;
	Sat,  7 Nov 2026 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkL9Lbxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA1C1F0089F;
	Sat,  7 Nov 2026 15:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064626;
	bh=a24KP7CK+A4JxKLPjDbgI3gTAy8YQeV5blJCmdXRxw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkL9LbxoEEQr0J1k+Ef6HdpeQXDugFFkSbHw5uAai4Bc7Sizx87KdspSMqNoyHAD6
	 vvUI3HysqOLSZ9XANhbKDCFuQcl4GseCPQcBSOimLo/H/yU1aLlu531opGWyLxlMCB
	 Qi/+VNTzhepUMpTbGiAOguUJCPyiyGtQ0rko1tmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0635/1257] mailbox: qcom-ipcc: Guard against NULL con_priv in send_data()
Date: Sat,  7 Nov 2026 08:48:51 -0500
Message-ID: <20261107134956.821068487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>

[ Upstream commit 7b3cc361b5942ac600f38e5dff7aed009be34964 ]

qcom_ipcc_mbox_shutdown() clears chan->con_priv with no locking.
qcom_ipcc_mbox_send_data() dereferences the same field without
checking for NULL first, so a send racing a concurrent shutdown can
crash:

  mchan = chan->con_priv;
  ...
  hwirq = qcom_ipcc_get_hwirq(mchan->client_id, mchan->signal_id);

Add the same NULL guard mbox_send_message() already uses for
chan->cl, and bail out before dereferencing a cleared con_priv.

To close the remaining race where send_data() reads con_priv a moment
before a concurrent shutdown clears it, acquire the spinlock in
qcom_ipcc_mbox_shutdown() using the modern guard(spinlock_irqsave)
primitive before setting con_priv to NULL.

Fixes: d6fbfdbc1274 ("mailbox: qcom-ipcc: Fix IPCC mbox channel exhaustion")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-ipcc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
index 185b63f724d4f..387aa72aeedf1 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -10,6 +10,7 @@
 #include <linux/mailbox_controller.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/spinlock.h>
 
 #include <dt-bindings/mailbox/qcom-ipcc.h>
 
@@ -151,6 +152,9 @@ static int qcom_ipcc_mbox_send_data(struct mbox_chan *chan, void *data)
 	struct qcom_ipcc_chan_info *mchan = chan->con_priv;
 	u32 hwirq;
 
+	if (!mchan)
+		return -EINVAL;
+
 	hwirq = qcom_ipcc_get_hwirq(mchan->client_id, mchan->signal_id);
 	writel(hwirq, ipcc->base + IPCC_REG_SEND_ID);
 
@@ -159,6 +163,8 @@ static int qcom_ipcc_mbox_send_data(struct mbox_chan *chan, void *data)
 
 static void qcom_ipcc_mbox_shutdown(struct mbox_chan *chan)
 {
+	guard(spinlock_irqsave)(&chan->lock);
+
 	chan->con_priv = NULL;
 }
 
-- 
2.53.0



