Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060863;
	b=fZbgdPfQynkNGbZ4bvUniPBLbjgUCPvtbbSKblRL+FravlQBJno07q/C0SSvzDyy460q
	 tlheFnw/sXVZxLUmtkwS9WzVHCIDEd4lbtPBC3FBclBnIzw194aLYV119iWnuEMNBH+c6
	 3/DkMBlayfsvCyWzbFkjzZi+QWPohq/j0jwn34R8bYGcFy/Tt6EoEBk4RXcTGY8OQVVDb
	 tNapO5vFJyOqLyTsVHOUXX54K5VACy/5BkENPkJ/OhjLz6GewgP1UqsFOZVYN25W/11gR
	 GCVe8ZfW/J1a/AHOnB9q9aL7lts9FWuJC8g/alpRNUQkhN0J5U624IunJDRGbDeiwRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n9/qCxza3/E/98lSP/OQLhtLvBV9EDNIPvEo8Xr1Vtc=;
	b=bHZPVE41xFnrBnEI13Iy4zLM4fzGquhNDjQuFzpr/9r8hb3dmtxs9ZTZnEY/0Iit9ev5
	 laHXtqCGNvvm0/zP+vCT/iS2vmmyF0bJVFp4Tjsio4yQrdzlL1gvhU8Fci7StOH69JU1C
	 fXmRgFS/vpYZzRUfNL9HN63juRdqM4dWCCJIbe2uTdfSTFB6eNfemnyX0pbN3o7yQbm66
	 8hpqDOfmZBRdEFRrY+LaWAYgtOid0QNIx/pDBeW0PgmZSCir2yA8GFOJFuBofQW4xoB4q
	 //PNcNPN1BjcPo9tqlNe+FWRXQoUzZ1XbEwji+cuTNdj3j4BxJes0lEHc/89AxzqPWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5QvIaKW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4CB606A338;
	Sat,  7 Nov 2026 14:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5QvIaKW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95EC1F0089F;
	Sat,  7 Nov 2026 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060863;
	bh=n9/qCxza3/E/98lSP/OQLhtLvBV9EDNIPvEo8Xr1Vtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5QvIaKWiOCW+DoyeqeUCr+8+RSFW0EbE/vzSXfbUsVjjBImXLAEFF12RiYJN6i7E
	 MwDCYVKecpupHQ1ATwLGM311UD+t4OAORvPZBviXXsXV9R4VTTU49VP/Pw/gQM13mz
	 Z+P06Tr/MVb5/o77jXAJ/4cD/dgp4QzEYMTaLweU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0209/1536] firmware: imx: scu: manage mailbox channels and global handle
Date: Sat,  7 Nov 2026 08:37:05 -0500
Message-ID: <20261107135003.529298543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



