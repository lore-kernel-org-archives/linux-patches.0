Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE0530C143;
	Thu, 30 Jul 2026 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423570; cv=none; b=H/pg7C5Gq4utPylW6ze3AG69pDvRm7/JkmvFgQaAAUpYD8CouDcoQnn4r05m417E6Vn3xMqC5bibqvZKRXUoVBbL+8uuu9b/OWXoE5cygUiTz70mpIhfhN64lT+I2zH6xq9x36MceeC3bDie98KFy7DTeunM6Gu7VOJCvahOS+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423570; c=relaxed/simple;
	bh=4YURQmy7vt1txGZcVenruGa4EwIJHkiBpzVMHD/QeCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q69YFCjof7Ef1+SeEV0E9ez5yGbLok2l4T1+nExhf6hdvGbcRWmXz64FNzGRcl0Smpvx/fHbwGmS+ExVsitgyhgAppxI5Vk1SY6y9JvM/9Uj5HOBLmV7jXpOW52GkNHeYdAY3RkROvGHhHCx7O+n7zKmzDmSqOSasMJwMBQQe2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOz0PfpU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOz0PfpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7968D1F000E9;
	Thu, 30 Jul 2026 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423569;
	bh=aepby+4W0XfNzhls9rPjVMQ6mCKb6ecW6tUkEA8jTzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOz0PfpUUrSF4MOuAx1alOMZEVtWZeyAZ3Rgj+W7F4Zr0VZSIskdGVtMGS/6kllBL
	 NiqZAZ1dDPRQ4P7gNItrtzLa2cPFBd/3UKpYCP2Gy89m30U7Nguljw+88+mPMzfkLy
	 U6awg9jBvwKpP3s+M2hUBD3Kz7nujFPIo1nMV3Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/675] ASoC: amd: ps: replace bitwise OR with logical OR in IRQ return check
Date: Thu, 30 Jul 2026 16:07:01 +0200
Message-ID: <20260730141447.062915711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit dec5aaa27603e1d7b426ce3504af6d1a62e4d444 ]

The condition 'irq_flag | wake_irq_flag' uses bitwise OR to combine two
integer flags that are used as booleans. Replace with logical OR '||' to
correctly express the intended boolean check.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Fixes: 7f91f012c1df0 ("ASoC: amd: ps: fix for irq handler return status")
Link: https://patch.msgid.link/20260707060130.2514138-4-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index 8f37c250d4b895..cf06d4ae299b51 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -248,7 +248,7 @@ static irqreturn_t acp63_irq_handler(int irq, void *dev_id)
 	if (sdw_dma_irq_flag)
 		return IRQ_WAKE_THREAD;
 
-	if (irq_flag | wake_irq_flag)
+	if (irq_flag || wake_irq_flag)
 		return IRQ_HANDLED;
 	else
 		return IRQ_NONE;
-- 
2.53.0



