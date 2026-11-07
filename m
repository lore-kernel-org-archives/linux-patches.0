Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064827;
	b=ne4ZS93Xecj4gau85CYly9Um2zUTcAkwCUy44Kia+wnGbLiDi+JniqulkLNNrNJ+/6ct
	 I3ABtdbqD//iZAf/aWJVsI0DJZQRG4i2mpzqFDtCKZ+05fw47yZRYLisF/2KUkcQkvvXN
	 DgRgCiR0uN7TDA5Wy513NBggVvPPtCdw1daBjZRy8ZHP2aJrCHJPoJuNvB0itYzCJgo1I
	 6l/g8txIPN69+2mbz5lwRzz130BUvGJ9YMw/Ax1pUHMS1l133U3dqlSesphjigsStUH6V
	 0PZB3SQFNBEcC3XGi2HWvsVH3Vs5X8SlvsE7zYry4fRxFiMa1vJa7hN8qTYgD+gfdzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oALdByeLbwiSdJvJ8GzGQAQvva6jaq69GXZKf9gFc0k=;
	b=ZKLfJFuLmMZF9utw9p9TQ64rHcs436QiQdjwimzJsiucSZmA1JOTYxSTIiyORFEBgUN3
	 0yofoT/xF9KLd4hya1BA0329yXPdpvJlYgahl8Jso5vYvFumlPbU390q2fmaqJTDsVhnm
	 povpP1IBG5BZDiC+hFnsM9BAHR+wWnhwWlOuWAoESDq/GP7loYsd+iM52DP641Sh8QxqF
	 ikxRrJiIE/pg8ZOu9zjeS6KPQ48ND/LSIJcQbBBjleUDAbnhV6AiD/nXwZhmSIX3zhHGB
	 MLBkNObUlXqxRByY0otPp9rlehnHIDF4O3QQW28/fw+Jhe7cCF176D05ARUw9SJXu4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5fkeAjx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4CC606A9CF;
	Sat,  7 Nov 2026 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5fkeAjx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA941F008A1;
	Sat,  7 Nov 2026 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064827;
	bh=oALdByeLbwiSdJvJ8GzGQAQvva6jaq69GXZKf9gFc0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5fkeAjxeU0nn8IYO/46VlP1TlrVQFriSW9BGpGb6mtyzouzeAhhkCrNPtquYQk+W
	 RMlMWuveyUr+3LDWUb7XNfFeYZySe3lJdPPfr3TXCl1Lt572ndV0mS2MmNLhR+twFm
	 MxBO4c+Pa5ky4iCNKE+NjkMG2vVq5lmMZ1q4KFrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Martin Belanger <martin.nvme.dev@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0760/1257] nvme: make the DH-HMAC-CHAP secret attributes readable by root only
Date: Sat,  7 Nov 2026 08:50:56 -0500
Message-ID: <20261107135000.276942527@linuxfoundation.org>
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
index e1e3dcfd084be..c0ecb5df1a30b 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -809,7 +809,7 @@ static DEVICE_ATTR(io_timeout, S_IRUGO | S_IWUSR,
 	nvme_io_timeout_show, nvme_io_timeout_store);
 
 #ifdef CONFIG_NVME_HOST_AUTH
-static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
+static ssize_t dhchap_secret_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -820,7 +820,7 @@ static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
 	return sysfs_emit(buf, "%s\n", opts->dhchap_secret);
 }
 
-static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
+static ssize_t dhchap_secret_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -864,10 +864,9 @@ static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
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
@@ -878,7 +877,7 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_show(struct device *dev,
 	return sysfs_emit(buf, "%s\n", opts->dhchap_ctrl_secret);
 }
 
-static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
+static ssize_t dhchap_ctrl_secret_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
@@ -922,8 +921,7 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(dhchap_ctrl_secret, S_IRUGO | S_IWUSR,
-	nvme_ctrl_dhchap_ctrl_secret_show, nvme_ctrl_dhchap_ctrl_secret_store);
+static DEVICE_ATTR_ADMIN_RW(dhchap_ctrl_secret);
 #endif
 
 static struct attribute *nvme_dev_attrs[] = {
-- 
2.53.0



