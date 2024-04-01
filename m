Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8CA43AD6;
	Mon,  1 Apr 2024 16:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987993; cv=none; b=deK7FhdHKHcbDMR+bpESM3VD0G91R0qKZ4X9VFGcfJWEilpai5ijZUGcWfQ1Zuuf0CdA8TCaMHOWALVs28kdQKzdkDScAZyG4Hn4/1ZUoU1OCVXx/nws4MMmrf3NUqDXbxXUT8qGvTMPuaOVVC6STQOoYaGim+DwOO13+spl+Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987993; c=relaxed/simple;
	bh=YKM8kXrqF772kg0Naqydx0W9nTIFE6POdtLwJh4sns8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXl0w9u3+YWL4b7hU+7bBnvSgOMA6dWoXAGwMNR+HEjfoDijx9O2yA676HNV20av5BDy6Uk4SSt3K9gj0F+I1zGAEZw4DNiQI+Sj/LYCgGFdkFy5nDjRRbvao89U34it7niYGkEANPw6geJNi3ZkYvuDOsfu3u0qA0Uw3pTe5kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhMIxBZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhMIxBZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC36C433F1;
	Mon,  1 Apr 2024 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987992;
	bh=YKM8kXrqF772kg0Naqydx0W9nTIFE6POdtLwJh4sns8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhMIxBZrX7eAiH4dkWVW0LLyW5mkb6yRvuK2qSWHsR0cL14e3V+iQfo1woqVusV9o
	 n7c/tM2G5xRMdfWMTKe7bH7s3wXKO2TipCrxKXDemkKoMnMcNNO4RHTZnfYC/0WoAo
	 Heqnk0RXeMbTnpqacUthY0AM87NpdxH+nXXE1X+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stable@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 053/432] mtd: rawnand: meson: fix scrambling mode value in command macro
Date: Mon,  1 Apr 2024 17:40:40 +0200
Message-ID: <20240401152554.707595502@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 71ec4052e52a6..b3a881cbcd23b 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -63,7 +63,7 @@
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



