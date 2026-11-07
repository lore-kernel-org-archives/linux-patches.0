Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060668;
	b=1P0NOW/rURw9/tBvsJ1LoqJlbukowbU+TdeBeY0MSJIlJyf+NacmqCfypJN6FQz09RkQ
	 f/A8+gDJjuPoVl2SWK5l2y6jnKxxDvfmkwuozgVb9HEXQJHOhwo7DE3+UQIuP0uGACNq+
	 faeWHJoCayd575fLn8OD71pyhn1szOt+Z4DaYUoI/uoSq+gM8s1zWCNTR4ENjoMw1Wa9X
	 tX38dB1NC+IANKwP+HLPJJap/uyFLnF4CXidHIkw8uy1c/nAk09XqLm73ooKJl/PdKxr/
	 zjXYicEQG39tneV5AFgYhySz7WNed6C7DukXEkhFNjm4UdEkb3hV7bB0qa+YfWGrB8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tek+4DUMZJb0AlR7evK5EED1255fOjaJm5pMKFeiDl8=;
	b=bpbHCl0a+cwVFiCtEQOgnZYsJeZoWXcLMgdVKQAqCFdVJsdJ57L4SnaVctOdNcbvC9p1
	 PNBDTrtm/PYIwrUMgP9DwFkBZ0dzTrPmmyYIIFZHFKFYeBNiNkj9yAbZ8nwj6ve4PSd2x
	 gxt+z1fJVakjwMLN1hL6koDlaCroNGHhD+KzPuDC3uACb2vfdlCTCOlu8vuYqO2c6sLGa
	 duGYr4kJ+tRXmKmIzAcEwpRQltNC6aKQe8/QFW5ZM+JT1WrLRaubnED1iC1yZLXRBK2dV
	 FEz933I3TV59cW9hYVXNYUELbDBtPYGfWg1oZkkHbxG/wEgK57aNya+7/eOryp3JYfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XXcWgj1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF4B606A326;
	Sat,  7 Nov 2026 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XXcWgj1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797B91F0089F;
	Sat,  7 Nov 2026 14:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060667;
	bh=tek+4DUMZJb0AlR7evK5EED1255fOjaJm5pMKFeiDl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XXcWgj1qjGNixbZTvG1VuriuD3ECJfFP1PvFeIA4w2BV0zfgd6SgZ7eMbo34IuYA
	 GeY0rE03HeM7NuIuYnqkJKExG3WYkvQTBuzduyHnroFNVOdm3MO0DuJmjxKx8+TBfP
	 j9uLZW5gvd8eT1rgyfoDqEua0T+f87Lmc4n5EcEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0104/1536] media: cec: tegra: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:35:20 -0500
Message-ID: <20261107135000.590836320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7c1022cee1e84..a199a41589422 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -458,6 +458,7 @@ static const struct of_device_id tegra_cec_of_match[] = {
 	{ .compatible = "nvidia,tegra210-cec", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tegra_cec_of_match);
 
 static struct platform_driver tegra_cec_driver = {
 	.driver = {
-- 
2.53.0



