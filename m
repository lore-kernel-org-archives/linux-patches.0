Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062365;
	b=mlwhHvr2TeBZLj38qI4criG392aUMcpyQP/+l/Tb5S2Opl+uHlCRFOUZoD1fjvZCj4s7
	 zYnP14uNoPYxs96Ft4/1nQTGA581qSyHyD8oZYirWdzSemAiuEjmvaF2Ahn5mQGsPeNGL
	 lXgFJkgtur7/FHBob0vU8aSjtjtDPwj4DSEQZV6IZzmb+vlJBkSW+ytatef8j8OL/fO2b
	 j5o82Zsu9f+lRud41veA3VSFMSdAXEUriwf9zYckRB7M4plxRX56xfBkOfpiBdKlLvkbE
	 FoMWOX6e47cFLtK27cRYhLVRDmOsE7YGmeCU7WOe3cAIchpoogvrbExHRiisiJgxB7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CUy/vI25YkJ0BOITwaMMB0uwGftOqXAHLUOSsYuoNjQ=;
	b=WzkWHxAmwobryIwIkXGcTmMdjxZcVKtTw1wGnV5bsgHZimrnnPO5RGWIufR+Ho9DxK/9
	 D+1kZatIdKr+r4HixvAg4rNCb1ccy3OYpzI+E3MFT4D0vphnn/WpOU+bkeues9qExABvA
	 kMmlMfpoayqXo9/6e7fSJ8wc6DTo+NmaBeMvLZ+UgHeX5HyDgnJTQNj1tYaO7ftSTHN7O
	 UiD7+kasIX2XhFJpdkyvY6liDSfYsWxEHdKsChhn7p2/Qf+IiqzJ/dMUGwBGm1RurNhl1
	 mtP5g8vmFA3d07ozFBIQPQUnEIB2PA+Hl1sQj0aofROvx1S58AfCthfkEVoj/uynRxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeYxoASZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDE9606A32C;
	Sat,  7 Nov 2026 14:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeYxoASZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9BE1F0089F;
	Sat,  7 Nov 2026 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062365;
	bh=CUy/vI25YkJ0BOITwaMMB0uwGftOqXAHLUOSsYuoNjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeYxoASZR5axJqIafqczQFra54gllUneV2IRzb4CrmL28G+I7js0TvZAEqIlKv3n2
	 anAol9qpKSmjwe1PLuFcySC4ORoIPJW2NuDQO8ZkpuAEZyeMxOGo+DL03g9noeN3c+
	 c+XkY919nF0iFvtd+ncUeA/iA2qITyeAWkXwnEA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Martin Belanger <martin.nvme.dev@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1291/1536] nvme: make the DH-HMAC-CHAP secret attributes readable by root only
Date: Sat,  7 Nov 2026 08:55:07 -0500
Message-ID: <20261107135034.049327848@linuxfoundation.org>
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
index 74f0b9ece0442..9508d582804e5 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -549,7 +549,7 @@ static ssize_t dctype_show(struct device *dev,
 static DEVICE_ATTR_RO(dctype);
 
 #ifdef CONFIG_NVME_HOST_AUTH
-static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
+static ssize_t dhchap_secret_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -560,7 +560,7 @@ static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
 	return sysfs_emit(buf, "%s\n", opts->dhchap_secret);
 }
 
-static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
+static ssize_t dhchap_secret_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -604,10 +604,9 @@ static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
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
@@ -618,7 +617,7 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_show(struct device *dev,
 	return sysfs_emit(buf, "%s\n", opts->dhchap_ctrl_secret);
 }
 
-static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
+static ssize_t dhchap_ctrl_secret_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -662,8 +661,7 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(dhchap_ctrl_secret, S_IRUGO | S_IWUSR,
-	nvme_ctrl_dhchap_ctrl_secret_show, nvme_ctrl_dhchap_ctrl_secret_store);
+static DEVICE_ATTR_ADMIN_RW(dhchap_ctrl_secret);
 #endif
 
 static struct attribute *nvme_dev_attrs[] = {
-- 
2.53.0



