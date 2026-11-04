Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829404;
	b=UIO9jJ0nBalpZR66QGAUlmNVon5HRpMZwfztwYCz4XMjiv9/9SDX7vZ57xV7a7/GPc2R
	 jdcWuds7cvkgiYPxB3kkuvy/F0+ev3j10h2TfYnBQNS1RP6bZdOXfro3PG3cs0gbVne0E
	 ruL80Z8EWJaImZ1YpNFF2p2XoNy7Huo+/E5MeIkOTxyq/PnbYyoADJRs48g78So60W+ND
	 +l1kW9m4kuCgcKlOJ8k1w+4eS6g7Ss4t+wb33vYkqumB3VdV7lW/vW491+9PJLPMclqOW
	 41SSlj3IrOEtwzkXQJracByr6OK9vjqzSUYspLAdNIz4PiAGhPWqivQs9utshiTWplw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wz6oxcMsI0gz7GeJmn1pu3VgQunqAvybblXvbQuTtko=;
	b=DbP901D7xuWYmoc0YNgluGfOiHGMADBRa/WZAbhKdwBRBfsp7zdUWXkxrSf9904Vxu25
	 +aEPBRv5ZaikT61VeL2YcQtg/IeMaHEJ5Frs9ibv63uAsBR4mHMaxl+jJmwhSDMNi9AsX
	 2chz9hEe2rJdQyV5Jfrvw3LVwnc7Ezwr6r2cFI7RIjZJu+e8jGZL5IDsVQCd1B64T3Cm2
	 yG3uEfcIAXM3LUrWSirkXS0kdwoXdGO87i9hEeKT4PmOcXuplSzSpIG8dd65/7wxpX+fL
	 5m4nb7gpe852S/dTrmPfdJ4j1bIK8/31Bk3XpN4ZihTcUyFI63ilUcbUbyP8x+zXvtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NqOVGsFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DF56086E4A;
	Wed,  4 Nov 2026 21:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NqOVGsFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E232D1F000C1;
	Wed,  4 Nov 2026 21:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829404;
	bh=wz6oxcMsI0gz7GeJmn1pu3VgQunqAvybblXvbQuTtko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqOVGsFlqMfLUcL+jzy7c/WYMI6wRP53u/vqa8FDba5wrFo+htl2EVUc0VbOMgSDn
	 1R+o1hv0G34S63LYv0LdzhpKqh+TKAPc7bSG9IoGmSZknAcyv+0kh1Z/7cZSgxC9tr
	 YjO+0QtvIOf82amESwUeVjuJ5PxxGH86RxHnVJqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0106/1005] nvme: handle positive error codes in nuse_show()
Date: Wed,  4 Nov 2026 15:57:19 -0500
Message-ID: <20261104211046.621393352@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit dd516cd7624648c71d338d99368587f10ecc9f0b ]

Function __nvme_submit_sync_cmd() returns a positive error code for NVMe
errors. Otherwise, we get 0 for success or a negative error code for a
kernel error.

In nuse_show() -> ns_{head}_update_nuse() -> nvme_identify_ns() ->
nvme_submit_sync_cmd() -> __nvme_submit_sync_cmd(), we then may get a
positive error code returned.

Function nuse_show() - being a device attr handler - should return the
number of bytes written to the buffer or a negative error code.

Convert any positive NVMe error code to -EIO.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 16c6fea4b2db6..12478e0297356 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -239,8 +239,10 @@ static ssize_t nuse_show(struct device *dev, struct device_attribute *attr,
 		ret = ns_head_update_nuse(head);
 	else
 		ret = ns_update_nuse(disk->private_data);
-	if (ret)
+	if (ret < 0)
 		return ret;
+	else if (ret > 0)
+		return -EIO;
 
 	return sysfs_emit(buf, "%llu\n", head->nuse);
 }
-- 
2.53.0



