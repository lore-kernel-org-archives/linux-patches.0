Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046750;
	b=nZLEbAkEJIdwxHBh5K1OdNHyd8zKAJWzuA1kDUQq9tgmWPWhp5bvhj7YC+oZcLOB/7Hn
	 +ep8CmIZ5bioUyh6kzqHap4z2SaycUyixedHLXSGoWVaEQ/7Ap2kMQWM1mftFYz6oxCSc
	 5vE9/mxcsge9XY4tvOJKYcWcHVL1PIbhnjkY5nP9zcW7aVEKnlSlvbT3+vTwgt/TF7r7g
	 9nnyyoNNp94XyvH14Sw2CKAcMiR25C626km5nIwuwH1YJcRHttJrSnuSD4Sz2WP/9FDYM
	 7qU53g8E481v0ZgUV9s/I7woJ7TK2x7LYKpvIcaOLm9RbdDaGme+VtozsyWQMp7GLcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A11InhuBp2QL2gKbzGheufhXjwuypHip5vNCTD/sfrg=;
	b=1f/3iWCLkulsEyY6dQoD48hrBZElnVIm2W369e0xusL7vIk4i7QhR2m0g40vcgZRhs41
	 p/CnnRM5tZUH09x3G1TbDRYJsOACcn1WyWsukK+0u7Ayv/zXY0oFpU8q7QSe4H+clC19P
	 tvGVU1H9rLKPAYTAFJ2iyWGf+bZJtldx/sSMDBhNKOMOgiamuUAlo4kD2sOavfvN6vAmJ
	 k65mZZzITiQDbRl0ifEOA0K3BqOjecf2BwEazkJdFTUYzMdLpQ0wi2Ud9MW8UcN+W7XzJ
	 STeWZuonzjfdTQY7j17zknXTqX1zZ3mhKfHkwEDDyfp/pioBT/L+kY02f1Zi1JgrlzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ogn/TYSN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DF7606A31C;
	Thu, 19 Nov 2026 00:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ogn/TYSN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2A51F000C6;
	Thu, 19 Nov 2026 00:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046749;
	bh=A11InhuBp2QL2gKbzGheufhXjwuypHip5vNCTD/sfrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ogn/TYSNDUysaB0y3Iy7I/4rt2oy7mvCHelQrRbbhvcdIO1awzg0iSRVyB22zTKCe
	 9CSfCBBww9N87Ylc4GFnzNhs5lOiezCKZcCpcQvEZo3dLbLCmgf4An/dsTJnyNUBeC
	 mcgKUW1q+B+2UcuNF0bzFjYpQk57IX6dqKSoQHrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Martin Belanger <martin.nvme.dev@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1393/2857] nvme: make the DH-HMAC-CHAP secret attributes readable by root only
Date: Wed, 18 Nov 2026 15:40:27 +0100
Message-ID: <20261118150251.512856280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Belanger <martin.nvme.dev@gmail.com>

[ Upstream commit bbca7c312ab25efd0024eb87545c51a76ab2ea39 ]

The dhchap_secret and dhchap_ctrl_secret sysfs attributes have mode
0644. Their show functions return the secret, so any local user can
read the DH-HMAC-CHAP secrets of a connected controller.

Define them with DEVICE_ATTR_ADMIN_RW(), which sets mode 0600. The
macro takes the show and store functions from the attribute name, so
rename them. Writing the attributes was already limited to root and is
not changed.

Fixes: f50fff73d620 ("nvme: implement In-Band authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Assisted-by: LLM
Signed-off-by: Martin Belanger <martin.nvme.dev@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ sashal: Applied the changes to the NVMe core code because the sysfs attributes have not been moved to a separate file. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 26233e6a50da9..9521126738940 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3847,7 +3847,7 @@ static ssize_t dctype_show(struct device *dev,
 static DEVICE_ATTR_RO(dctype);
 
 #ifdef CONFIG_NVME_AUTH
-static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
+static ssize_t dhchap_secret_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -3858,7 +3858,7 @@ static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
 	return sysfs_emit(buf, "%s\n", opts->dhchap_secret);
 }
 
-static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
+static ssize_t dhchap_secret_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -3899,10 +3899,9 @@ static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
 
 	return count;
 }
-static DEVICE_ATTR(dhchap_secret, S_IRUGO | S_IWUSR,
-	nvme_ctrl_dhchap_secret_show, nvme_ctrl_dhchap_secret_store);
+static DEVICE_ATTR_ADMIN_RW(dhchap_secret);
 
-static ssize_t nvme_ctrl_dhchap_ctrl_secret_show(struct device *dev,
+static ssize_t dhchap_ctrl_secret_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -3913,7 +3912,7 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_show(struct device *dev,
 	return sysfs_emit(buf, "%s\n", opts->dhchap_ctrl_secret);
 }
 
-static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
+static ssize_t dhchap_ctrl_secret_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -3954,8 +3953,7 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 
 	return count;
 }
-static DEVICE_ATTR(dhchap_ctrl_secret, S_IRUGO | S_IWUSR,
-	nvme_ctrl_dhchap_ctrl_secret_show, nvme_ctrl_dhchap_ctrl_secret_store);
+static DEVICE_ATTR_ADMIN_RW(dhchap_ctrl_secret);
 #endif
 
 static struct attribute *nvme_dev_attrs[] = {
-- 
2.53.0



