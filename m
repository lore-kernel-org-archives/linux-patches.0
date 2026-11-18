Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058197;
	b=CyAtDVGjrLqEStIfmOfUwWi669H+gAIIQc0vL21FJomAh8sutwn+sKAdWWkAQqoPhPvu
	 /dhTqEz5hRZ3NCQRvq+xj/8gA8CaHJ2xifjMuCiYXEUDqNvgtRn+N26dflV99fr7urM1Q
	 m3PAiez42EKxlxHqW8vrHJhsLlAVUx5cK/nbMeSy+d7+7BLFBp3eNO8pQ52gxRsP8i3Pm
	 4/i9/vUVZCM/cBNLkz3LSupQ+d4djH4NQcEzenY3a8+Zm7dTErWvT4g2doOu/ucB+fFlw
	 bvpQ4WtSlPeRohrLvxUgaceRJa39X/SBBuBBE+a3a/U+I5ehbeeHF00LKryd1n8Ev0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ni1pWOCb+OZ0BEEZfBm2oew98TcwjjhKK6c7hibjaZA=;
	b=KHGay/9XuxZCikRUPo6gzSVOtb1eb+dt6abHZ6TItr1d/At1bylu1OsfyscM7PsdiXqk
	 2wZcdDhcw/E5udRh2uYYiYUheq+WITloF2/nn9iFHiUka4jW5NdsE0EFnef45kDQk6VB8
	 dQahgDAwkqoAUbdoH6nYm1cXEf6UCO/qIaVm4A9BP3U0f0x8h/so0otugNDalqmvFXxOE
	 eChgeOncgIf7DD0MWCBpFv5kEb/b7DzLWxtnZtB+ww8wL22lRBbZQbQ5rtz86Fd6nVIe5
	 JRUODWHA/d6lD10OoEQ9eP5WXr7d2Pjv4kEedILUACVsPHztCKLNgbOIr2e9JZylBgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUASBjgs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8746B606A32C;
	Thu, 19 Nov 2026 03:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oUASBjgs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00321F000C4;
	Thu, 19 Nov 2026 03:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058197;
	bh=ni1pWOCb+OZ0BEEZfBm2oew98TcwjjhKK6c7hibjaZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUASBjgs1EVyC+ozonNF+17Mf6/YqyZt7LTkuWJOzaiQnkMY9036a18wwEGcIp2J2
	 MbKKATdgXQlUX1kbCJFSOE5rsAZVsBxGWQ7ift9+POTSamlafCYMjDl3sIT6Wvrtnb
	 342fms9GXs/q/jozk68yVWcpWDb2tWzkhVcGD7D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0358/1848] memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT
Date: Wed, 18 Nov 2026 15:39:56 +0100
Message-ID: <20261118145927.935345081@linuxfoundation.org>
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



