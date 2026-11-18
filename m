Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057399;
	b=nnQWoVdLrtQ4mHq4ZaHERJ5AYHgM6O37jEBOMkR6md8k9zndhAGHX6lw9w3AxQ7/Oqv8
	 yFrAonRbLlJlLqCPPky444JMg9X22bFepVWb1QWh8P46xUCqPTYUJmza4u68SOx8CLmlE
	 fcJ3iWL74wD2BojdadTI3zFWk0jANhbV+tZrK67a62g3GJMr6igBWXvqjJKmV3PWOMhS3
	 PfUaStfQahZFYLGk83xEGzK+vQ7X83r93rc1aJVR0WtqrBxdQ5VQlkvJHvtVr6/ilffcB
	 cleZ1ifyQI8U0ib00VHBHH++bVxqyCg95f0g/y2LyBLjnRhrwVoru7Scl+tp9nXYBsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9CyTz9tibrob3DU5m9UjNkJ6xE5S3cWJq27qhIy/SFE=;
	b=MOL6rkX1DnMa8mo5XXVU+U+zmfis/PwUA2Jh4sh4tbX49UIX/0Qbi+LQJApCEDlc1ECw
	 2ygpvvPTRQys+O00pwMzCX7ZHMGLWimaMUPK7s1hHr/KCTFF05EMZP+iGWYBrVPni88wU
	 KWLd+cqv0LYqL1FeF2AQ4XwrJiE5QIiI4+LQbptC4k/LEs4iyHkvxzTN5vvOZO9Zq3rbt
	 0H8TZviTV4NnJ58X2TrHA1PWcs/fOvJ4twoWRRo91M0K9ya3bKAzw7mPZ9z89au2UX6DY
	 ZRyNvAAf0k25txMrLh4kyn4wjWioIyFmroDRxpXeAmlvTTY9NIGlK1zXzT2YCP29RVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CDxx5jll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A9B60A2603;
	Thu, 19 Nov 2026 03:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CDxx5jll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1031F000C4;
	Thu, 19 Nov 2026 03:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057399;
	bh=9CyTz9tibrob3DU5m9UjNkJ6xE5S3cWJq27qhIy/SFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDxx5jll3imGHZkNyBpxHrAd+DBcdv/tGBjQFEp/sN4oq8KS1VSaJfH0oQsX02HMU
	 Eg5q8lCETbAA5hu6Hgx6aOLkHPUzKOo8pgfQbUvkSXcsRfFIVqYmUHM6OZ3vaPyTkW
	 VObGQNZessvgRVD/NN+gsFMFFnzAYrYoJXoMajY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0117/1848] firmware: imx: scu: manage mailbox channels and global handle
Date: Wed, 18 Nov 2026 15:35:55 +0100
Message-ID: <20261118145915.887485506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fa25c082109ac..d724c0973a29b 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -81,6 +81,17 @@ static int imx_sc_linux_errmap[IMX_SC_ERR_LAST] = {
 
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



