Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063381;
	b=3+J5AfH5KQnP+2WAtUDflGv57n8ZP+X5Zeu1c73yXiOmc29/nCtPWjgTAaeINW2tsf86
	 lwajXRH2kxYz3XZXizliyiXbb/HzXGzu9dFf41HdNULkVlzGq1M4RA7OhUQXrOyxDeJ0y
	 vTfIzHWpeQVeZphajuzt8tMbIln3KXAzDG4aYiGcskKr4OD2TGdOojOLzhNUnmGPOq87t
	 6ZZBF7QpXUd0nv5tsJ1ha/sRvWOk2fO+lAqt8ucfobQ2uHzsw+tvk1PhvAEN5zfvFCGas
	 sqVypyuqJen64a4+zsJK0m835D8lcpTRQfgQXQtwclrvyhNLuckeKHIchfnnlW860eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CHpPG5RUh7VtCncuUlhDcvhypdYlqamP2WD/dLK4p94=;
	b=uBuofPGkMJ2f/7fZtjU7YFg82CMLXX0F6o3iusW/RjP7EllZjOVn7fxDiy/JCKI4KZSR
	 QxeAlj6njPrWwhqIugJKNCtOxMRsW/iwi/UVv4EMJ9l6zMGidOlfyzD5VF4LykzdIf/95
	 igllejE+wV6oo7SYP0dr5V5bDaObZz9zXG+RgW2gK6c+YISVtJ9iUspn/mWAUZU9LK3EB
	 TJLxFhwfhWFxaqo4ly58iGAJ9VkR1vvY2dyxK+ck3nqr0Qw07dOi659qip9yqKYcwFpaf
	 ZS/7K5gm9zoooJqmuCLYPyIqSRUyrA6tIo6emw9xVXqqv6LtDY7NkVmpVvY5MN5NFKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YkaDCFEg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AF0606D81C;
	Sat,  7 Nov 2026 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YkaDCFEg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B871F0089F;
	Sat,  7 Nov 2026 14:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063380;
	bh=CHpPG5RUh7VtCncuUlhDcvhypdYlqamP2WD/dLK4p94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkaDCFEgCqk9ZHb6Leta8TI9eLSdofIGzIjDh7nO+AEVeCmqLboFyG+S6Q9orz/6c
	 L0NJZRBCtaj/3zlEp0o31YPq9LlxKm+x2iscK55JaTL7Gh/Foky+tGSTxUkw1UdDZB
	 457tkkI3KoaEcCJJl/iq18IxGgPoAVX/OU4Z/jIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Martin Belanger <martin.nvme.dev@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 554/869] nvme: make the DH-HMAC-CHAP secret attributes readable by root only
Date: Sat,  7 Nov 2026 08:53:56 -0500
Message-ID: <20261107134912.131936708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/sysfs.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 12478e0297356..2b6085359a950 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -626,7 +626,7 @@ static ssize_t quirks_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR_RO(quirks);
 
 #ifdef CONFIG_NVME_HOST_AUTH
-static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
+static ssize_t dhchap_secret_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -637,7 +637,7 @@ static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
 	return sysfs_emit(buf, "%s\n", opts->dhchap_secret);
 }
 
-static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
+static ssize_t dhchap_secret_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -681,10 +681,9 @@ static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
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
@@ -695,7 +694,7 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_show(struct device *dev,
 	return sysfs_emit(buf, "%s\n", opts->dhchap_ctrl_secret);
 }
 
-static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
+static ssize_t dhchap_ctrl_secret_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -739,8 +738,7 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(dhchap_ctrl_secret, S_IRUGO | S_IWUSR,
-	nvme_ctrl_dhchap_ctrl_secret_show, nvme_ctrl_dhchap_ctrl_secret_store);
+static DEVICE_ATTR_ADMIN_RW(dhchap_ctrl_secret);
 #endif
 
 static struct attribute *nvme_dev_attrs[] = {
-- 
2.53.0



