Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052118;
	b=Yb136EzJcikqniXBsLOonHj6CbSILbzf44PpJQkP2tIZuCtaqT7uANvNFvU90UJyAEH7
	 x/NOJNA2boG2ph0bHK9wyRSOJteCQUHB3BOQL4DSqKH4IgbSPlO0ibHS+1behAcIw0IXT
	 qdmA6MP5Z6XiGsTD0An0P+z+od7YuhdXn8OwWEA8TaqND9dKUzFD9u9eq2HcaY/dhjtM/
	 /zzGXTlCQsHccQQP0qBLCJi9gkk0DGFxok+vT2T9rBGcjBHqbOigKqsiXLbuusNCztcYd
	 EExW4hzVwhi1NR3iTNE9G3O1ETCAMSFCbjk/28aVk57Q7yCY8BBAG8VfbGKiSPnf/6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Di2y2tSTsWzuf5goypruEUqKHwjoxTqt6iuH65PYDhs=;
	b=2NroKi6/g7JyX2zUwpqzTiOdAuby32ifnWsEsCHxyDwWxbNqu05kPWmXgF1F6aDfozZI
	 o84fuX/WCqPDU6UQWs1I8bxDvbzoTg6pSC4kfrnt3tCZIJ65gr7CpD1wX56FKb2JYk8Hw
	 a8lm2FknAnc6UnAb8Tk1XVZ4QLUWoxzIm6qP3yv4lC9t+6QzBXJQG5Mx66ub+dIOt8jXL
	 yZYPAdJ1D2d3bbtZRdYf3JLbE0Nm4CctXj24vD/CAdm5D1hSzPXfljQPHElRHZMNKCVz8
	 lmdpx5OZY84mv33k99qMwwS0DL5WK4j3AOaWPP9I5MAK6rYDvXhBTsWWwfZy0SPpAEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q/Sil15E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBDF606A325;
	Thu, 19 Nov 2026 01:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q/Sil15E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3A91F000C5;
	Thu, 19 Nov 2026 01:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052118;
	bh=Di2y2tSTsWzuf5goypruEUqKHwjoxTqt6iuH65PYDhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/Sil15EOyWXuRTTPLgm4cDcM+1AkFJ3ccvx7BrUsHt8zC2ICFsNr/cNBKZadrtU5
	 qsFKnZJxBxr86sc1boiXTtZM3buKdvyoanMcbPzW9p6RjoO1NQPqMgiRgmS59wynCc
	 3JF5sjKdsDwbOuduLPZM2g9RgMFbiJUpPpp+28f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0449/2214] memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT
Date: Wed, 18 Nov 2026 15:35:25 +0100
Message-ID: <20261118150029.027904733@linuxfoundation.org>
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
index 86aed3a31e3a0..1c8ed138b93ad 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -504,6 +504,8 @@ static int __send_command(struct brcmstb_dpfe_priv *priv, unsigned int cmd,
 		for (i = 0; i < MSG_FIELD_MAX; i++)
 			result[i] = readl_relaxed(regs + DCPU_MSG_RAM(i));
 		chksum_idx = result[MSG_ARG_COUNT] + MSG_ARG_COUNT + 1;
+		if (chksum_idx >= MSG_FIELD_MAX)
+			ret = -EINVAL;
 	}
 
 	/* Tell DCPU we are done */
-- 
2.53.0



