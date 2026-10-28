Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211576;
	b=46r4cKt6lufzkys2r/fs8g9+TTRf8U/DfNovZFe+WnI04QN3lyvbo2H9cy7LCFvK4I1n
	 KGIvXL8cfwNfAeNvpUo5zpdStjS6V8KO+38F5VHfRuT3q54bVSvzun2LR6L7+8Kjuiv/B
	 L2/p9XqbrNIoJ+q4NA3IEjvuQeMxmlwM3IZFf6yqMMeBRDAK/KM73eq8QcTP5R4SgqM3r
	 ZieCXyseOP4WPtW4LEWl2SYKUH+xLBHaEx2RmdnTTvEAc4Eri2rhBX1UieUWe4Cogm7kI
	 tySsNDmxRNvOmRaTkG1mlW1eRut9B1/TApgbw+2LutWX8g4XaGHQxNgsZcODCds/rTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0LurOqfBsey/K7uL5eQaFK05l8amGrm/rvWDwiRD3Ok=;
	b=XqCJmYzm9EB0sMhpyTLDKsxu0hJ71rATCiFpkbxuIwv4ylGt+OV2BObIxeZAkh5HM0Zi
	 dSAhgIuv4l5C3JfYsL0Pay2ANYHNoNrnp9loY4kvvYI2gV2mPy5xMbwSH4+KPYYS2OxOv
	 aisngSMf/fg9got67RnKAdBAiN+VK+8RWeuRFC6943sHUvjY+CpDQVQh92Sx0FQzfVNyu
	 wi/D58Ou1emfUdvCZqKDgKh/LEBYyHLsMkj1gbktKx3R05PtFTNfbJrECwTik1FTQYeMF
	 uwwbmWlVop0Jvdu5iAzEZARyDxKuv8seerDBfiVVAjady6NyKf3lDphULuSmg3cLcqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVvPJeUz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D21606A31A;
	Wed, 28 Oct 2026 18:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVvPJeUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458351F01825;
	Wed, 28 Oct 2026 18:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211575;
	bh=0LurOqfBsey/K7uL5eQaFK05l8amGrm/rvWDwiRD3Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVvPJeUzbvGzi8RyxJZwHN2U2/DinrsMr2she4wmKxaSG11VZIJVQ9vp/wL3csNWk
	 PaAmo9TYw9wGyQRn+Gcqk1ADDoTNNltZ5w8uZU0cCxf7DHW+CuGbBQhBryfxb3VTKC
	 HWvYpFSTsUUkoCC3wgQlf0iM6uk+ZGf7Gk6Tqd2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Vishal Badole <Vishal.Badole@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/571] EDAC/amd64: Mask UMC chip select to the four implemented selects
Date: Wed, 28 Oct 2026 17:59:34 +0100
Message-ID: <20261028170018.149308775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
[ sashal: adapted the change to decode_umc_error(), using err.csrow instead of err->csrow ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4fce75013674f..08cb7d68c160e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2940,7 +2940,7 @@ static void decode_umc_error(int node_id, struct mce *m)
 			err.err_code = ERR_CHANNEL;
 	}
 
-	err.csrow = m->synd & 0x7;
+	err.csrow = m->synd & 0x3;
 
 	if (umc_normaddr_to_sysaddr(m->addr, pvt->mc_node_id, err.channel, &sys_addr)) {
 		err.err_code = ERR_NORM_ADDR;
-- 
2.53.0



