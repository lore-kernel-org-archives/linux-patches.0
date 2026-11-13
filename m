Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591461;
	b=TQMW8sWcBxcp37btTEadI/5cXXk/GEmnX7WPOzrRksouy/TwfG5EMEMrgMxTN0lyWWsA
	 22AgcmCl6xc46QLJgYsaBgKZCHGgR1ZRtLBmZwbfNECjbYld+1ePLnTs/pdYK8bIrhO/C
	 T942xdLtMAL54JrfFHq+4zgtD94s5E6swyCHdSitOVfqjrP7z+zHutihIxS0dFZlbeYDi
	 4Y6UuncMr5FN3MRW8SSvXVgoHNqrvYns7uckRqmPno8G4Cl/X9c2A0YK2ZDugYq0SNkmD
	 XWia2K2f29cpwhUTB4O5XgaEwE3vhSF7ABQ8t0YKAOlJqx2gpgeKNPxAcbwS+mTPwQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8q/Rh9S5uJuFdvjQpm7yfRhXrYRjePefN8zwP6dAgzM=;
	b=15hMa1L6Td7DFi18kqlkNJLk5YFhetJeZP40oRooP0lL2nA096KvnCAq9pPaBs8ZCDy8
	 9+zAgeJKV9d0yZSabIlqFPlkSD0O/QXWJo7W8rGZxgNsuKlhB/k8O1BPdNQiPk3rrOtI9
	 A5GB/5tzGO/zpYSImb39I3ABmnxOha6QxP1f8iuVNw7UwNv5zdBepv5S6TFycgbZ32bp5
	 Lqz9L/QDXSD+FwoyL0MkUJP6b9q+mFIYYYW2DybelX2vF44kBfkfb8bEk3C2fRKqEp3B2
	 GmsHlqyoc7sxJTmb1AyfB8mAz855P+K5PDzG/5mgU48YFR8JvtDlXfJqOdPQpePG+kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yI/tYtod";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29521607C37D;
	Fri, 13 Nov 2026 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yI/tYtod
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FD31F000C4;
	Fri, 13 Nov 2026 17:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591461;
	bh=8q/Rh9S5uJuFdvjQpm7yfRhXrYRjePefN8zwP6dAgzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yI/tYtodVHVTOuWeoksQG2PBW7VR6bQcQPOZ+17GDqRGBtxY9i21VGgO0ei3ZSCBI
	 ZdcogfI96WpK359/q/DO6GJPAqLVP3HtJiQK2SdYW1gheScFsAexMv7TfYehdRRTN9
	 vsYWbG9MpVkxBhEsZlD299DEENmY5IO6pc/+rMlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 546/670] serial: sc16is7xx: declare SPR/TLR/XOFF2 register as volatile
Date: Fri, 13 Nov 2026 10:51:50 -0500
Message-ID: <20261113153830.392849862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 942d12f40a394..bd38a2efd34ec 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -539,6 +539,7 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 	case SC16IS7XX_IIR_REG:
 	case SC16IS7XX_LSR_REG:
 	case SC16IS7XX_MSR_REG:
+	case SC16IS7XX_SPR_REG: /* Shared address space with TLR & XOFF2 */
 	case SC16IS7XX_TXLVL_REG:
 	case SC16IS7XX_RXLVL_REG:
 	case SC16IS7XX_IOSTATE_REG:
-- 
2.53.0



