Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEFD414A1D;
	Sat, 12 Sep 2026 08:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202348; cv=none; b=UscBAsPqxAns+Ys0zbg/+qsW3mMRr6sjYHXCjtOCnErt/r6xIiRGLylQFEQjKRQcHHZ42ux3tPFLcchxnVZcl0l4IMc2xdyMT1avih1ilKgo+Ixt5C1ZqOFJhikM8J4LRY6kTe3Ucr576ekJUIQ3SyQUyATf6MryCUtg+IAORbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202348; c=relaxed/simple;
	bh=TVV5C6ysHjs72UjNWPq0ym+igb+n42LqYfVbz90iSis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqqnrzCVALpsJiEaoOB/CY5ppSH33SPi0pgrf6DZFnSD1k1bay1bIVmm4SPW7jX+o+ly4xIo9cL4+QyqikslB5AYmnPvp+NZhzRtPS48TuAEp1myDpEVNsrA6nJYuVcGaA8T/+dFK+1lREENM63N95MaKp93pnB54J7edCjM0yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLWEb7HR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLWEb7HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D2F1F000FF;
	Sat, 12 Sep 2026 08:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202347;
	bh=ElBMJrdr/xxWlzP3LuFnz1qCVpAP/Cmxl63taWrKEvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLWEb7HR1mbP6PntgFxvv4gwfIzbvSuUdI8EHVg9lXD7/pDc5YVPX7zAQj+AHDqfm
	 IGq1+qB7AAqtcUHJob5YQn2dhHktb2xRLMwseSIZ209Ef7SNWy4Yl5uwRc4g9caYCL
	 2qG7qgrwWojVwnQiWvfWt5pETECFERVnA/wg4Jww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Maxim Kochetkov <fido_max@inbox.ru>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1182/1815] soc: fsl: qe: check platform_driver_register() in qe_ic_of_init()
Date: Sat, 12 Sep 2026 08:48:52 +0200
Message-ID: <20260912065716.763589406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 943911053af68..bccc7d612009b 100644
--- a/drivers/soc/fsl/qe/qe_ic.c
+++ b/drivers/soc/fsl/qe/qe_ic.c
@@ -473,7 +473,6 @@ static struct platform_driver qe_ic_driver =
 
 static int __init qe_ic_of_init(void)
 {
-	platform_driver_register(&qe_ic_driver);
-	return 0;
+	return platform_driver_register(&qe_ic_driver);
 }
 subsys_initcall(qe_ic_of_init);
-- 
2.53.0



