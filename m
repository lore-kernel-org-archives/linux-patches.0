Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93CD14D2B3;
	Mon, 16 Sep 2024 12:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488521; cv=none; b=K0UMBZlpIP7gKVZxn7dlyH8cS7kRnBZOlI8xZfEZVdSVt4hZCrIkUx4ly2JPcpzaRTf2XaWAFsvcQrCg7MpHkapYb3WDw6wrADKNaD9xM3nrEt7TXZ8A1CfhzPY3DdEmz+gVarD+AtN0zzLXEycL7KqT/CafhnkkGETORMF1asA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488521; c=relaxed/simple;
	bh=26ZtwUFZ33rN8QVlJvoCr6L1gPNFAreIlmgS9WNpyH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CWjRM7g62jQuTOVx4RuNMVBY2ItXDPmNe4lh49ihBfcqBASIkICWa7l2SdlU9AePRjaB73Zl/VLtyeXlY+OjS6J2kFBPco1R8wPB+IB0q/ZOfZDrMoOi6h/JuLKVyj++mwNsjbvbiYhGuf2A4aga2P5XQeOZ0LbsRo/lOnMNokI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYVu8z0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYVu8z0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17924C4CEC4;
	Mon, 16 Sep 2024 12:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488521;
	bh=26ZtwUFZ33rN8QVlJvoCr6L1gPNFAreIlmgS9WNpyH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYVu8z0bcJS+gMLLV6PYkwuuE6J5FbMCZyvibmqAzTNTrCuUS5f6YNkNW9R8Cz+Rm
	 kRPYQSION/GGj/DQL+7uH7VOdjSJImihm18MwAmbWOtGA6zQFA8HxTCKex1BYz5xxg
	 A8AlvXW6kHtWjnIcJAlTfOSNOUtTuICsz/0/EMbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/91] nvmem: u-boot-env: improve coding style
Date: Mon, 16 Sep 2024 13:43:44 +0200
Message-ID: <20240916114224.803151746@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 6bafe07c930676d6430be471310958070816a595 ]

1. Prefer kzalloc() over kcalloc()
   See memory-allocation.rst which says: "to be on the safe side it's
   best to use routines that set memory to zero, like kzalloc()"
2. Drop dev_err() for u_boot_env_add_cells() fail
   It can fail only on -ENOMEM. We don't want to print error then.
3. Add extra "crc32_addr" variable
   It makes code reading header's crc32 easier to understand / review.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20231221173421.13737-5-zajec5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8679e8b4a1eb ("nvmem: u-boot-env: error if NVMEM device is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/u-boot-env.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvmem/u-boot-env.c b/drivers/nvmem/u-boot-env.c
index 111905189341..befbab156cda 100644
--- a/drivers/nvmem/u-boot-env.c
+++ b/drivers/nvmem/u-boot-env.c
@@ -132,6 +132,7 @@ static int u_boot_env_parse(struct u_boot_env *priv)
 	size_t crc32_data_offset;
 	size_t crc32_data_len;
 	size_t crc32_offset;
+	__le32 *crc32_addr;
 	size_t data_offset;
 	size_t data_len;
 	size_t dev_size;
@@ -143,7 +144,7 @@ static int u_boot_env_parse(struct u_boot_env *priv)
 
 	dev_size = nvmem_dev_size(nvmem);
 
-	buf = kcalloc(1, dev_size, GFP_KERNEL);
+	buf = kzalloc(dev_size, GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto err_out;
@@ -175,7 +176,8 @@ static int u_boot_env_parse(struct u_boot_env *priv)
 		data_offset = offsetof(struct u_boot_env_image_broadcom, data);
 		break;
 	}
-	crc32 = le32_to_cpu(*(__le32 *)(buf + crc32_offset));
+	crc32_addr = (__le32 *)(buf + crc32_offset);
+	crc32 = le32_to_cpu(*crc32_addr);
 	crc32_data_len = dev_size - crc32_data_offset;
 	data_len = dev_size - data_offset;
 
@@ -188,8 +190,6 @@ static int u_boot_env_parse(struct u_boot_env *priv)
 
 	buf[dev_size - 1] = '\0';
 	err = u_boot_env_add_cells(priv, buf, data_offset, data_len);
-	if (err)
-		dev_err(dev, "Failed to add cells: %d\n", err);
 
 err_kfree:
 	kfree(buf);
-- 
2.43.0



