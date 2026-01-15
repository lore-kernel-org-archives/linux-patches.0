Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E303D4123;
	Thu, 15 Jan 2026 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499585; cv=none; b=scJ0U+9cWlbO6qMX2qIFPv3E5vAGq6w9Xb0MggjtEks9ExLw2rNyiwybt6913K9wnzsotegWKh0fQW8xbUbryF7+tGiXXZqtT1u7cArwaNDA+Z0PPyVGi0hG1lwvYJswTyc7kU2odrX7CZ9kqIaBfF/yk4B2mQ7ZYaj7O1gpgoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499585; c=relaxed/simple;
	bh=cPCjDMwIG+2Jaz7R5bBTmcQkqX9SfjfstTs9URvFaiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejLQh+8RPEaW0Nu9cXHR0xEaUFvV+z/ua4K9VMrM/Ctd+/77Do/9Rm1gxafXaa8rxoBHBl9JfvsGhSL2xYe39fypHzfNipLgvTPrBFCeC0hoRsfoMu8J7gU6nkwS/Jb8GA75IasxXLsO6qUwpnQYNT2ULWdrpHrHTGNwEyW2WIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0b7Xwa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0b7Xwa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8378C116D0;
	Thu, 15 Jan 2026 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499585;
	bh=cPCjDMwIG+2Jaz7R5bBTmcQkqX9SfjfstTs9URvFaiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0b7Xwa7bn/XR3ZjwTWfAHgcTCfYlc1OlzA0trLEcubCUk3muRec852sAwvse8o1r
	 HkEGKQxofhh5UT12I6D6JPW+DW1VHey6YOi1mNZKOcguDG9rzXWZa6CgjNkzk+R+6t
	 5ouz4CchnTV3jx2rxNfkpzatgSIWzC4gp00Vo3y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/451] platform/x86: ibm_rtl: fix EBDA signature search pointer arithmetic
Date: Thu, 15 Jan 2026 17:48:00 +0100
Message-ID: <20260115164240.975831194@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



