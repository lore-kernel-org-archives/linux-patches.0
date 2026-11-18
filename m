Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042549;
	b=17x61ykQ7C7SCNcLRrfvulxDzTQaflaLhvb5tsE4u31r6xUFCg02KyJXaQdx+EHAfV5A
	 Tr+FHnXzssISedMTo289xB/Ir/s85dh+KxauKkkQioEnU+NEZkOSmItBbcTZC09dSOAHo
	 memZ5bmzXqFkIN42gMlgD734xmfYmJBe5bhcw42zziM/0CqfNHShbpoCuFD1JOLlQQ7fy
	 HMyf1j0v9uuJRylL/YwMC0nL62kRQUR1mo6YA7Km0F06N8Wn4NikgWCHRcmJHnbTU13F/
	 JqSjDyNYh84WoMXoqoz1sWJI8Qhff3yq2d4ODhN+Rjc8nJbTP35HgHNd0vVSAEhpc9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3xnTzQLRftpA/zUBKbnv7CrEGylmIDTlqDmTbDoyg8g=;
	b=YyBWamYcV7SgS/RoH0ivlxmQSfDJ5jrUWTBgIN/e4QMOBpTz5Jr9nYZwHS0z7mCTtKC+
	 wZqn4WqEjroRWakk/I8VnOFXI25TVR55HPUAoBnLAuf7nEht7ysSrka8Xzhexi2se/4TU
	 EJlQZCjTGn+n98ZchBvxh4OltpR9YiIflG7hg+ku1Bw79GRvIHqXvnfPUje22nTjglC/G
	 /upre/Z9MACkmHPGQ+oF5fuv/DLauSan7Yy2bv2iL8xofC3fuvwF7QzWlVsE9sn0JvrGw
	 BQZ7Uegxooh/g66dUwyvbOo3zSzKSlMRif0IrLAMSlvaQFvJybocxF70RSixvb6Kxzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xdt2pvh+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCBE606A320;
	Wed, 18 Nov 2026 22:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xdt2pvh+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DD51F000C4;
	Wed, 18 Nov 2026 22:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042549;
	bh=3xnTzQLRftpA/zUBKbnv7CrEGylmIDTlqDmTbDoyg8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xdt2pvh+FE274mSlC8nU9otD7Bp4r+jcrJLbbyOfd39aqLd/V65yDxh/Zv/wg0VYG
	 ge0BrTnZPgIZJ7virRZmB6ypjOjqlvkU9eizw0WzWtJZB/AGJOCa6WlFqT9BlcfZge
	 LuBcwW8jWV2GZvAMeJSqb0kwbLuOIZQbqJ6MzeyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3211/3318] nvme: add TCP TSAS definitions
Date: Wed, 18 Nov 2026 16:03:53 +0100
Message-ID: <20261118150456.072729626@linuxfoundation.org>
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
index c50a9bd13ee1e..007de3eabba61 100644
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
@@ -1496,6 +1503,9 @@ struct nvmf_disc_rsp_page_entry {
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



