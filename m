Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829636;
	b=0YVv5aVUPoDhL3HMr8nlf9gExvt+GW95Oknp/oYfJEt3KpPfUsPqxkNPmLwdpc6am8bz
	 YVAWC+cMGYsvVXDPA3frcAH25OLV8UI6zvZ8uCFkGLkQZk4m2OHZz4guJQiAKpw2+qpb3
	 kUGnx9VynGmMCcLeyqPwRI6pC2zOz1yq4qie/4kuA6CgyCfQyCwUzSR/2S/0nCHuu3aD1
	 zAK69MKRfAlu2tz7aFMshADtRk2Dtblvtl1rskZW0cYbQ+MjJgpaXmIw/26h2S1TP6niD
	 woq0qD+SSzrqr5FyST6Rise8hp+roWXhI+hGXeEg0oOZ7hueB90Z6/XrvQ4N6FO3dQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEKEr0ios2YEcfejPVNDmaaMs3XAQIfr8ARvQDY2N44=;
	b=pIIULyG/wscNSzNEbsedMh27qYl6QzzA5l7f0K2S1NFEopBSXBZDmUN+bKD4mpss/bPD
	 Q1SXNZtgrmdrzTZCNdBJMX/yEggEWAgStHQN98apolhQzpJvqoruOH2JYlVtv7k04kV7R
	 oXxvfqatXsYlX/3Mim4mJLo5WHnDSPT39R1mrdL/noDAqkrS472PhWJ9QNHTb1azOzzcj
	 ST76w0z4TMtZ6ntxOOMWfyWDymwwTXFPRFzLKK2eVJCbMZl4I+j8M2SvOsPipEt9SwYEF
	 xCg8+Z6IoZvr9pTk1e+e+lZSq8+ldoZxJ8RISN+yQqNgoE5A+QTDcnWKcrg/pgEZQZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrzTbDA3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D66606AC1E;
	Wed,  4 Nov 2026 22:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrzTbDA3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852A81F000C1;
	Wed,  4 Nov 2026 22:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829635;
	bh=qEKEr0ios2YEcfejPVNDmaaMs3XAQIfr8ARvQDY2N44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrzTbDA3jrYZ5KhS3Nnya/PYXxUh9gAApNQjKYW12BwbJ/6jAhPa6VTGnwDKF3gWj
	 c+o4evjP4gb+sDDeb8q+kyokDy4Phn0oOY3yp5I96PV8RESPVgcCNDp6I5ott8kLcs
	 Kft5AFec3shV/f/IbAP35U4jg9Qf5EfBzUmnPTLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0247/1005] firmware: imx: scu: manage mailbox channels and global handle
Date: Wed,  4 Nov 2026 15:59:40 -0500
Message-ID: <20261104211050.779312192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 55c748d596f841a18cf659ce0999f64029a5c88c ]

imx_scu_probe() requests mailbox channels with the non-managed
mbox_request_channel_byname() helper and then publishes sc_ipc through
the global imx_sc_ipc_handle.  Later probe failures, including child
population failure, can leave the channels and global handle live after
the probe has failed.

Register devres actions to free each mailbox channel and clear the global
handle.  Also depopulate partially created child devices when
devm_of_platform_populate() reports an error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index 8c28e25ddc8a6..28d745ae06067 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -82,6 +82,17 @@ static int imx_sc_linux_errmap[IMX_SC_ERR_LAST] = {
 
 static struct imx_sc_ipc *imx_sc_ipc_handle;
 
+static void imx_scu_free_mbox_chan(void *data)
+{
+	mbox_free_channel(data);
+}
+
+static void imx_scu_clear_handle(void *data)
+{
+	if (imx_sc_ipc_handle == data)
+		imx_sc_ipc_handle = NULL;
+}
+
 static inline int imx_sc_to_linux_errno(int errno)
 {
 	if (errno >= IMX_SC_ERR_NONE && errno < IMX_SC_ERR_LAST)
@@ -321,6 +332,11 @@ static int imx_scu_probe(struct platform_device *pdev)
 		dev_dbg(dev, "request mbox chan %s\n", chan_name);
 		/* chan_name is not used anymore by framework */
 		kfree(chan_name);
+
+		ret = devm_add_action_or_reset(dev, imx_scu_free_mbox_chan,
+					       sc_chan->ch);
+		if (ret)
+			return ret;
 	}
 
 	sc_ipc->dev = dev;
@@ -328,6 +344,9 @@ static int imx_scu_probe(struct platform_device *pdev)
 	init_completion(&sc_ipc->done);
 
 	imx_sc_ipc_handle = sc_ipc;
+	ret = devm_add_action_or_reset(dev, imx_scu_clear_handle, sc_ipc);
+	if (ret)
+		return ret;
 
 	ret = imx_scu_soc_init(dev);
 	if (ret)
@@ -340,7 +359,11 @@ static int imx_scu_probe(struct platform_device *pdev)
 
 	dev_info(dev, "NXP i.MX SCU Initialized\n");
 
-	return devm_of_platform_populate(dev);
+	ret = devm_of_platform_populate(dev);
+	if (ret)
+		of_platform_depopulate(dev);
+
+	return ret;
 }
 
 static const struct of_device_id imx_scu_match[] = {
-- 
2.53.0



