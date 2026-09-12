Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEAC36B924;
	Sat, 12 Sep 2026 12:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217479; cv=none; b=ic9OAX4gTRISFyiQbWNlYgrnmR9Qz/GBVz7gdO1f/EZiN5vz5uy6otu/fFuPc42Awp2K6/7kd837wN7xkMnzh7y86ehmyulz+jkB2x+uQ4WG/tDy8NP4alFiKO2rDiIUlikNh37C0+AVJMTcrOonbdJr/0ID6k01qOPTyRceMSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217479; c=relaxed/simple;
	bh=nekY0wl+ZAmlcxk+EYtPMriRLfGlu6Tv4Akt7ZesO48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIdwGnBJWX4oTwH0p0K1EY4V32cNCbnAtY4itChSctyokISsIEXx3PzgoEtzlVltHYajWuwbHMyc55/k/WHnTW/ISbQ3aKJGN1PcM9OIuySXXubEfDUHoaKnznxHAaT7kPj5GGhDPd2HfFwZfm2YRqiHZX3OinTtBzQ9ESE1SNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLJAR3m0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLJAR3m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2D91F000FF;
	Sat, 12 Sep 2026 12:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217477;
	bh=TPK+220O6bwD/T1douiBc2wfitqVsbNIVljgZ9TWxOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLJAR3m0osdoadTjfzRuCLqCZoTuGvJf0zkNdmvlL/szzKR/1++DmXQWjOhvBPt5i
	 9dbXFvIU9bquGc+cqYiLaHW+hXNqYiqB1BBDc8B6KmwWrnjU8i9Kp4x5U5mIuRmiVi
	 HHZPfw//mT820KIsbLwJrkuDJfhFvfaX54/RM/ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Maxim Kochetkov <fido_max@inbox.ru>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0949/1376] soc: fsl: qe: check platform_driver_register() in qe_ic_of_init()
Date: Sat, 12 Sep 2026 08:56:15 +0200
Message-ID: <20260912065628.711244902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



