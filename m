Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060661;
	b=c/5fw8mEjWe3PlA4AHUT7J51EWisKfGw0Jgd2VeyB3P787NDgH3YAvpG6Y6Tay9RE1dJ
	 3xKf/YLFV0T6lmTFOcW1hUZLlNn2NxfPMl/IJYxKNMbfPZ7tmfCT9ZEkpqQLw2vxL8t0G
	 SfRWQ6wwyQ4ADfjxqPNSxv1CLz0QltBv3FKqbP+9vWCgL/COsMP3eVGHzWH0P1UW5qFyL
	 +GNOTFBqxfPz4yOAexhg72hTanr5o4asiw9J6MFx/5ygrAr/p+THmqsBZbUUMpbknuIDJ
	 ubaFBj4WteTa5z+5UCUiel5BM/BvjHS1YK+nMjNw8leGJoQfHZO0GNd5r60gj0QjcIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BncqCFP/F5F+pUKHOtVG6q1inqNaUSw4h/0UNf4+Jsg=;
	b=b5bhnVele8Tzd/RpnW6wNcziSLi7Hhrm8f/vL5SRjQhnXJtHYp/4rLeHhka0ZVTd87I9
	 O6vG+p+AJJ4fQ7jWUObTooqEt1nnvbI0ejGEeSm98rBtIu513KlTBznkS4wd77OU2A2uK
	 6QuOjyoEZHUH+YYxcdmXua0kTjKfMMVfnR1n0z+JqSX6LNYj9LwOm3/CiysmHXddNJeeh
	 epjiKvg82RKPS7bO3FVM6Ta13kkRnvKCOTS2A79Gqh5ArxmeYyj58MNnD0QnNp9D89c7F
	 hSfDU37UvIteJqNVuHxqIr/ZqJitXSTOciQF09PLY+9hRukeVNSZ6Bofnum6YMBxPMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F3WSiMne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61598606A326;
	Sat,  7 Nov 2026 14:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F3WSiMne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0638F1F0089F;
	Sat,  7 Nov 2026 14:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060661;
	bh=BncqCFP/F5F+pUKHOtVG6q1inqNaUSw4h/0UNf4+Jsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3WSiMnelKMbd8E7jdFpFP6dpTGctcZDQb0Bk7I99xc8r9P4eLiRGu92GBf6QXZQh
	 Vt3jIY2A8Pb+Uw9MFa5kvcCdDPIN085Wt1vQ9wupmp0+NJ+b9Yf5Y+p5cHRqAhQHUz
	 ngaDz2N9/S2MINaXDgQGoeqrFUEHCn+PZpm7Fm1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0099/1536] nvme: dont reference NS after unlocking in nvme_ns_head_ctrl_ioctl()
Date: Sat,  7 Nov 2026 08:35:15 -0500
Message-ID: <20261107135000.448843301@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 77c57daf98a2ad95ec9ac1371caeff8939cc1f58 ]

In nvme_ns_head_ctrl_ioctl(), once we drop the SRCU read lock we should
not reference the NS to lookup the controller, so use the available
controller pointer directly.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d3564b2eebc9a..22a98e75d8962 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -725,7 +725,7 @@ static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 
 	nvme_get_ctrl(ns->ctrl);
 	srcu_read_unlock(&head->srcu, srcu_idx);
-	ret = nvme_ctrl_ioctl(ns->ctrl, cmd, argp, open_for_write);
+	ret = nvme_ctrl_ioctl(ctrl, cmd, argp, open_for_write);
 
 	nvme_put_ctrl(ctrl);
 	return ret;
-- 
2.53.0



