Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033624;
	b=EOugmblvMQP0luZg1sHb1umH3oPbeNSd0HDiQ6IkQZvVIOjGtLAl6GZKtf7v8Mvsu9W3
	 L/px6VpPjqI9f7fTbb1bs97MxsvTsimY5CMz5oyilXIIfbxoI9lSIKJPjGYNZNdYrmRWQ
	 onzqr35YNu+xtnn4qFtYivwNgqr2XSsGMoZLOfKc2CK6oF6fBm9T7zsaLyA+zR2Wbvnqk
	 4Dg+G3iTV77RBLjPk6FIlbtxsUR2yLrNyfBRQl0CV626hjuHfVgFPhOHITC8lKKAP+tKR
	 Ukts69q76qaYriYkDD6Y2eVSkGZZsmt7u2E2CP1u00C5jTvRiHIzE1s3XrpHxz0c++A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e8ZEmqpNXQ5cb6SG9Bs7dwvV773ZqTtTmBMiHZaucyA=;
	b=mKHkSPT1Q5Zb8k2CY/NuE53xYBHjQ4A9nE3DWAUR6gqOyYIZyUTzOzVh678+Q09P8BpH
	 d7R8t92cDP3VHpRhqe/f5Z+/Q1pmka3oh4ykjJnYeEJZsXPMR/XjB6/XEC+4VwljDDDtq
	 0La/UwME8np1g0oOAFX9k48GFvw7Bj979ggGuxaZYC4cYfHO7j1Qo3B0v9Kmaq7XO1QN0
	 ebasLFzDwJqyAOh/jbFe66G39KkIxRjOA2XHYiAyF6KHrcJK/pT5SeBn4POGIii/uUw3n
	 tifC6Yh/cMnsm6tKMckzmQ8O8cTZ6hQcfDIlBn7pCBucZ9B6GPEo0tVsUOxsmqyhytw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGn871aa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8D3606A320;
	Wed, 18 Nov 2026 20:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGn871aa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A271F000C4;
	Wed, 18 Nov 2026 20:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033624;
	bh=e8ZEmqpNXQ5cb6SG9Bs7dwvV773ZqTtTmBMiHZaucyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGn871aaUeik0uzCKvf9NVfT4mqwbEKD80K52a0PX6l+AoU4eedwd3Y+voLnNo7/t
	 Pa2yiLOoFpMDsIbX44MfaDpUzIwmsfAiIm3NTaLhK8cU/59FSKt/4Y/O6TDr531yMX
	 HQ64mHvVvo559oiJoJNRRXUUjO6KNpNWeHhbuCCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0082/3318] nvme: dont reference NS after unlocking in nvme_ns_head_ctrl_ioctl()
Date: Wed, 18 Nov 2026 15:11:44 +0100
Message-ID: <20261118150316.555609931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f19bef1d30dc6..38e3f17c79166 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -849,7 +849,7 @@ static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 
 	nvme_get_ctrl(ns->ctrl);
 	srcu_read_unlock(&head->srcu, srcu_idx);
-	ret = nvme_ctrl_ioctl(ns->ctrl, cmd, argp, open_for_write);
+	ret = nvme_ctrl_ioctl(ctrl, cmd, argp, open_for_write);
 
 	nvme_put_ctrl(ctrl);
 	return ret;
-- 
2.53.0



