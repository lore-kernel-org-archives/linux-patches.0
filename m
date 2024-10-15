Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDB91D90DC;
	Tue, 15 Oct 2024 11:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992293; cv=none; b=ln4bBfdYxVfRk+V8uq/5VLpJr42JKKImBaKu5g6PNGbcVxx/0xVujAGMEZMOsQaml0tbYV1BQrDKhoxY8LGU1fwrxrMopfbwD6I8NP9LxLr770HrvvDjFZFNZ5PWTq+tK8WI5C1nPetZG6TP9zW2ncCmS4Btc746prAgMdrq6Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992293; c=relaxed/simple;
	bh=BmecMWmly5qvIAdMzFEi6P3sWODbVnHi+v2XZ8HKtLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqWhOBF14hwEAneaI6Ra2bePBxV/YRfdmRTcmXL8b4iE3XVLGf6IyvpIbPN3Qoi1fyFQVq7BQYBr+9dsVsjtOX7JdeVffSZmpKMtRqXz3GCJl81wTCn5SlO+ITNsPEQ9PUkwSBgcT8A6hyZYyCQ3MOGiTTshKFODxWoA0SRBXAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqLZpk32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqLZpk32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD47C4CEC6;
	Tue, 15 Oct 2024 11:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992293;
	bh=BmecMWmly5qvIAdMzFEi6P3sWODbVnHi+v2XZ8HKtLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqLZpk324nQJWJv6lePt1HsJEJfI+GylWoCkUN6yGdXyZ+BEIfz67sZebyjQdYBcC
	 6GlVgCrvI2gjmoycUxGcSlUIYZ0M4d1A41XXgG/9T5ueocRvLxvf+N16xvlyLQq4ME
	 Gr/cnfc4E2TR+wml/9Ly6LkBgz2/8PKgX77co7Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/691] spi: spidev: Add an entry for elgin,jg10309-01
Date: Tue, 15 Oct 2024 13:20:21 +0200
Message-ID: <20241015112443.253571435@linuxfoundation.org>
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

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 5f3eee1eef5d0edd23d8ac0974f56283649a1512 ]

The rv1108-elgin-r1 board has an LCD controlled via SPI in userspace.
The marking on the LCD is JG10309-01.

Add the "elgin,jg10309-01" compatible string.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20240828180057.3167190-2-festevam@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 0b97e5b97a018..8570cd35b7e50 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -712,6 +712,7 @@ static int spidev_of_check(struct device *dev)
 static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
 	{ .compatible = "dh,dhcom-board", .data = &spidev_of_check },
+	{ .compatible = "elgin,jg10309-01", .data = &spidev_of_check },
 	{ .compatible = "lineartechnology,ltc2488", .data = &spidev_of_check },
 	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
-- 
2.43.0



