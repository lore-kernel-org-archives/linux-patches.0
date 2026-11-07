Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062737;
	b=3OPdzKxU+n6AskMMITRzSswo1KN4mIqY3JDzRxO1k/6jpadJ/FanxnEZ5TcqXi20dMF3
	 jBaU2RxvoX+tCKoiZtbzYYmaxuQK32eWdj/7/GgNj1FKNmtvoClM2ATBKHcGZUeY//7eL
	 WWoTO5On9VNr2S/D0WKmR9OsN/9MQWOqDzvX8sPASXuAEddziOOrC2SgxGU6zjybxXmEn
	 bktKQr1P4s16cgnSX2I/ZTH8fyR3X1qw8qAhditNH4projq9XLZxpn2a3Lt4q9zeoOnru
	 biWQGpEoLmqV27NQB5qLcCYkdNZ/ACzlSfUvmcijy+0kdYYidm+qXRStta7q9UajGyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zCoebUK0C2dIrMo8jcGoruUKoJ9KawvuS2u5uvp48yU=;
	b=HiTRFLGxxOsIjdnViE59pOcfS0A4tN9jaf2gMeILfRKw2sWjlwwRmu1Y4hWh2daohVbg
	 uM4BaPsTbDOLEgRaGvcKYBZz0KEw6XRSLwznE/9CAKaXDRYYlAHAYgIfRV4gnzY+/A5f0
	 fUrdm2YAin8l1vkm1ttT3cCrZ4SlFZc2ZwOYjNcsMo3S9TcYJR6Y9dQsI8Xj9Zmc9Pd6n
	 SZtLF3KKRAY0iJzUJw6X7oPap1IyGg4767B1tx16PH6QJotFKMdgPZjVbrKX7hwqN452U
	 nWZ8Ft8okZ4yGUs9pB9zEa35mPLfJHdRd3fPuJKYSijEId5oG0vXP1y/xGn/cx/bR5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SokouDpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9E7606A32E;
	Sat,  7 Nov 2026 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SokouDpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA3D1F0089F;
	Sat,  7 Nov 2026 14:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062736;
	bh=zCoebUK0C2dIrMo8jcGoruUKoJ9KawvuS2u5uvp48yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SokouDppBK5mD8bnDXB1011LP3YMcg2OWRtesIg/zz4gNMGVo4gRXPtUNLCeOeiCa
	 +HHZ9ujAn+zq8ozwhyUJhZ4ytUyAs+r5vWaX5wNQ/fRZReU3vYwtOeASrKSdSAdiWU
	 4+7OeT7wm9J5wqUtjYLwDImfV+wttT8C98j9CYbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/869] memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT
Date: Sat,  7 Nov 2026 08:45:36 -0500
Message-ID: <20261107134853.912075422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 6b07f8c06caca015a0db69e3f323b5186469bc66 ]

A compromised or buggy DCPU coprocessor can make any user who reads
world-readable /sys/devices/.../dpfe_info|dpfe_dram trigger a kernel
stack out-of-bounds read of arbitrary extent. This bounds checks
chksum_idx against MSG_FIELD_MAX after reading the response from DCPU
message RAM.

Fixes: 5d06f53d9509 ("memory: brcmstb: dpfe: Compute checksum at __send_command() time")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Assisted-by: Gemini:gemini-3.1-pro-preview cursor
Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260826201500.3000125-3-danesh.petigara@broadcom.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/brcmstb_dpfe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/brcmstb_dpfe.c b/drivers/memory/brcmstb_dpfe.c
index 66343205f585b..7b02c36c7fca7 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -503,6 +503,8 @@ static int __send_command(struct brcmstb_dpfe_priv *priv, unsigned int cmd,
 		for (i = 0; i < MSG_FIELD_MAX; i++)
 			result[i] = readl_relaxed(regs + DCPU_MSG_RAM(i));
 		chksum_idx = result[MSG_ARG_COUNT] + MSG_ARG_COUNT + 1;
+		if (chksum_idx >= MSG_FIELD_MAX)
+			ret = -EINVAL;
 	}
 
 	/* Tell DCPU we are done */
-- 
2.53.0



