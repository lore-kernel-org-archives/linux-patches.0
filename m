Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047087;
	b=zD+nHv8eWrWZx9oPlO4yo6f15hq220KHngdwtVKUCNMDmSewzQMvZvBqQClW0AmCoJlx
	 x3CuiH/fa586om7FNa9ZJvdxLwDOdy3wgQ7jMqVn8/gtOJP5wesh3Tniv+WJCA85jOpMB
	 Slkzzd7uoBqluQwytFfyysSBbWiV+KCONB8MOLalmNRuc0vQoOmB95BlmZXKwJpaivdSR
	 gu5m+r+WDZP2BBd31hCi46FDydd7uT8SRJvuJruBiO8DwiXq6WaNPMpdIQyRt102HV7pv
	 UjzOjJFUgMxfwtVuMu8L1eNJ0r1FPEVhh2OmAUAnvZJ2MupGq7Ht/FaAUkWfrhmiEGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RmyLCAyJwOfzmVfhYPh/o9+0Od+VLsJqPuYXT4YnAao=;
	b=eMVdX+JiWfTOteEwo9DMSz/te8q/n++5+X2tbQN+wGhdSEQcjtYfP+hCVk1vVl5lrPdL
	 M+UTiz0AG1ikhfcyNqQGgkcQspGWC6tSc9mOXCnagkgUrAJPXEvBlOzTq5sdNAOP9YQ27
	 jQrpoGNjn8T1Vibc9KD0Bmwja1IyD9gmOL3NJGrwX8UNEArbsDboP0TU1tlmlpVGiatXV
	 kZAC7gKAzCkfjmeVSyCtZ+5oOm8NRTlEWBh0qghceSa1LWEJePvueUmJDRB8TUxsNBim6
	 3LR20kkoh/FQQWSCzw3/4kkZ87xsAqVQYddFE8GxFsVAtoYJD6ANY37K35byh3e3JCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RO2aoyQY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4539E606A31C;
	Thu, 19 Nov 2026 00:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RO2aoyQY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9376C1F000C4;
	Thu, 19 Nov 2026 00:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047087;
	bh=RmyLCAyJwOfzmVfhYPh/o9+0Od+VLsJqPuYXT4YnAao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RO2aoyQYAADYlXgKJzOK7DwM7ZtwgjRKb0zNp2RY2+KDZvsz0ms5Op4FYi3MrPXhj
	 W6zLvMNtU5Pg4ZF4yfD/zav28ujQeqPRj+1i9KSZNXlbIT+nfxphhz2/PRpV8Rsxsf
	 c3s3z6foM90flC5uhM+hgR9WDpopNYoIroNmsJAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1463/2857] serial: sc16is7xx: declare SPR/TLR/XOFF2 register as volatile
Date: Wed, 18 Nov 2026 15:41:37 +0100
Message-ID: <20261118150253.988048703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7e2f48ea0f331..ccac831bc69e2 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -534,6 +534,7 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 	case SC16IS7XX_IIR_REG:
 	case SC16IS7XX_LSR_REG:
 	case SC16IS7XX_MSR_REG:
+	case SC16IS7XX_SPR_REG: /* Shared address space with TLR & XOFF2 */
 	case SC16IS7XX_TXLVL_REG:
 	case SC16IS7XX_RXLVL_REG:
 	case SC16IS7XX_IOSTATE_REG:
-- 
2.53.0



