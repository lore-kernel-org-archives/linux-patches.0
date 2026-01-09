Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389E2310636;
	Fri,  9 Jan 2026 12:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962564; cv=none; b=sNVALd81eRxU4QVJPvfXwcAKb2E4XewJlc80XWUWwz/OA38Npr9C4+HlJN3SONCfSkGr/f5QGmyZoLRgca/6WYDuLT9Ud4/TGjSiDFwELbDjS0JiqC15XyRrU1gpeQDxICWCt5xh2V9sM1/bdUQrOJFMGIA/zNRpYc884JKxoYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962564; c=relaxed/simple;
	bh=D9gJL9X+3bRiE/8kNErbLv1X0ItFa/dGfJDJTI24rlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=euaf3hrP277kRxny9NcH2P7W9Q1XJ2Pjls1zyobGW5CUYkS1IlTdPkv5FejPIqlm5Fj3vVlq8PseFA6pLUqZhZLft6iIUUMeH4Nk/VH6wcOegRhsyOgSm9lZ8iaOrSkXH/9Y9he6rKwBd2zQ1yMiFgn9aYZvD9EEBNttQ8SoGp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM8P9HBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM8P9HBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD625C4CEF1;
	Fri,  9 Jan 2026 12:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962564;
	bh=D9gJL9X+3bRiE/8kNErbLv1X0ItFa/dGfJDJTI24rlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LM8P9HBVU0mOfFCdZJxdxhfVDrBbTpI1VtUtXUeEwRSBBcLYgn3VFTI/jC/Ujx0+R
	 O8327q8kQ1I3DqL07JHLAD1E2PynmkvJd5Ad+Na9k2CYya3QfKUQD5UA7MbFj60l4y
	 6tK66DKpFWnG//vsAuVQiQWU8K9/rA4123TyvcxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 409/634] platform/x86: ibm_rtl: fix EBDA signature search pointer arithmetic
Date: Fri,  9 Jan 2026 12:41:27 +0100
Message-ID: <20260109112132.920075113@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 15dd100349b8526cbdf2de0ce3e72e700eb6c208 ]

The ibm_rtl_init() function searches for the signature but has a pointer
arithmetic error. The loop counter suggests searching at 4-byte intervals
but the implementation only advances by 1 byte per iteration.

Fix by properly advancing the pointer by sizeof(unsigned int) bytes
each iteration.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 35f0ce032b0f ("IBM Real-Time "SMI Free" mode driver -v7")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB78812D887A92DE3802D0D06EAFA9A@SYBPR01MB7881.ausprd01.prod.outlook.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ibm_rtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 5fc665f7d9b3..10cab7bdfe15 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -262,7 +262,7 @@ static int __init ibm_rtl_init(void) {
 	/* search for the _RTL_ signature at the start of the table */
 	for (i = 0 ; i < ebda_size/sizeof(unsigned int); i++) {
 		struct ibm_rtl_table __iomem * tmp;
-		tmp = (struct ibm_rtl_table __iomem *) (ebda_map+i);
+		tmp = (struct ibm_rtl_table __iomem *) (ebda_map + i*sizeof(unsigned int));
 		if ((readq(&tmp->signature) & RTL_MASK) == RTL_SIGNATURE) {
 			phys_addr_t addr;
 			unsigned int plen;
-- 
2.51.0



