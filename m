Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043041;
	b=07vnsEvlF7ucnUXSWrOIiZPKmCbXp7sI3G5Z/SCvlJH6nPRf4LJ7leiZmWAIRGrkibqC
	 cMo6fcsVRVjmAElLvnP09HA4JTAEvTJb5iLq7fnLpWDKUOopPUxjAvoxXNCZBq6XVzm7l
	 e3EcMLpHZY0DLVmTVXp8nyVC6/eKGDPyb22z712PFjO+y2HnsUP4LDEQ4KBhAFxarZWW1
	 kWq3A8utMTfMxlE/jE/j/E/DCjVlheNXxy/pXiw2+WXFmqn6b007ZG0k/BHz8pWb5ibPo
	 6+zpOXUCUMltnm6Uxah6512rIjpEE9NPQVSLq8EnMCsnLjzMuaGcc+xPm9wYG9l/Uyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7DDMnC4iH+db0QAuYPYGyc2LYLveZXy+YfYbl3to7AU=;
	b=OlEaugGGr+k0G/EPraLYpmSNHFqBi7L22DY6Yq6tIMab8H4WG8t2ofL+zHQsCBBJozsW
	 bG1fhRVmX0ARhGxpBy+dL0IaiK8/n6+qtI5xKnca+OmVjhM1hTsKGnyVBhEfLbqn0+67K
	 rhsgD2Iehuerlf0CNGJ0M5G0xMlBzod6ilQG3J4YBH5rO3RtKdFJ74ZUHlG2wCNDAhBXu
	 0QiNUv1URYCU5+cKzv2kownovlpojNWfuaR0eAUvuU3r6nz8F/FNrggqzfM01RFRKYE4k
	 /VNCdUxgUUJm+ReK2gyR84Uv5EJsMdWAtcVe/qILvOuxyZ5MYHnijdWPrfvHE0EDekw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9oEyvLB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4C160A2618;
	Wed, 18 Nov 2026 23:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9oEyvLB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070501F000CA;
	Wed, 18 Nov 2026 23:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043041;
	bh=7DDMnC4iH+db0QAuYPYGyc2LYLveZXy+YfYbl3to7AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9oEyvLBRJrQWFDwJqsbU3eDqb5cX6O3qmYV2bZKmtYTWAOxoXu7Aojx3PRKtbtAD
	 1fsbFQ8x50ZQ3DAJYCejsdsAo9+2Cz6kGb64yNLXERum+qDSUFhPkIBWuDrm9Ab7nl
	 RFspZNrBu11ulkLA+ddh8opykx8UQ4yLTZIsHKnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0070/2857] media: cec: tegra: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:18:24 +0100
Message-ID: <20261118150203.840840674@linuxfoundation.org>
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



