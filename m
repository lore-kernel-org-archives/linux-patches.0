Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056902;
	b=EfyqDHFSXN3f6A3cyxDlFKuLex0jHA3DxU7NXnfUyr03YsLNNWEhPQLjldt45nTiGzJ/
	 hEoK35oUwdw+9vRG0AD8Cwos8wj3dVPrlRQ/Rq58dCdkPYKHtbpHfmVMYOqADe5F/p1WC
	 nt2Ix9eBtkReKI7NtInjKXcxh79+1lZwtY7RQZDVPKl/rmO4wIzoPjt72pm0XGOgm8HS6
	 QrK5AOuzVyuZD4LfvW5ihZPOflHxiK5gJtcDqCgpA5M3cGKFeZYkQ28nHKD8PtXSHzDAI
	 hfsGCMDlIIc+GAmkNSEns/PMwM5xqePm0FGsMYw+7h9wRMDaUFaQz/D6urDtL/rDV2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=frZEOYxzCLUGcZNnXv+zv9auKrDTyNJyWSHs7mlGLg4=;
	b=KuY2eROL2Lzqftg4ZUTg7LBtLbhF2NON5qB3UdWdXGonY59XNEMF35YGLe2YVPqyb+Om
	 IG0jCq3wi39F3D6nU1nNdaCwWqAM9J3crrwS/PBaKaz+Ax4X2GaONu6C5Z8GVIqqjR31Y
	 aDxnjm1we2TH2L3ST9/66D4u2KjP4eVJJk2H/e02pgU4B27SHsCsY0gvFo5/VVse40Qo8
	 JPdXRf2FHhh6axceKUpo77w3m5kjnechOrWEdm+xiz8RAOT9qVrP1e5lE6XB7YfIO81EQ
	 XibmyaS/Y/ogPbnJpnV40h69OmMYQLOc/szm5EFdmNPRvnTSx18YhXewtWHi8xBfnxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdUtvObz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCAF606A31C;
	Thu, 19 Nov 2026 02:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdUtvObz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050C21F000C4;
	Thu, 19 Nov 2026 02:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056902;
	bh=frZEOYxzCLUGcZNnXv+zv9auKrDTyNJyWSHs7mlGLg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdUtvObzAQVUvhE8wazgXUgPxCF4tp+dLlKVrPZ5fDzvauxTYLaCTXMrg8K3fbV96
	 4oWEBRXnI7JQIh5k5sa9zjw8M4ICAMErFjFa1oA9uFvLEg5lnIhR95qADjjhYJdZN6
	 BgZInLAOcLgosFb9+y2vuc2MMInh0U6jx9Ui0p7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2152/2214] nvme: add TCP TSAS definitions
Date: Wed, 18 Nov 2026 16:03:48 +0100
Message-ID: <20261118150136.562508928@linuxfoundation.org>
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
index edc701da824ff..989acdd47892f 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -92,6 +92,13 @@ enum {
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
@@ -1336,6 +1343,9 @@ struct nvmf_disc_rsp_page_entry {
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



