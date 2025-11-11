Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A29E246333;
	Tue, 11 Nov 2025 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822562; cv=none; b=TFZ2Y7mPqCmg0TWIFYN6ucm4bao2YeF7PMaDla1K7lIKIGM3EmMjXNr2v/HOT5KcC6BVsVZW/7mR8Z2FMbMs8S1QmuFNcZhsrXAJSObiw6mq81PHDKBwNTYD8ZOHRNG9ASlkdNFt2otHCqoCbupl3WcMIPiGIaOlQM2QGi2zSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822562; c=relaxed/simple;
	bh=f/+At7dNsiIsE4evDk/PILSqjW0NYc5lYqnyuIYnD2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZImPnz92Iv3fJ+g6vQ+uiXLnbO5I4dGHtt4DkXe+BHiRFDCLcaezpfJCunsx1SemGyeRs8+O+n/0gq42ievYiYn26nicyXlPWh8paQyZJtG5TFpl2ozoBJ9qZ97OAXIOLlyleiBqJ2Q3D0STxqZDtyCgtNUDHoVUh5WaquwaX30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilr6UHfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilr6UHfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4EDC113D0;
	Tue, 11 Nov 2025 00:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822562;
	bh=f/+At7dNsiIsE4evDk/PILSqjW0NYc5lYqnyuIYnD2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilr6UHfBCM09rHxGXzyr/DvZrcc6WMIYgpOKn4mpdRgK9u8zGBvUddBWgL7rBEUbQ
	 t+oMgDVyxFWgALnRsPIL829gdhYxDXA0xEyWo0U2KufylnW8qV0x6RfoRjOm0HA9qH
	 mx8yQFVHJusl1cjQ/Ep44TNl6VobtnrSmRHwBDM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 123/849] soc: ti: pruss: dont use %pK through printk
Date: Tue, 11 Nov 2025 09:34:53 +0900
Message-ID: <20251111004539.369465931@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit a5039648f86424885aae37f03dc39bc9cb972ecb ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250811-restricted-pointers-soc-v2-1-7af7ed993546@linutronix.de
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/pruss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index d7634bf5413a3..038576805bfa0 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -449,7 +449,7 @@ static int pruss_of_setup_memories(struct device *dev, struct pruss *pruss)
 		pruss->mem_regions[i].pa = res.start;
 		pruss->mem_regions[i].size = resource_size(&res);
 
-		dev_dbg(dev, "memory %8s: pa %pa size 0x%zx va %pK\n",
+		dev_dbg(dev, "memory %8s: pa %pa size 0x%zx va %p\n",
 			mem_names[i], &pruss->mem_regions[i].pa,
 			pruss->mem_regions[i].size, pruss->mem_regions[i].va);
 	}
-- 
2.51.0



