Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053130;
	b=Ip+mYNu+iEsDd1HnfwbvWQ1N5w36EAnhbOicF4fXVZJF3DDSUWewFMrHLD5Mdx4XiEgX
	 y7wYWwApM5npV7NK5DYjTfH6rss35LZBtaT2i52DkIFqXdJlFvg5tEnXTfGz02tPaHxVy
	 x8gbCbgLMTWwIJc8Q9CRKUG7PoyNz86dr6ssgTU/5wxcoVdUkfkJ8NuwZmNJ7t6skqsOV
	 dLIjTDJIS2mNSLKcW0ZrSc59DTQrS1EiqfH6c1g+Ou9XvtXJHIBgCfvGdP1ZniAGtLr7P
	 e4xj8w/SAsRuEISpdlCILktO0S8VFpSJKF+ZZEySQWm5402mQtk5VtBTZ8EJi17AA6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q6l2A5cSwyXzk4nSWKxdWsk1PreQ+tKUz4Hjfj9C2gk=;
	b=3Gghh7c+HQE3+YEOZ0K+RrBzcyiHcJcui1Bl5zE90yZCHuAFpNENe8zxAbIBguFTEsqu
	 IpbMCeAbxL4fvIFzgDr2beQ6XFx3kwaA3lqr9TNmoGYlv2GeBrvlqRKSy1FNnxozv9PqY
	 BejljT/lO+U/nCOi8LflCyOTPL9ZauqEzkVJr646Fe+hYdIKP6/FOxZPa10O+oIt6g5Uh
	 LFF1S8Dg0X7BnhH++s5glai/PYmml1bG/C8MCxk54HO6UqXcNuqSqQEmdvClSJV+2LJjf
	 bl65hd1EL9BIFKV49UIEOFZvZjVR9q0QAIzxgdNqo4FUV9obU2DR+Fb4MUdi1ardAIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dvd411py;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30832606A320;
	Thu, 19 Nov 2026 01:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dvd411py
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA501F000C4;
	Thu, 19 Nov 2026 01:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053130;
	bh=Q6l2A5cSwyXzk4nSWKxdWsk1PreQ+tKUz4Hjfj9C2gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dvd411pyt0k0B+fRk0mR0UycZyWHikG8zVjQsjnXRQ+FFmjuy01FfKs6nPANACVoK
	 01zTUMV7oV3UZPDOObLehQ6tBRsxPQh3cQeU9PpmMnFI/FqS0EIwlFIv75IFsi0AbD
	 lvIEjUJc8UG/nLo4ciwUba6xqTNXCeQsLluqXy/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0810/2214] mtd: rawnand: ndfc: fix gcc uninitialized var
Date: Wed, 18 Nov 2026 15:41:26 +0100
Message-ID: <20261118150043.869514353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit cceca8cb776b03e83985578f84bd730c30d57f70 ]

Now that this can be built with COMPILE_TEST, an unassigned variable was
found. Set to 0 to fix the W=1 error under GCC.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606141301.iyVdFgl7-lkp@intel.com/
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ndfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index a35be06378662..3172ab459c9d9 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -197,7 +197,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	const __be32 *reg;
 	u32 ccr;
 	u32 cs;
-	int err, len;
+	int err, len = 0;
 
 	/* Read the reg property to get the chip select */
 	reg = of_get_property(ofdev->dev.of_node, "reg", &len);
-- 
2.53.0



