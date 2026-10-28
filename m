Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212612;
	b=ed+At9WHR7hj9MxlYZP9/zvj0yd/ZShnomL+8PvLRhdgUxTrsvc7sEBSqCT0etgrPhJh
	 ADl1dSvBOD4hIjuD5W90CpMkGnyH0kjPC5Lah0jizIVhiDNwXr/WLfZq76tL4KilyO35i
	 N9RHAmYB9a0X0wZKhYif/A0vaNUu/wB5hhutH7lHBrhpfjrsLFDHdLUs5tXRbAqawgOGS
	 FVlaortQP2QTPIfCxRLga1+ut89sPPAJIF2JJAbv1NYcDC7PkZgOyNFHtVZTQrWcjLVbe
	 9T8HWqpRJt6vtyzWyFh/1pHlzQPsi0kaNs0yLGCQAneAl2fuj59pJFeoyYtVOVnt0rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xak1kMo672RS13UFjnsVT8coHFNJn+FkyHrUKn0NWU4=;
	b=ZVyBTZp6lsJB+74/BuirBc35ev3drPoajKOAJNfNSMbXlmCaGjMTUmNr4Myro52MRXrK
	 PbvkPCTVh1Zy9ugkBNb4xLHcvZl+V2/wRhL7C6KzMSlWaYMoypq3itCLBwyLzAejVe4YA
	 C2kl0Te0eRb5k47P/SYzIAzlA/GTxurMdP9m9CwlLsBxMcCBNyyir8UNhpDJbg/wGfoth
	 F995tdcykzMcWNjsINlQPaCwSUYTmAkAX+ffetuWiBJr2iUqJyTGYeEnG9ixfxIDgU0xm
	 wOG9Qb5FWqL70AmfK0fQI48hjeJ1Jj+7eZoDOIBMo1RJb1pNRyeEM1BeMWwjduPOWmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kIlg/k7C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57483606A31D;
	Wed, 28 Oct 2026 18:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kIlg/k7C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A801F1F01825;
	Wed, 28 Oct 2026 18:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212612;
	bh=xak1kMo672RS13UFjnsVT8coHFNJn+FkyHrUKn0NWU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIlg/k7CqPRGPqSkVC9JvV6ld5BhgkUvkjGcW6NkY9ghPjR+HTtkzi8hBPu1nYA8R
	 LV7/+7/ucgMXpejFZu6LYn4L+67kKta55oBq6HUshKUOqdDhVEoGNg60QqORT7SxVc
	 ynX5BrRpRKg4/VlF0Too0kcru9A6d92BIPxwq8GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0216/1887] nvmet: preserve device path on allocation failure
Date: Wed, 28 Oct 2026 17:38:32 +0100
Message-ID: <20261028170504.147913670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 2f271b812170d4cad578bae1f91db72f3c2e36e7 ]

nvmet_ns_device_path_store() frees the old path before allocating its
replacement, losing the existing configuration if allocation fails.
Allocate the new path before freeing the old one.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 2e87718aa194d..88e6adc54dcbc 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -345,6 +345,7 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	struct nvmet_subsys *subsys = ns->subsys;
 	size_t len;
 	int ret;
+	char *new_path = NULL;
 
 	mutex_lock(&subsys->lock);
 	ret = -EBUSY;
@@ -356,12 +357,14 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	if (!len)
 		goto out_unlock;
 
-	kfree(ns->device_path);
 	ret = -ENOMEM;
-	ns->device_path = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!ns->device_path)
+	new_path = kmemdup_nul(page, len, GFP_KERNEL);
+	if (!new_path)
 		goto out_unlock;
 
+	kfree(ns->device_path);
+	ns->device_path = new_path;
+
 	mutex_unlock(&subsys->lock);
 	return count;
 
-- 
2.53.0



