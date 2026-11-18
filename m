Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050602;
	b=s4ueWaoXhdelZZ4RgMAQg/GeLoZOiO2F7iIa1g2NNzYqa4syFWAyxLoBIYzxBwLaR6Sq
	 4UQn0aCU9kC9olWCOB+rmvvrpj+PgG3/zJj4zxiZXkhnLj05u7+mxIHKiGRgdT0fNLLRz
	 TCF0B4ZXwHWoZMgB81DMJhViFpl162XIe6i+jr0P65atdL4V1MkA+yaiKyIGqxLLFA8x3
	 Hxd93KloQl7B+DJtwc3qJOP5OyLgHeBUf9ypJFjE7H0MMhJ4Zxqh5nIXO1PBKLD30ec6t
	 zjH1KChGdgnq5OhkDksDKVg2e7F+5z5y4ud0WOjMjhGx7A9F7SwU+OFLwEhIvnUEseA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ZxERjMZB8GJHvLswdbPbJsxstmmwuh53P5fd5yun+I=;
	b=ZtIneggbKqCj7qRdencOhxHFss7KUvBhwG/iGWUJLLTr66bqGXNyVhOTgUVfQRB3wVdu
	 SOsk/rzcNZJ6cnc4wQ9MjSeFROg+LbH5LzWQCp3iMDh/18wzlnRreEDdhlsIQ5mMxHwUj
	 dpB6d8BhD3euJIXxwt4WCDrbCw7seaNLNVcG082/qdke/II2yKY02VXqY3Fg9GOOZ5wrI
	 6A79XL8hb8ElR1Tog6qFEl1mw2af5tcMEDBd00oR43mozBbhCQ18QdclpbQp2XvIgisOQ
	 oJTuxAqCeqv1ipqMOm+K4/GTFh+MgPR1hSFOUyv/1KNAt/iCY/Sql70mamJRNUfKy5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=snp+fE2c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AF3606A31C;
	Thu, 19 Nov 2026 01:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=snp+fE2c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758771F000C4;
	Thu, 19 Nov 2026 01:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050602;
	bh=7ZxERjMZB8GJHvLswdbPbJsxstmmwuh53P5fd5yun+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=snp+fE2cIhxCRQSrJBXhBEmXd9JGoHt2gPWse3kUd0QYS5JN1cBGaxj7MwA8dACH3
	 LzDNJvjl0m2OEAONT9UoBdarbcdPrlFfwjtFrGmyne8MQLo9D0SfnrfoYK+BAT5ZEM
	 YsFTaqRy+mEYkbtkuyDWfutSnfLgfE0ruTt99Djk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2767/2857] nvme: add TCP TSAS definitions
Date: Wed, 18 Nov 2026 16:03:21 +0100
Message-ID: <20261118150341.232331788@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 646f45b23218c7a97a84259d8eeb22dad5711fc8 ]

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 60385038754e ("nvmet: use the enabled transport when disabling a port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 7f8ef075b0d26..7a41f5f9cbd1b 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -111,6 +111,13 @@ enum {
 	NVMF_RDMA_CMS_RDMA_CM	= 1, /* Sockets based endpoint addressing */
 };
 
+/* TSAS SECTYPE for TCP transport */
+enum {
+	NVMF_TCP_SECTYPE_NONE = 0, /* No Security */
+	NVMF_TCP_SECTYPE_TLS12 = 1, /* TLSv1.2, NVMe-oF 1.1 and NVMe-TCP 3.6.1.1 */
+	NVMF_TCP_SECTYPE_TLS13 = 2, /* TLSv1.3, NVMe-oF 1.1 and NVMe-TCP 3.6.1.1 */
+};
+
 #define NVME_AQ_DEPTH		32
 #define NVME_NR_AEN_COMMANDS	1
 #define NVME_AQ_BLK_MQ_DEPTH	(NVME_AQ_DEPTH - NVME_NR_AEN_COMMANDS)
@@ -1453,6 +1460,9 @@ struct nvmf_disc_rsp_page_entry {
 			__u16	pkey;
 			__u8	resv10[246];
 		} rdma;
+		struct tcp {
+			__u8	sectype;
+		} tcp;
 	} tsas;
 };
 
-- 
2.53.0



