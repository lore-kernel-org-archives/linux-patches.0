Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1190C3290D1;
	Sat, 12 Sep 2026 16:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231039; cv=none; b=stz3MRLaVR69SyXLpWM0HJ6PaG7tVk1ekEo0ePbpTOLRmqZ/Q4x1cYLqGbSQYTyDNZFyVaz5N1xtrRl+cItZNFQ3sA5+jG6YYxQKX5mKmKdZCpqwZPAWcldV6AK6N9zecvwD2VMYD0AJ9Fa675IDmeVYqzdOMwXQw5Kl63BGzFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231039; c=relaxed/simple;
	bh=Y+cvxsl5HWcQReWHlciXkQMgQFJrQrx512NQVe/NeIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwfWUbciV8s2s5Ps6Zo14FvcbBl5+mfMUM4l6DX1AQpru1wpm1weSG/Fl/qXUdTwJfezu+jMoCJw2cLuIVSvW2oJ6s20LOa3R68l498Fip1M2O3olV3YjevNtPDX2A9NhfMBfCEk46wJi7c8K7FtztxZLvCtx0cuLWvSnQRfqeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOr+jedI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOr+jedI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03B11F000FF;
	Sat, 12 Sep 2026 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231038;
	bh=e8WizM2mBWHioaNexRrJfz8OQ9uAhhLzsdiyzlk+gaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOr+jedIW0Je0pksbLFyC00pY+aH5P/vfZ4xOv5nF5jYWeiYu2UqtJ/ue+NaZoIR4
	 jwCMQkiCQQF9KW6DAoN4oHo307icSaxLxskgVQxAzXvKdHE34TBj9dx+Z9x3VmUVB4
	 WmZxx0uNX1euz1AvsF8mqE33wUficRV8PLlXi6BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Maxim Kochetkov <fido_max@inbox.ru>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0915/1191] soc: fsl: qe: check platform_driver_register() in qe_ic_of_init()
Date: Sat, 12 Sep 2026 09:00:43 +0200
Message-ID: <20260912065608.785274247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit fbdba2a67fa7c0e7570bcbf9f28b782d6100270d ]

qe_ic_of_init() ignored the return value of platform_driver_register()
and always returned success. Propagate the error to the initcall.

Fixes: be7ecbd240b2 ("soc: fsl: qe: convert QE interrupt controller to platform_device")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
Link: https://lore.kernel.org/r/20260731094608.1883391-1-gonglinkai@kylinos.cn
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qe_ic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/soc/fsl/qe/qe_ic.c b/drivers/soc/fsl/qe/qe_ic.c
index bbae3d39c7bed..f17de6000ff24 100644
--- a/drivers/soc/fsl/qe/qe_ic.c
+++ b/drivers/soc/fsl/qe/qe_ic.c
@@ -481,7 +481,6 @@ static struct platform_driver qe_ic_driver =
 
 static int __init qe_ic_of_init(void)
 {
-	platform_driver_register(&qe_ic_driver);
-	return 0;
+	return platform_driver_register(&qe_ic_driver);
 }
 subsys_initcall(qe_ic_of_init);
-- 
2.53.0



