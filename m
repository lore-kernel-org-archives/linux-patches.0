Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296F31E8857;
	Tue, 15 Oct 2024 11:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992362; cv=none; b=kB+6ipSvvfvpvilRwgcktN1TSfuXeVS2sevMtO7o59QlPumt23NUSsjhrZgG7VUWEqb0jzG/IKveAQrmn2lMDMKKH0N1bvj2ca/RndRsHSJk7Pv6R6uXFqLVqCwaLl43DxnpeUiHZVz1VJVW3lgsa6y9tgaGgc4qlrq0fITpMAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992362; c=relaxed/simple;
	bh=0JqWU2tIuKR8No+JJ1u6iN7pyHhsIjceJxMiSs4BRX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qn6txbv95tMr9LqPEPoASt8pYFJ7hTYaTyvYf58j7+6FC4DnhelFIvKGYPJLzvnHnLRy7tSmG7yAUVVKuwJT0wWymyKwboFLXYqhF7JPymvOk1awcmWpQiGOlgt6sZaXoiqvWsiDDUVHLAiZsksoVlMXDqcpDMWAIEuNKkG/1Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXKf+FvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXKf+FvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362B7C4CECE;
	Tue, 15 Oct 2024 11:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992361;
	bh=0JqWU2tIuKR8No+JJ1u6iN7pyHhsIjceJxMiSs4BRX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXKf+FvVSevIRLHy66kyb+3Q2PXvyqwGqGwQHNj2zQfL0ot9WHHLplVK3433qYPyk
	 Cf9EI6WsRZcrE8QMF4Toh/svrtoNd121DtPMtwdIsqLXfi0OgNJBq2bcunt/0VY+Tm
	 vFOgTAd1j/HSCXvVdQhvnHYq15jDil0+/F7I7KeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/691] spi: spidev: Add missing spi_device_id for jg10309-01
Date: Tue, 15 Oct 2024 13:20:25 +0200
Message-ID: <20241015112443.414177745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5478a4f7b94414def7b56d2f18bc2ed9b0f3f1f2 ]

When the of_device_id entry for "elgin,jg10309-01" was added, the
corresponding spi_device_id was forgotten, causing a warning message
during boot-up:

    SPI driver spidev has no spi_device_id for elgin,jg10309-01

Fix module autoloading and shut up the warning by adding the missing
entry.

Fixes: 5f3eee1eef5d0edd ("spi: spidev: Add an entry for elgin,jg10309-01")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/54bbb9d8a8db7e52d13e266f2d4a9bcd8b42a98a.1725366625.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 8570cd35b7e50..2ea29fb819410 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -684,6 +684,7 @@ static struct class *spidev_class;
 static const struct spi_device_id spidev_spi_ids[] = {
 	{ .name = "bh2228fv" },
 	{ .name = "dh2228fv" },
+	{ .name = "jg10309-01" },
 	{ .name = "ltc2488" },
 	{ .name = "sx1301" },
 	{ .name = "bk4" },
-- 
2.43.0



