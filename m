Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBE245DF77;
	Sat, 12 Sep 2026 10:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210096; cv=none; b=Hp8kFT8FvaIMwFbcTqHPpR23c57SJRhYT+NAljLVXa1QA2G7jbDsIb1Re1lkpOHv982uRz/r//I/5MuIDSBQUu3GyQ8oo2kinXvNFwYOyMwqn5B/MrM2F43xsUlUV0V+gE7cUUuvPc4A0VKQREu938W50/NEmCln1FyMcYQBzsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210096; c=relaxed/simple;
	bh=/4gvnRSbu3tbgPVuAoMroZ5VbcKbhJGlJzhEqciksv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8N08ry13I/+VYCopER6Gn0SwmDJcCmlc12Iq611bBSdO5KvTaxJwp07Qld8Z6AA7gPJ7wreq2SaFOU5VVlvYprAfBIRUzb1CS6gS0xGLwDkbOicwXib/Em3PKuAwrLiOXiWXHeza9j4raR204otdZqwDBkXQn0Lk7iBV2+TTA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAo7QGu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAo7QGu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9537A1F000FF;
	Sat, 12 Sep 2026 10:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210094;
	bh=VR5ZR75C4G+xTwIpk2ltYeyJICpMHLHup6VJUcDB3sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAo7QGu8JmKMoWMmT/do3tCkHyvNsN5NT+PEOI/OYHS+t13VNG1z63Ai1u3VH9EvU
	 aeVWZzN5JhA/FtvmQDJ89I+pLXb+RfyIFf1j2j+zwjS8tBBhSfYwbLMvMEF74OGuav
	 7o+nyDAUL3692VHToaAkwVnOrVl2j6PfZOLfbLE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Maxim Kochetkov <fido_max@inbox.ru>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0955/1518] soc: fsl: qe: check platform_driver_register() in qe_ic_of_init()
Date: Sat, 12 Sep 2026 08:52:04 +0200
Message-ID: <20260912065645.061450450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



