Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023406;
	b=rNYwJYTr54DOjuZbXLJjh/WAZoxK96ZCxUQQmZxKqrbHYBZzlKJUatiOobNE6xK032x0
	 avoz37+zSFOmv8lAI/tw+i8sVLfm5HeS3E97XlBI2QXZce/c/kjellactnQEgzRIw0pIC
	 ikZxdmPfCtb8EjgbK3Z46rFZRxUFx7fdgBcKuKkpDHREqCaUqOfkePxTyBtb6Bu30ufIu
	 xrLswC6IGwfoHQAjCz9wIX/F0kwg/9P7JJfn2NULvfCXXvU8stWBTiUVJoazYJ7sYg8ES
	 ArUS0V9SfRnBBk89egcASe9t4oJflXHF4jGhQ6xXrQ3vBtLpppPkVec/EWSBKgWJc1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ixHlJciRFJTrP8qJZ8jI8sI4dkB3qMJSST8L2A2E6T0=;
	b=qeT9D337ZjdpiWjMu5wg87KRmvVpvtuOovsBqIx0VzSnH0Mz7iQg5ePCtZ4iJKGnws9n
	 knpwzMyv/dI9KbH74P1nRpHbST1GIWlLdrDzwCH6V/4WAAGHRQI6h0PkZ4L6WIAWA4oUR
	 O2ha31WDlOQp3YJrRB76qYBnA3ijHbTjIoKg/o2zazLNnKmW31fjFc+9D0dchpt9LE7/9
	 JWz1FiBARoyogMQWIyE6fUlvI6f9kik4PcQfsntXRucui9+3GdLx5IoPYOLnjStpEpzWL
	 G3lw18wyYaPQzMLlQu6o+bBtsHsd6Ynzpy1jP8Pb9b/Ok3KmJVUXquOR/ybVHTMCjoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTIrtors;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95226606A31C;
	Wed, 18 Nov 2026 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTIrtors
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E681B1F000C4;
	Wed, 18 Nov 2026 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023406;
	bh=ixHlJciRFJTrP8qJZ8jI8sI4dkB3qMJSST8L2A2E6T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTIrtorslUq+n2flPmr+2OeYFemxS8dX5IVnnQKpAHSwCSdJZBoxPN2FvDbmbj52n
	 OSxQv1YRysHcIUjYlcDZ0nLuNIDz4mC/GlCwFJbGiC95iPugQiijpVQCAx0c92yY78
	 yAXQiNmWFzc2TrgsguebjMGAFWaTI3fstWPMWHp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0358/2151] usb: musb: da8xx: depopulate OF children on remove
Date: Wed, 18 Nov 2026 15:34:53 +0100
Message-ID: <20261118150135.145996608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 4b30c89fb36924983be652bb24fc49e20390bf27 ]

da8xx_probe() creates CPPI platform devices with of_platform_populate(),
but da8xx_remove() unregisters only the separately created MUSB device and
the generic PHY. The OF children therefore remain registered after the
glue driver is unbound.

Pair the successful population with of_platform_depopulate() during remove.
Unregister the MUSB device first because it reuses the parent DT node but
was not created by of_platform_populate().

Fixes: d6299b6efbf6 ("usb: musb: Add support of CPPI 4.1 DMA controller to DA8xx")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260813153353.42817-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/da8xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 4209f438ba184..7cefac2e5ef8a 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -592,6 +592,7 @@ static void da8xx_remove(struct platform_device *pdev)
 	struct da8xx_glue		*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
+	of_platform_depopulate(&pdev->dev);
 	usb_phy_generic_unregister(glue->usb_phy);
 }
 
-- 
2.53.0



