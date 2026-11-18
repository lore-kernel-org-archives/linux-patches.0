Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057134;
	b=kl2Qf4VFT8xpOeUhzrCATNQcJETwhAKT6G/TproirtthLvZJ6hVPPJzZFt9RY0qQcleq
	 0X81Vu4XQc5X+JJFs2n4UkGUGEYQtjlizH940sTfewycw/0gA2MGpStndDnYylsK2KxFH
	 REqCWEyYzairmn9aD7UkaqrSKxCfJrPuv1stFAgUWpUSWysbr5+BSEWXxdWvVsrl5qGhJ
	 J7eUH7vKkmhDcH6ROHdyRB8nwFM1z0kNRcfsoqklWJYzRqTbb+bMGqzNXBrGZ1CgMzpg1
	 Yn+FP0jMU3azZ9kWlH2TQQu9yOIqol6COnQGyEmTIo5GvV0Gxa4WhRwEo8GYrLonmhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NS4DYSp1WKx1sSoy0EH8evT35KxEe5kHbWNECDZf+5k=;
	b=WL4UC7Tz39y2m9ShaNO87Z6g9EfiFUvpeGopBH19Dp+TYt7BfAevg101z2xcyPSMUFuO
	 UJNyKzj8DaZTav7DMnmJh78Zo6SJNTnbv19lwmu/SNTxOiJTaj4JFIIijNsvMt13N+6+m
	 SrpamaK1rbc+axfmjz8UdkxBC7M0iPVDhBJip8aXU6AotrjmuJ4mLtaGK8u9eG4LZxPVy
	 yOwBSVL2YJm/j7Rea4wqvgOvK/YH+qtn30ukpEs8aDu4J/mgnLQcQVA/rVFADugsYTVj8
	 mcPoCiWzJbXTTk0Lsxbc8GNJK0ojDV2tTN0H8joJ8FHrOjrEYueNFqqT5fKk4G4tQKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axDLiEHh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44292606A32F;
	Thu, 19 Nov 2026 02:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axDLiEHh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC7D1F000C4;
	Thu, 19 Nov 2026 02:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057134;
	bh=NS4DYSp1WKx1sSoy0EH8evT35KxEe5kHbWNECDZf+5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axDLiEHh/f4OoYHC92sTVKBXIK9LDGG2PW5kuvpj2zsHA7a9NyGpbqKwMxl5XQqzG
	 N5CQj91eXm6dcf3dH9xrA8pwQudh17RkBD6oAu2DQZLVyQkJ6KJjS656Yw3va80Je1
	 voTG3SHB/ceJGNNfx1g9MG7yWbUFOo9ttwMe0dmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0006/1848] nvme-tcp: fix error codes in nvme_tcp_setup_ctrl()
Date: Wed, 18 Nov 2026 15:34:04 +0100
Message-ID: <20261118145911.487942179@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 522af60cb2f8e3658bda1902fb7f200dcf888a5c upstream.

These error paths currently return success but they should return
-EOPNOTSUPP.

Fixes: 73ffcefcfca0 ("nvme-tcp: check sgl supported by target")
Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
[ Karl Mehltretter: Omit the SGL-check hunk because 5.10.y lacks
  73ffcefcfca0 ("nvme-tcp: check sgl supported by target"). ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index fd222eed9e019..d61a90b9bbb0b 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2116,6 +2116,7 @@ static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
 		return ret;
 
 	if (ctrl->icdoff) {
+		ret = -EOPNOTSUPP;
 		dev_err(ctrl->device, "icdoff is not supported!\n");
 		goto destroy_admin;
 	}
-- 
2.53.0



