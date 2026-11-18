Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054435;
	b=WG9MQExK5uLkdEsSVWV8OjPonv8cHNVeuNSJYIMWsjgx048o+n0Go2bTrrs94+XvSCKB
	 agjxL5orglxcsEpkGfw4ss31ISsR+VlpHtfFL9YboFLzzn6BtYE0HcDnFd3WelPHPmV54
	 qCYHunohjiB6oWm6aV1OMYOYtjUqGOtXRd4itVYPQ59tz/LJMJRX+DeGvbmnYs8VSjBBC
	 8yYuvFtX10hqBYfS2SvOmO4rjDHuMSfe+chZfV3k2ErH4Iw6w1QwrDriqC4cfctPqAn0E
	 dBnvnfNnbazfK7B6x1deFWeLKbVpFmgoTuU9HnRLW/e01477zGwCEONX9Le936g5IHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aFYkBArjM+hd14wMZJSn8b257cMtfU7vQ/CNeg5Srwo=;
	b=ZQf3z+5Ib4Vj/9rpbZusxjcH2MCTl5HoDoQUC3klBcbO0c7pbeZ337vySanVNvziGA7I
	 dnP1mn6DR9TwmAs6sQ6thp/3SuM0BPZOyOYbNcyCA67HUSGmUgp0kq+sZkl73TghJeeRi
	 ndsDhgoFpym/wk8enR0JxoHgA5AjKww/BlHP9v//vB4I8jNftY0gFyxqvpBvpVx6rC3us
	 PPdHmrmtkVbfGBlB99MJ9lQ9Xbbb09OIwQgo9AdQPywAjtb2wVEhJG1pxcpymyAltu6d9
	 Wnv28Gd2EnuNN6WI/fhO3HVjYNIK/zGxKwrgA//USV+JTjVkJZ6SuV+lrZ9Z5dWAaaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=waypGAqQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2750606A31C;
	Thu, 19 Nov 2026 02:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=waypGAqQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE13D1F000C4;
	Thu, 19 Nov 2026 02:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054435;
	bh=aFYkBArjM+hd14wMZJSn8b257cMtfU7vQ/CNeg5Srwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=waypGAqQZ97FU8WkSkVu18Cy/C8Zl1J3/bPU2RHlf4QX5Gq+zol9HWH6BcTaf1elE
	 cvTeG3YiqB5Aza/D0vUBzPCTJaLxx6MqIAXYyHG0nX27P05535metM7prDV7GzE/nA
	 mQP/TsCbaBaIGeZwVdhhB2TFBkkgXxEfBeySH9Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1273/2214] nvme: unregister when pr_register() is given a zero new key
Date: Wed, 18 Nov 2026 15:49:09 +0100
Message-ID: <20261118150102.514062131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted reservation action selection to use numeric codes and the existing old/new parameter names ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ae98572008370..9d6cb96f70784 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2089,7 +2089,12 @@ static int nvme_pr_register(struct block_device *bdev, u64 old,
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



