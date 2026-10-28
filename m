Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209210;
	b=Yi0aUcrktcFkHjOt9VCnKANkqMk71KL/is3tUDX3DBvF7/USycVrtAUlUjByR86nI8pi
	 i9qv2kigzRIfp5Vb0eUqBiRl7BBn+B41GT3Qv7kMlgCn3leyrQ2fb4Sg13s73qjxe1ZtL
	 +CUQ8i3jJYe5FN0/EO8OCJ58A+mqmuxTtBu/9sAqGWgTjRRhad7o/jlvGkecwXeSInuhJ
	 id+JOWBHWTEJ/nkQ6hUL9Re0Xozt3wb0UIDFhM0cn6S4umTSAUDb1oT12/DkYvkRf70DM
	 3cOYBMz0Xk6Ju6M8H1qjOlZuEqZt52bnyG7g1+e3j2KawqJ0NzhD06rPHsIl+p9hy+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yBTxVn9EeDYBk5pko4MkP03/zeOfGaUw7dAJIHG9pJo=;
	b=XMEaB0DkryiGzrWswJesW3qmZ+0T0hVMstbdhmOh9vTxTuepcqoGkSLSX/b9D3qvL44d
	 JxANJUP17lADz6sBdfCpWQ68o0MO3LH0TkQoxP841tutAVL/ahffREmEDo+RWXg2LcSeO
	 BWyAAeWPm3C4WGt4ZwZqxtv9vJoSc8jQP5F1Un43qdAfx+2wS3+SDv0SI/OaKm79iqR89
	 gPuuqWJas6Iol9NWDEcCU+sWrSuGMVjYWMLkbNLIkGCN1/lmgEfHV2Qc/Q41lw+uOcMrU
	 wkwTB4rGdQrUjNxHxetJsyQj636rTDUHtyq6OcPIdV6pFY0xo3whgaMG97OtQ8+JBdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8tnKSVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FD1606A31A;
	Wed, 28 Oct 2026 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8tnKSVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F4A1F01825;
	Wed, 28 Oct 2026 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209210;
	bh=yBTxVn9EeDYBk5pko4MkP03/zeOfGaUw7dAJIHG9pJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8tnKSVoToAMj/txdmXFEjLp+snqx7aX8lujbZOQX2FJCg3I/vX1OP41Hiq+O4lEu
	 qyMzDZG63Ujt24JfsBsVGUB2B0W6yQP+h82m8xS40dDN+4GfkCLVQZs/IaB6VdQUVN
	 j/J/YEjAXzIfDhxogCvn1M8vd4sXehd0EY0Zg+3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Vishal Badole <Vishal.Badole@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 374/516] EDAC/amd64: Mask UMC chip select to the four implemented selects
Date: Wed, 28 Oct 2026 17:58:46 +0100
Message-ID: <20261028170012.345232426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Vishal Badole <Vishal.Badole@amd.com>

[ Upstream commit 7484bc43ba6b8e189b482db5b75e7842890a82b1 ]

For DRAM ECC errors, the chip select value can be found in the
MCA_SYND[ErrorInformation] field.

ErrorInformation[2:0] was first documented in Zen1. The 3 bit field
implied that up to 8 chip selects may be used.

However, all Zen-based systems have only ever had up to 4 chip selects.
So only bits [1:0] would contain a valid chip select value.

Future systems are redefining the field to ErrorInformation[1:0]. This
matches the existing 'up to 4 chip selects' implementations. And it
frees up the extra bit for other decoding.

Change the current chip select mask from 0x7 to 0x3 to prepare for the
decode change.

Fixes: 713ad54675fd ("EDAC, amd64: Define and register UMC error decode function")
Suggested-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Vishal Badole <Vishal.Badole@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261002113204.3358815-2-Vishal.Badole@amd.com
[ sashal: adapted the change from umc_get_err_info() to the inline assignment in decode_umc_error() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index f5635dfa9acf6..dea7df975948b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2669,7 +2669,7 @@ static void decode_umc_error(int node_id, struct mce *m)
 			err.err_code = ERR_CHANNEL;
 	}
 
-	err.csrow = m->synd & 0x7;
+	err.csrow = m->synd & 0x3;
 
 	if (umc_normaddr_to_sysaddr(m->addr, pvt->mc_node_id, err.channel, &sys_addr)) {
 		err.err_code = ERR_NORM_ADDR;
-- 
2.53.0



