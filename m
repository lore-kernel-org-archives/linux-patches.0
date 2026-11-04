Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829395;
	b=JV69vb1dxznEo9i2GwmwiI3IiufvZbfB9fqFgixCyRi/xZezafBN6toXjv6F6pXq26EP
	 oVjoAyvMmpKeElOE1IjYBmwVEFic5SlyQZD2vyhHriDp2RPbbvaCFrrK8RjsDJUBWHBDW
	 IZCKJ+6IrGhy66Bj+ddNzaVwgYOEtjH5IJR4+LBan9KAoAQFMoWg414TE/tKQPBiyuDwU
	 Q01DMYNp8D3Ns+7azOLGowJAIKSRXqsnBVzEKFBMwY0hrX0eJlvGgpbZd5PlFaBc6OvmD
	 O5m4IAmPfv69hXHcazlrx0QHk4Um6deR3IH+UU8hhTNcr5EVkuFaVGJtyCrnBpkkHJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/RrKLN+YNEQtPdmHQjpCVM/saD2ddUS3ZfOpDVAdT/E=;
	b=ysiv7EJZlCzIWOTDd7HkH9tM0jk4JXHD3MTxi/WHMEOJue0FEgBJMzVE8ouTKsqXOTGm
	 pW55uBoELsLh99YkRUb5O7/aSLHL68W4TY2IecO4FF225mBHJjMOicEBDCAz4+1b9loHY
	 MLWjGw9q/PKNAcHt9KVf6C0tWvudjE/NY22rT8riuWJEt005NkcJE5CXHP+9JGwq6DGPU
	 mq+2vMRzZGi8Klds1B4GqdLFOuniKltpIKT7q6Vfqz9GM9vK2fToE0vth7XeQsD8yviv6
	 KvAeU2LB1rCm3HhPLPAwkIN5EYcwfc81apEotGGqQzsW0RRu0h/vy0hHCB4lqmE0Ogg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSuHngzW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E52A606A865;
	Wed,  4 Nov 2026 21:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSuHngzW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52FC1F000C1;
	Wed,  4 Nov 2026 21:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829395;
	bh=/RrKLN+YNEQtPdmHQjpCVM/saD2ddUS3ZfOpDVAdT/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSuHngzWWYTsPRTaiKbT3nSUhDAKNyyjQpvTzKvyw2y8Ic4nqtgf8s/F0x3vfFHHj
	 h+e5p2rBjTblvhj/0D6VhUBrjE39sSLoqsC/IxeSaY94bxsGYNG0o7nBrFRRp/oR/m
	 +6X0SOs8NoLlg56kpklXjKtLpUJFmm6ihCQcbPtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0092/1005] soc: amlogic: meson-clk-measure: remove debugfs tree
Date: Wed,  4 Nov 2026 15:57:05 -0500
Message-ID: <20261104211046.204952208@linuxfoundation.org>
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

[ Upstream commit 67481152be2ec5de3529664c82054b43d6d4b9f5 ]

meson_msr_probe() creates a debugfs tree with entries that reference
devm-managed measurement table entries and the driver's private regmap
state. The driver has no remove callback, so unbinding the device can
leave those debugfs entries behind after the private data is released.

Store the debugfs root and remove the subtree from a new remove callback.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260615091531.21964-1-pengpeng@iscas.ac.cn
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/amlogic/meson-clk-measure.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/soc/amlogic/meson-clk-measure.c b/drivers/soc/amlogic/meson-clk-measure.c
index d862e30a244ed..7ca43bcb622a2 100644
--- a/drivers/soc/amlogic/meson-clk-measure.c
+++ b/drivers/soc/amlogic/meson-clk-measure.c
@@ -7,6 +7,7 @@
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/bitfield.h>
+#include <linux/err.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/regmap.h>
@@ -50,6 +51,7 @@ struct meson_msr_data {
 struct meson_msr {
 	struct regmap *regmap;
 	struct meson_msr_data data;
+	struct dentry *debugfs_root;
 };
 
 #define CLK_MSR_ID(__id, __name) \
@@ -952,6 +954,7 @@ static int meson_msr_probe(struct platform_device *pdev)
 	       sizeof(struct msr_reg_offset));
 
 	root = debugfs_create_dir("meson-clk-msr", NULL);
+	priv->debugfs_root = root;
 	clks = debugfs_create_dir("clks", root);
 
 	debugfs_create_file("measure_summary", 0444, root,
@@ -967,9 +970,19 @@ static int meson_msr_probe(struct platform_device *pdev)
 				    &priv->data.msr_table[i], &clk_msr_fops);
 	}
 
+	platform_set_drvdata(pdev, priv);
+
 	return 0;
 }
 
+static void meson_msr_remove(struct platform_device *pdev)
+{
+	struct meson_msr *priv = platform_get_drvdata(pdev);
+
+	if (!IS_ERR_OR_NULL(priv->debugfs_root))
+		debugfs_remove_recursive(priv->debugfs_root);
+}
+
 static const struct msr_reg_offset msr_reg_offset = {
 	.duty_val = 0x0,
 	.freq_ctrl = 0x4,
@@ -1065,6 +1078,7 @@ MODULE_DEVICE_TABLE(of, meson_msr_match_table);
 
 static struct platform_driver meson_msr_driver = {
 	.probe	= meson_msr_probe,
+	.remove = meson_msr_remove,
 	.driver = {
 		.name		= "meson_msr",
 		.of_match_table	= meson_msr_match_table,
-- 
2.53.0



