Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8009A147C89;
	Wed, 19 Jun 2024 13:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804107; cv=none; b=BjIRb8Y6+FvUAwTcY+uAqA1EvE+LP5ZKyvk1GG5V5oeDmU/IZE3sms7Ziua0d+07zsrFcbV4ruxKFoDAUaEkscEkHetxlPuqAnDu30fRaid18gv/LM2sJmvdKJwrky9LzRP7PFjtAHMSFesVGe4itwt7M+cCCltXbyMZflRwaEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804107; c=relaxed/simple;
	bh=fpjMYYj+hmmjJXtvuIaZQNIjg4DbRZRfqzEHchaxWFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0KLYY9wxQTtXeU86ijLtLKl5kyeUayQ7yICxkPa0+wnfekB9n47imkmk8A0Yb/AtT3A3aFZTKma9zwIR5LPcHSjWPoWbyj7zYTLam+FsTfm992WxlVcmQW2SAccWzG8wgjChz26HlV5Cl8UXx59lqrZYTWxlrf8ar4Zf1t3vNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlPN3Hvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlPN3Hvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A7BC4AF49;
	Wed, 19 Jun 2024 13:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804107;
	bh=fpjMYYj+hmmjJXtvuIaZQNIjg4DbRZRfqzEHchaxWFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlPN3Hvr/mC2KlamLS55nI23vmOS4Pu8xSX8hDd18UOU8jznsm9B5J+VP+jc6Z/gA
	 dvJFxLhj29XNRKfRVgYFzISbJXBcPBNnk1DAT6kwe0LllQgTSQj2ufe+HZtKY/+hlk
	 jAfnVdj3hrMmH5PNXgR7ydxF40CzphUcD2Zgh2lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/217] serial: core: Add UPIO_UNKNOWN constant for unknown port type
Date: Wed, 19 Jun 2024 14:57:35 +0200
Message-ID: <20240619125604.873875942@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 79d713baf63c8f23cc58b304c40be33d64a12aaf ]

In some APIs we would like to assign the special value to iotype
and compare against it in another places. Introduce UPIO_UNKNOWN
for this purpose.

Note, we can't use 0, because it's a valid value for IO port access.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240304123035.758700-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 87d80bfbd577 ("serial: 8250_dw: Don't use struct dw8250_data outside of 8250_dw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/serial_core.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 13bf20242b61a..1c9b3f27f2d36 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -467,6 +467,7 @@ struct uart_port {
 	unsigned char		iotype;			/* io access style */
 	unsigned char		quirks;			/* internal quirks */
 
+#define UPIO_UNKNOWN		((unsigned char)~0U)	/* UCHAR_MAX */
 #define UPIO_PORT		(SERIAL_IO_PORT)	/* 8b I/O port access */
 #define UPIO_HUB6		(SERIAL_IO_HUB6)	/* Hub6 ISA card */
 #define UPIO_MEM		(SERIAL_IO_MEM)		/* driver-specific */
-- 
2.43.0



