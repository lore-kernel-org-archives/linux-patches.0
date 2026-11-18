Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051028;
	b=gEbLEsTtAvRD1l9Ub2yg0Agag+bGd8G9ofTVE2OzgbDhZcl3mPnqbJ6BHub1hrhLc1X8
	 fmOZ+4PcNy0elJ24sXBCJen6PppU9ShqVCX7Q0jClEJJNp1W+SqArcXVRib1L+B6qN2c+
	 hHKwyZzdxjQZIr6T7c+UzRQGzXNt9pBFACS33phXv8lMQi0pY5INE4ye3KBnc72zIq6mD
	 CNUbZlhnhACMo+5MQwTOocbnUl8/TkgO6vYWFPQuueUKyiG9xgojySEt3AF+Kk3ovG7QZ
	 zGer4sRKpjyUN0UspLquuJiM265UXh3U1vrKLT9wnI/TqWrMjciW+6gCZBxwYhp7BAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bEcxDeTYlDjwzqk3g8pVU1f1s8DK812vcL6N3dZknno=;
	b=g0J3JoAmK9TkPdI2WmATWdao6TeTQ3zdGN+ZQnWk3iZBOw9dmddxTOmzm9KBUFVUJ9di
	 Hjjqn3cT6IV026haeNM/U7ODRBBA0GJCAmoxWczjf3hxjuv/VHakPkl8h+Hh5PmHAnkkC
	 6mUMZN6LlvewRyOieSmO8dOExBB09cLB3GLvClApDMC7QzEboiQqiVVPMzA32YVZjkxlG
	 hIdyY9I33wLqoHwMeSuuMhSSTs4RoAMoIaUf0852uMSS1DMdcYQhfAwS7tFw5Zj3twbDn
	 5cB94EryiqJuXArIUGVRjIlE+Hw50gTCSiw6TwezmF21cw+JjrOFlwauJ4r+Gn2nvEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8Bz1Tzm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C6F606A325;
	Thu, 19 Nov 2026 01:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8Bz1Tzm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BB01F000C4;
	Thu, 19 Nov 2026 01:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051028;
	bh=bEcxDeTYlDjwzqk3g8pVU1f1s8DK812vcL6N3dZknno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8Bz1Tzm6BSW2e7iQAo2/bTEnElydAYRlFBMHGiLvn9cCqbFXWzrh8vXaLgYCS+GE
	 rvvCMkao4oHONn5aSCOFv8y6JGJ1LQjTa35rVbLwVAScB5LItwz8v/YPYhK0QAPOp9
	 TX4i5Ls48Lt4x9CgQEG6kRy5LYgeToXQXf+EZlvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0063/2214] media: cec: tegra: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:28:59 +0100
Message-ID: <20261118150012.537836760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8dcf23edaf4bdf22259f6a47cfddc8bb1467425c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/tegra/tegra_cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index 5e907395ca2e5..43fe54f792b65 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -460,6 +460,7 @@ static const struct of_device_id tegra_cec_of_match[] = {
 	{ .compatible = "nvidia,tegra210-cec", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tegra_cec_of_match);
 
 static struct platform_driver tegra_cec_driver = {
 	.driver = {
-- 
2.53.0



