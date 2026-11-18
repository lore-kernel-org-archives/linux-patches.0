Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062124;
	b=kyqdL4WmI06fN7S+FeJLeJKMgREa/SZa+XeB/QJqCMue5XFBPJMtFZPKh9vNm4QZlEhx
	 ZkFWqF3awdkUu35+llsciSw0/oyuAWPVfv1R5yZXckvkXPIdOcgo04axHCQo3c33dGcD7
	 HlhJcd5OKUfhOV74XXJlQzZ1lt7TuvdaP8jaTf1jZN+S1s4qJrMCqBYGz6Pn2obr9GJ4U
	 6xeloeIcqeK+yhUqxflcZSYlFvmpzbajD5TdqFwT0dbrnTKZdCPzUIwYY8LPl8SgGOC3x
	 psWnXNpZWT15qJLaU+SHBxErMAWZsPANs3njPejPfSJsfH85BfUrVcygOZntb9ZCb0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ndxREuLAfLfyzQxGTYtNA949TT5v1um9i/qebiqB5w=;
	b=Q/35YnEWiVxLvlnT5ld9wOclK8kb9+8EQfNJdiZ63U/tKI7rcsZDfpewqur2/f/Lt+yw
	 LH46IfDEndv2RJp1zNwn/R5p1F8zFNGkKP6Pbwlht3RvbpgFVsfc+Q3uwrlBiT2lUDOpT
	 JfT7LzSUQR3elQwUKXJ326BVf94IoCP8xauzK/hmOdDoPXKbsPyOESihyA6Vaa+uSoyOT
	 ZKtQwfHnPwq+EhSSEwajqv3HE0Cpby4qRAEyFFFKyv8E1jart66tYn9vyVygD7dK/bQsR
	 ZJG28wNSvibvj68QKOEeLdEBY6WPsB7cujuwYCUPxcwJRW6EoWLDbWbERc7Fmaw7jnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdNk+XGe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD60606A325;
	Thu, 19 Nov 2026 04:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdNk+XGe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D272E1F000C4;
	Thu, 19 Nov 2026 04:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062124;
	bh=4ndxREuLAfLfyzQxGTYtNA949TT5v1um9i/qebiqB5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdNk+XGevlkNP2GEnFGORGnFbO3CbMRqAxfacXvwKUm4GdaAHO+0o8+iVbILmhR2f
	 w3aNQcq6Lk54/CeXhXD+XCF8V5ufGOX40fZhZi6LjapVH9kwAtG8BjClSE8nnr1Jem
	 dwO23wkNrrAvNjyr3Y/OdWlI9huxvbzfbNlWDlf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1798/1848] nvme: add TCP TSAS definitions
Date: Wed, 18 Nov 2026 16:03:56 +0100
Message-ID: <20261118150034.532604814@linuxfoundation.org>
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
index ff756283b9230..1e4db5e856a94 100644
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
@@ -1314,6 +1321,9 @@ struct nvmf_disc_rsp_page_entry {
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



