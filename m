Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030972;
	b=dJdfMHTVAMhURwKwDKEYa95QT1onwfaawWBf9D+BKeFp6eLq9FzYNOX4A8oWfH9JbpCd
	 uM4YMSd/nJ5h8GJSa6GKEF460BcD+gqid3n7wXBO212BOZsjSdbttD4RXXcTpfZhKn1mi
	 FMOk6+pt8Cx9wBoCWx1zi65w3fuu+VxZ8yGIN8nyvYczWv1yzLA+unvo00HgWwG9vJcKA
	 Z6dwoqVpTYRb+CNupAp0HzZdsnilgRPxPtMmh9p5Dyq8ahJmqZtsQUxqhHu5m897fAP5n
	 +2j+D8byRtGQeazPbVUq2E7YM9l62yUDhO4WjW2VMw+CwirIUzq284+8IvcclDbjMdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rULF3Z4kaeu1yINGboeBdz8b+55qF9vXduH++kwtwCU=;
	b=TRCqmCLPBd/Uic8CMeFMh9Pnc0q33oS2JxOtI+S4dj2dvdOpcOyTRAZYQDFdLVF2uP5n
	 RUJs3dwNcwlaLyxaQNylDXLp4YqPMuRiUI5APQ+qVY+kMfvsT9Qsf1+ZehQV4Eyx4A5Cf
	 UBf4OShfabzuv43vXL+nAcd33JTMEOC12ZjYQHMfkkDi4YI1Wi6LlDjiyfbJLD8V2g936
	 oL3EV4/1zJird+pLvrO0JPAuWoQPrtq187k/NVhZi2zYwmW5Nm4ndV2VCnQBLT2385FsU
	 /IqhAu3bLaHtbB7qyBhtmGNdvWQnpCVIWzE42nGN31KEZoOYdMQ88z3b4kVDc3TAAtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwnHrbJR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464E7606A31C;
	Wed, 18 Nov 2026 19:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwnHrbJR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC6D1F000C4;
	Wed, 18 Nov 2026 19:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030972;
	bh=rULF3Z4kaeu1yINGboeBdz8b+55qF9vXduH++kwtwCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwnHrbJRfVcnOdzTlpQ2F6NN8BlVMkjkQ7BLxKuxoA1vi8SRsC0jYqS38Xrte8Oqb
	 bJuj3gh2gX6epz/yat+CF14n+IUXP7lcSWKjz00FSAKglIdpezYh7aZcHX0kXd+dXC
	 6PjtShOiMrJEzRUAVTa/TRhzPPK28khwYzZz3Gqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0894/1756] dmaengine: ste_dma40: Validate DMA specifier length
Date: Wed, 18 Nov 2026 15:50:21 +0100
Message-ID: <20261118150045.489194697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9f1064ebe17cf3ab65ac6eb166398e02678aea33 ]

The DMA40 binding requires three cells, but d40_xlate() reads args[0],
args[1], and args[2] without checking args_count. A malformed provider node
can specify fewer cells, leaving some of these values uninitialized when
the OF DMA core invokes the translation callback.

Reject specifiers that do not contain exactly three cells before reading
the argument array.

Fixes: fa332de5c6b3 ("dmaengine: ste_dma40: Supply full Device Tree parsing support")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-17-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index d51b7c19d42dc..bc4e30d46bdc9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2395,6 +2395,9 @@ static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 	dma_cap_mask_t cap;
 	u32 flags;
 
+	if (dma_spec->args_count != 3)
+		return NULL;
+
 	memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
 
 	dma_cap_zero(cap);
-- 
2.53.0



