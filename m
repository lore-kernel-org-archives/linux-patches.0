Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D4C148314;
	Thu, 11 Apr 2024 10:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831512; cv=none; b=ZzMdYx0w+nHR0eYqTSVMnuYsEmKn9dAjQHE5w+OmZRngcG99lcKZyu60EqMbOBA7YJ4U5dLWNKtZsa38QObT65TG76sbhg603rdp3njh82hLujtiy+3cGIjvkurNG7Win1obyBVk9GdfhVeJ5m65cdO5Yg7h0Vs2R6Ptmmb3omE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831512; c=relaxed/simple;
	bh=jocPX8oK6XLlIu/majadIPXMvUjD+HFuKuNkGXcoFp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkTZybNcrFaPKHx0fESxaSO8mgR3XFyHbtyODFpcPZMp6WqLu4xSlF121pYLSYzVia3yZeQFnXeGScOWF7NnhiuyGtSplDjAQZDqBXmTsirTxqmwD04fYhKLKe7bLzlx4riLBD5rcGh9lI4WhTKqxlwwlvH8SGhzjC0q2fOuVUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psoyzSx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psoyzSx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306A4C433C7;
	Thu, 11 Apr 2024 10:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831512;
	bh=jocPX8oK6XLlIu/majadIPXMvUjD+HFuKuNkGXcoFp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psoyzSx/qnMCmjBJuEOu0U4D8VyXWLxj11URPDtx0xk9UmZsi6Q6k5PTtHBOYSGBM
	 ARo5/0ifwJlNCiIB2VnmqRdYcfJTvyYqv/dzRd/NiFW7Je7ydou5Zy8tbTDH4NiEIa
	 WhOVCwM+M4OAkolP1KVFFnXbHl+0EZKWlBLT+iHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stable@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/294] mtd: rawnand: meson: fix scrambling mode value in command macro
Date: Thu, 11 Apr 2024 11:53:17 +0200
Message-ID: <20240411095436.663854752@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

[ Upstream commit ef6f463599e16924cdd02ce5056ab52879dc008c ]

Scrambling mode is enabled by value (1 << 19). NFC_CMD_SCRAMBLER_ENABLE
is already (1 << 19), so there is no need to shift it again in CMDRWGEN
macro.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: <Stable@vger.kernel.org>
Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240210214551.441610-1-avkrasnov@salutedevices.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 6bb0fca4a91d0..9a64190f30e9b 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -59,7 +59,7 @@
 #define CMDRWGEN(cmd_dir, ran, bch, short_mode, page_size, pages)	\
 	(								\
 		(cmd_dir)			|			\
-		((ran) << 19)			|			\
+		(ran)				|			\
 		((bch) << 14)			|			\
 		((short_mode) << 13)		|			\
 		(((page_size) & 0x7f) << 6)	|			\
-- 
2.43.0



