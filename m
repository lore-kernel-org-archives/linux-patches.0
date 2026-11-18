Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060078;
	b=Sw2s0TKXmsCMAbZrijMBRPMS5hTQWebWtm2GTQppECKwGSkr+3bX0J53wT9aCQEPfb1/
	 BZDjSfFgK6ddiF+tYMBhG0GaGeQFNoSgtWO6Imwxl3DBnARcUaC4PcyY4zSj678EZPkql
	 nIki1E2RzzcCyLIUcoxl4IVY4i7QNkuPB9vCCGl9aSEkWb9U+1Iw5Ut1oTsWYLD28DHRf
	 nUaVQTz+tuxsUGpD6vPDIsemlnE4ZtQWTd6Dwj7uv7mZ1fpubTiBQP4UHWGoCqU4JCNx1
	 fDa1kpzzU9QF9AUMQSzIh6L6mvKgAdBhE24PwOIUbe/RmB/O48MccUlXoQS8sbC83fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M/Scxk33/NeP275vkminBNgfZ02z8BDi3lDedJplBik=;
	b=iu+1lCy+hidqpsR5bujyeMSZet+DVpv+oN5d9RHLplkpC5f6C0suvANts6BJBj2ggDYl
	 uj64bwBT4N6fXR+ChhHHsnyVNs2FUE6oUHbFxeD3CWp6oyVTlAyTSN/7jVNOyCGbUPvTH
	 /PGnKgEZO1u7OL0lqtjwDRVTXBap9SmCGBpGH5FF811SnIWDaYmc7Nsh++tTBhhElyZwa
	 Fo1sUBaJkYqKVDZYqypeCtDYlYCsoL0GKBp5m9FuOWzA26T/3oK6rAvAlYnqL2BELsbmI
	 0RQ0Vu9ekiP4Og/J5j2rPMEPd0m1YYYIAq11n/kUWfQ2hWxLtsCRcU4ANAYF2vgmUJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TLCV15eA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F2B606A320;
	Thu, 19 Nov 2026 03:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TLCV15eA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FE11F000C4;
	Thu, 19 Nov 2026 03:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060077;
	bh=M/Scxk33/NeP275vkminBNgfZ02z8BDi3lDedJplBik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLCV15eA4rp/U3Bo0yKPUURWx50iYdjiG73pkD+9xYmdtpo33Y1+6+j/zPaZAqcga
	 Cmp0SogF3B8cF34guBP95o8l/dLVpLuSTnWl3YiZ5ny/WtC9JT0lbdcIzLskKdJj+/
	 DZL2xx2hINu6DVVKEYzLKcor5inJFH1bdeI2t9ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1071/1848] nvme: unregister when pr_register() is given a zero new key
Date: Wed, 18 Nov 2026 15:51:49 +0100
Message-ID: <20261118150002.744189371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit a9d431124fb2e58215daf0299d6fcf47bbc2d6b1 ]

The block layer PR API defines a zero new_key in pr_register() as
unregistering old_key. nvme_pr_register() sends Replace Reservation
Key with a zero NRKEY instead. The host stays registered with key 0,
and its next registration with another key fails with Reservation
Conflict.

The pNFS SCSI layout client unregisters this way at umount. A later
mount cannot register and sends all I/O through the metadata server.

Send Unregister Reservation Key when new_key is zero.

Fixes: 1d277a637a71 ("NVMe: Add persistent reservation ops")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ sashal: adapted nvme_pr_register() to use the existing old/new parameter names and numeric action codes ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 11d7ef36f9670..70784bbf21dc1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2286,7 +2286,12 @@ static int nvme_pr_register(struct block_device *bdev, u64 old,
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
 
-	cdw10 = old ? 2 : 0;
+	if (!new)
+		cdw10 = 1;
+	else if (old)
+		cdw10 = 2;
+	else
+		cdw10 = 0;
 	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
 	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
-- 
2.53.0



