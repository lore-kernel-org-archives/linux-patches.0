Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044885;
	b=cjVHELJYX0H/HE8Z/aCxjCNcTbv7EioS0FkClJ8rHOLn6Azxm1Gra94sB6J3yUXQZVGf
	 ca8sgGKrUPrpI8tAtd4rrKm/igMiViq9FQuMUOmIhgXUCpYvIxLVK4AF9DAMcB7eD9j/W
	 hMgEBcwmSC3MVPYsxBn74Myc3UVvGDRaYXkllfXZLrK56U8U/BBriqxAVfeZ60rXMih/T
	 W2rK7YhaIduP3EPdhCGjR/5WIsxD19MRwpZ1Fi22TPag1qzXXOFmGLFxF8YhbBETB9tzk
	 o4NvA57ularoFPbT2Px6NLv0C+AgAtPRspKHScbLklye7pVRRM0nNanjoJNFR2JgV3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0M3m3E+8FzM1+klyUML9QiPvdn6Dg9tWwXbrJvGrLo=;
	b=Jre9DU4hxvfzqcP/qmirYHGXJkR7EEiI3hPXyn4oiYxL3fgvJd1eg+1lslIJgZfdzZFf
	 TddO0BrMjHpSAd4ZxmVV4+shqURbGH2/vxtcbOrzC0vPNiVuQP8TlHn7v8FCl+QANDFH2
	 FtuvJYDBpkNy2r7RarHf4thYrSo1xmqcHj6lyJrDu4rbWDzq3E62IEfqGgZ0niqqqsOfU
	 1p7RbYMfFObmook2hv1ottvJO4C+Uo0ibWJh7mHcr8AMz3bV6Ge0WoPgGf/tpzAjorcNw
	 WuRihTvEYGScaqkOUmuPIIGLho8YdvrqYFHaATZXUof2xPLt2RXxuP4oyJg0kakJrfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjSkgO5o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0166E606A330;
	Wed, 18 Nov 2026 23:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjSkgO5o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544711F000C4;
	Wed, 18 Nov 2026 23:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044884;
	bh=+0M3m3E+8FzM1+klyUML9QiPvdn6Dg9tWwXbrJvGrLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjSkgO5oe0QGktQQmhW/BKWXPzoYty9JmhDndijLFhD3Mxzw/ZgiA3Md/sA+o64fR
	 A7BrXbf3/3fWt9KnpdL/Ky4gkmQMMqBpnZLTV9kMgXOYGekBAbk03Jcu7IYyNO+eF6
	 eSCX2KBhBuGlWwa6BWNqYY87UQ6Kl+xrR/v7CxxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0724/2857] memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT
Date: Wed, 18 Nov 2026 15:29:18 +0100
Message-ID: <20261118150227.613212612@linuxfoundation.org>
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
index c2da86e37d679..89854d680cdd3 100644
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



