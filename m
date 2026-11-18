Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023226;
	b=uNJJOVLCRvjHhexUvbeGFkcNftVeBdraaYvekr9w1s+17XFWCl29N/YfD06V5APKt64/
	 RohSSnwdhX7GdfguYbovn6neu1vEFGu5HwpV+qh5/YCJvXray7trvIo6XfrrceV0cNwQq
	 zQpGEBgVv7g4rT0jetGPQQUC9hYHlQt8vOofq+BAeLthMKFhQpsNv+9L4NC92EhwZWXF9
	 R367cQ/qdfBuE2lNF4/HyPNFKvkQ+j0UsBCTlYV1SsIPCW7u4J15kGSrTnwfAYiFs/3WO
	 WM+CrzUvgoKeZPUzxCRTJtk12eMc84uDUS3EMjf+jiH4BAMSGPQmhPa725u5T+VAvCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JKPIwsFwzjcoEEibB1hQ8mJKJ8lUBod2TeLp/KbU2/0=;
	b=UvYZn7WLZA8epKgaknTCb4M+n9f+GgeHkA4vbFXiIi0G8RxhWsE7Bfce8OfvREUY0/eN
	 0o4j1d4rki6zZwfyhZaOdxOVNfF+k3Vv5knsAJm2QWO0d8SN94kFp4G/xVjm40em4B1n4
	 y6tdSt6XFMq7lTrzAD3AoKZLrMgV8MeucmnQPjviFeWz9RHZezGGdrwE6iZB+Id9ltBlA
	 jmACyoP23kkx3sraukFmsXkoVQy2brk4BDlNthMGxyqojLr7cZvRANmKfC+h0lbPZyunw
	 4m5PiXd+gEIQYe97BTB/u9CYdPXip4rPKx002rB7IdosJ0KbIBbmgUxXzJp2uqK16JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSOlseQ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5862E606A31C;
	Wed, 18 Nov 2026 17:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSOlseQ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02CB1F000C9;
	Wed, 18 Nov 2026 17:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023226;
	bh=JKPIwsFwzjcoEEibB1hQ8mJKJ8lUBod2TeLp/KbU2/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSOlseQ3fLnmY3fZCk+QHj8KyLUHu8MaKqAanKrZWOl9+lPrnfIuRBDPP4eat49EO
	 B6XHZUn6amOsNAzHmdXhhNE9zaXRLXTivRyE+x/EnAVauvH+X12ruol2wOKbRn8qPm
	 VRUxEubzqSkySk6eShfKKP5EyRFZBNEgb60pp2Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0291/2151] mtd: spinand: Fix spinand_manufacturer_ops kernel-doc
Date: Wed, 18 Nov 2026 15:33:46 +0100
Message-ID: <20261118150132.503671251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 7e874b1750a40f3dc9a629aeb72eba09c77f77e9 ]

The kernel-doc heading for struct spinand_manufacturer_ops misspells
and truncates its name as manufacurer_ops. As a result, kernel-doc cannot
match the comment to the structure declaration.

Use the structure's actual name.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mtd/spinand.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index 07e4d87019c64..3f2229be0743b 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -328,7 +328,7 @@ struct spinand_devid {
 };
 
 /**
- * struct manufacurer_ops - SPI NAND manufacturer specific operations
+ * struct spinand_manufacturer_ops - SPI NAND manufacturer specific operations
  * @init: initialize a SPI NAND device
  * @cleanup: cleanup a SPI NAND device
  *
-- 
2.53.0



