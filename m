Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033878;
	b=NQLq4Vgr91EFsFyw41bzkuoIR/LztlvR4k8eg+mDcWEJiPDw9/B/tQqSxo20Bwf+Upht
	 Yhey3Xo6kwxwYDYaIvwuoGu/xltkZiwGSmos9Z/+GqywWo+Nvbbt6xIkRww9Q/KoUgt0Q
	 yevV45+9V4tjHfoS+jLLqtaejrqYbM/hLN42cHwv0axDA4M365Tw0lotkG4vu9ZHnSh8A
	 MTTxQLhUb7vphFTVmOdDOPR7Uru7+DB+IKLs/3/FQYPg1ycG0rdHYEmCNdy9ynXdJnXIb
	 Tn0c7hlGrph4m8z3wM4v+4AWt/AJ5nbvLtp+bIZ6CHYTz7DCmSilr39x30hb18tcs2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NJp5ABLLi0VH3uTXMKqbkeGN/mfjAEPza0ow8TFWAXk=;
	b=lrWt3wsnzA/BwnY6H5rnqRHKhqSs4BDWB9H/4sv2XikNtehsltTY9ZXQYTGjb78iyFeB
	 qVHFtIeZcYYdZIOn6L8+TSWBcm1sYOSbouwvbdzLVBPYPtMbdx+9YdLU6mZkDuI9WHp5c
	 4QLLaQp5tEf+XwbXnpBlQyBZcirDf5d/p5zaEgpWhSka7ZIQu6x+IZuV5XEBiPN54qcx3
	 hxKaPSjtw4+1d+M9bMITMfWqgxNra/1Y8XZoM3roguMY7XpLbifHEWTLYyHDgipNRbWjm
	 Z5Hzf/3AMcJtRiifnd4hr2sOy13+3CMcd2PV65szO2eZKmugvnXhblbtLwjSigEWKzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DpDF5AcM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E07606A325;
	Wed, 18 Nov 2026 20:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DpDF5AcM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D0D1F000C4;
	Wed, 18 Nov 2026 20:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033878;
	bh=NJp5ABLLi0VH3uTXMKqbkeGN/mfjAEPza0ow8TFWAXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpDF5AcMTyhwNP2P0O2LO/e9rXRKAHzRfhwuMGTreigfFY3CI4rPH4nlQLkTiVB4t
	 p5LnmPZpbVD56UYPDCCeDnTGHbo4cfUlYMvZNpIjHT8vWwpldpArvxJgpbrga9Uc2o
	 5SziI2peBdbRjA+EI7xTJtj2v9VLss5SZ4y3jFUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0172/3318] soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:13:14 +0100
Message-ID: <20261118150319.823471159@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 01479280fa5d4691013bcd64fdfd935117b69769 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Message-ID: <20260704121851.63805-1-pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ixp4xx/ixp4xx-qmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ixp4xx/ixp4xx-qmgr.c b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
index 291086bb9313e..db3683300f315 100644
--- a/drivers/soc/ixp4xx/ixp4xx-qmgr.c
+++ b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
@@ -455,6 +455,7 @@ static const struct of_device_id ixp4xx_qmgr_of_match[] = {
         },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ixp4xx_qmgr_of_match);
 
 static struct platform_driver ixp4xx_qmgr_driver = {
 	.driver = {
-- 
2.53.0



