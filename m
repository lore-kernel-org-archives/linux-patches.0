Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020631;
	b=hONNkhSdk71PMrGkMGE09k5gt/y01TV1X2C+2Wt+miKgVivEtAgHIPGWafpsjaXuyPxp
	 zoOjZp8JXA7nsK607eYjO7UQA2jiGlzNRNVE+bKTmyfQ6cWydwLGQ8FSh9zFDMuNjUivE
	 mmVH2UUcF/+Z6tDfRtUQ9ZnioT7pKC96BFOIiIS1xwfw9/J+wKkCL8XP2EFhDfG5tYoNH
	 bI/RsrmWyZ3Inh2dH0rpGlwHLFgidgJfDuq9gX6q18MG5lsGdPGy6JQNw9N9cN84LNJs7
	 PcVk/2UK/1+1zXbfOWi2YWGQTO+/0wzSrhba5syO6FZ0yZ0k3Ta6Cezha8sZP363Cwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RYnK4BOHOUjBLPgHxr3ZmA4gIQCaDhVn2CRbohNBjFI=;
	b=ouFgrHSIqz8E73mWDib/8NVt2FbGmRycSLx3fB+45V86eX+Gm6w8bqarHkUwfhDTqsJR
	 uoFYD/34TxvLv2bi3OsQ+QecG5Tqeu5iqA3K1TJ+Y9ZOI7EM/7QWgHryCpyImQcPzm2E6
	 SRpSC6zXRYMpDOyiT8uC3MY84ToUW+RrPoqmNFJf4edv+XOR4Ww8ojoUPEYT8c10JjCDQ
	 PMoXyKfMNOcpnOMZJCzvNZZqF0KpQxyK44sTtCPsbdIF1DHE7zqIIF5xWl7TH6KECNbpG
	 6MEvVmqQ+hbBtdu0eX0dIt9/+u02uCtQQYDJjKlsPhyTy/9TEt8vrCjNwJMiFf6hp+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4Pg6pSC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B17606A338;
	Wed, 18 Nov 2026 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4Pg6pSC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8251F000C7;
	Wed, 18 Nov 2026 16:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020631;
	bh=RYnK4BOHOUjBLPgHxr3ZmA4gIQCaDhVn2CRbohNBjFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4Pg6pSC0Qpes2PONglUbowAbr9fV7RNzAAUNjFQR3+7Ng1Om79xp+Sl06FAcT5dL
	 qnQWnB8BT68UTAUMxbCk3cceu9ot+pzXXUCxu/+bEyHK6t9LbgbkWX5+mLX1AMEYog
	 Horx5vIBbZcpjH9IWq42TRJZWIekpIbWasbNZK1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jianyun Gao <jianyungao89@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2021/2651] dax/bus: Return errors for invalid mapping targets
Date: Wed, 18 Nov 2026 15:54:21 +0100
Message-ID: <20261118150358.969966753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit df6cc0a24717c38ac81b5ba1e839c35e74e667dc ]

After the DAX configuration locking was converted to rwsems, successful
lock acquisition leaves rc set to zero in mapping_store(). Two error
paths can return this stale value: an unbound region driver and a
misaligned range size. The sysfs write therefore reports success without
allocating the requested range.

Return -ENXIO when the region driver is not bound and -EINVAL when the
range size is misaligned.

Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260924025035.1265035-2-songmuchun@bytedance.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/bus.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index b809e1a264afa..e40c25401cf06 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 		return rc;
 	if (!dax_region->dev->driver) {
 		up_write(&dax_region_rwsem);
-		return rc;
+		return -ENXIO;
 	}
 	rc = down_write_killable(&dax_dev_rwsem);
 	if (rc) {
@@ -1201,8 +1201,12 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	to_alloc = range_len(&r);
-	if (alloc_is_aligned(dev_dax, to_alloc))
+	if (!alloc_is_aligned(dev_dax, to_alloc)) {
+		dev_dbg(dev, "%s: size: %zu misaligned\n", __func__, to_alloc);
+		rc = -EINVAL;
+	} else {
 		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+	}
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
-- 
2.53.0



