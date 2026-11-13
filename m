Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590670;
	b=hF3V7JZfnovfm8S3OOvsf6OHw0us9Svd+qxOIhsbBUcfVXmLikW2tES420teG6WC7/mb
	 LnNca6OYnD75RfTCGnSh8blyeGq3HpVGXa066q1qmLCm+5ZmkxbgU7i/d/+4C/IDc14hC
	 kafyk9Q3L7cbxQxwr06EAIN8OemghTCdl5QlhBpEnrOemoTkScfxMMyJyTHxxEOezMdde
	 8wvUZJr3siUYTG+BUB2Xla0apQhnk1rCEQ8s29WPMiqwIe7NOYjLqAMP6wLFxd8xfVBd2
	 f8DQ340bPeVNh1pBvC6q7BlqKozmQi42VX1lChy4YddbT7beDTE0d1FbQHYmEZA3M3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CmDme0WiI6H6IYeTbW1YCSV01tiba0fST0e2pNQ9FPI=;
	b=3DtjU4xyFT3lM3LDIA/6W8dqDWI0qBb/9MBEhaTKgiASqiFv+U/C8HevKqjfYhw5PVig
	 mgcUk/AqjFiIQcmu2YbCC9t/PP0pKoulzzjeRu8DgYjU1UG2ra6OJyL1pBoG/06h03Car
	 0+drMwNU7KEZxHdNq47Rfbl6ZGuETBv5oZIXaPo9up213V0SQPwAQQchgNTnQkCdv07+Z
	 3z67qK3I4Svb1zJTojFNUTCtubbaVOWqZWxNlzThdxbhGvO5/BokEcbkjbGHQydgWn5KU
	 UQFZAumImbXFjVxGLWGm7aHwHMit7oV9fhJV1my1iDBUSaZkkNgZT8aqPg4z4uaNzCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnMuF+X0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A526C606B21B;
	Fri, 13 Nov 2026 17:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnMuF+X0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAA71F000C4;
	Fri, 13 Nov 2026 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590670;
	bh=CmDme0WiI6H6IYeTbW1YCSV01tiba0fST0e2pNQ9FPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnMuF+X0a0nkvBhiaktoOn6egXbprrFKaBYcEDWXNBSPBy1fzGlFOEGGupiwK7Fas
	 mH8uD6UNEWYhL1DLuzYf4/qUI4jSHgqOA6ytjYXG6tok8FN1ttTTgHw/TgF9xafuDj
	 g7xFR3vhNz5uCEJg4UsYZNK7UWmIKBfbMS7nVp0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 585/686] serial: sc16is7xx: declare SPR/TLR/XOFF2 register as volatile
Date: Fri, 13 Nov 2026 10:51:58 -0500
Message-ID: <20261113153841.635464006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 983f91e5f13149ade6dbd9568053ecd0ab5e9265 ]

SPR shares the same address space as TLR and XOFF2. If SPR or TLR were to
be used eventually, this could lead to incorrect read value from the cache.

Prevent this potential bug by declaring SPR/TLR/XOFF2 as volatile.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20251027142957.1032073-8-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c41d09dcd07 ("serial: sc16is7xx: declare MCR and IER as volatile registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 42ad926f1fe68..7cf3056b93939 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -542,6 +542,7 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 	case SC16IS7XX_IIR_REG:
 	case SC16IS7XX_LSR_REG:
 	case SC16IS7XX_MSR_REG:
+	case SC16IS7XX_SPR_REG: /* Shared address space with TLR & XOFF2 */
 	case SC16IS7XX_TXLVL_REG:
 	case SC16IS7XX_RXLVL_REG:
 	case SC16IS7XX_IOSTATE_REG:
-- 
2.53.0



