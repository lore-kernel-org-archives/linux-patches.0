Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043083;
	b=SiuQxyGWYFNx9vjoN4n0fLnBazpl5KLG0J4qOMTbykP5IDHCVEqYM8ZikwTkG2izj42m
	 /7cLLva0HusRZfDeSWp8C3RnRGkrO4JQKABwriB0rdhgjb1oIM61iJCCYYVxiN5J+eybK
	 j0TvsQxUa9mN66Tmy8k7mp1dVgYEAd26jSkMePuk2ZH9CsSyZcfpNPOdIF0tiNMQTGqNG
	 41l5flMEVnn5gp6tsF91LDOj45ZwTcE2pd3i4bQeTgD1VEy1wXq+ikAQRNoJscCt+58ZZ
	 MQjomZm7UJts2+RuZdDWwbB8cUP+yQUCrlFcwd4UymJRdljGDdN2jNBSGj1uifTbRqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QdDC9eAfL3y50/XLnPwHMuln3LT3817qPv6x4cnFSBg=;
	b=R109NPDqU2VSNnjBagP6cDS/cxhvp4AXc7d+i+4zWr+nz2zZYCZl827p0Yv/ANBhADh+
	 Zae1iLDzF/pNkEHzUyGSfFu5UIjDwMLyIAu0hivWhBwJY6MLrHr9qRI5RxYOrU+u3dFq0
	 LijIW++lqinsiSA7Clp4MKQN4+aApxYHGXp8WxyfOtgsMn6I1iNvswrwVJGbBcJKhtFFY
	 lr92CtZWRAeUQofoGeBDo3AUv7TvQZW4/hoYmCgYrkL12CH3Kz3eXfn/fll6LVTds37GV
	 ynHDeM0FB5Lecm2YCjojkBWVaZrzXoz7CrV/Xf1h56UK3uwbbIA6pdDs3AhjUbzOAiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xN8c110c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0D4606A31C;
	Wed, 18 Nov 2026 23:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xN8c110c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B711F000C4;
	Wed, 18 Nov 2026 23:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043083;
	bh=QdDC9eAfL3y50/XLnPwHMuln3LT3817qPv6x4cnFSBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xN8c110cdOUcDGygy+OFo41L330YBZ4ihlPya1z3riIKsWFzoP6ewugAGVv1sdWwn
	 X/m/tuG8iUpiE4yOOE2DP9EkZ9E91i2nFt8npAxI282pKAkxa4BRjhlS4Xfm6I07RU
	 Hb+PBCcMvbJU5iWclfnx/aXg0ZxL6apYX0QYRMuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0084/2857] nvme: bound ns descriptor header and body to identify buffer
Date: Wed, 18 Nov 2026 15:18:38 +0100
Message-ID: <20261118150204.311076976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 3c568b35a0d309acb40746552bec2af24cd550ef ]

nvme_identify_ns_descs() allocates a buffer and gives it to the
controller, which populates it and then iterates the buffer with
variable byte increments that vary by type and body size.  But, there is
no bounds check inside the iteration itself except the loop bound
itself.  Fix this by checking and stopping iteration if the next header
or its declared body would go past the buffer itself.

Assisted-by: gkh_clanker_t1000
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1faef93ce4ba6..26233e6a50da9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1457,8 +1457,12 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl,
 	for (pos = 0; pos < NVME_IDENTIFY_DATA_SIZE; pos += len) {
 		struct nvme_ns_id_desc *cur = data + pos;
 
+		if (pos + sizeof(*cur) > NVME_IDENTIFY_DATA_SIZE)
+			break;
 		if (cur->nidl == 0)
 			break;
+		if (pos + sizeof(*cur) + cur->nidl > NVME_IDENTIFY_DATA_SIZE)
+			break;
 
 		len = nvme_process_ns_desc(ctrl, &info->ids, cur, &csi_seen);
 		if (len < 0)
-- 
2.53.0



