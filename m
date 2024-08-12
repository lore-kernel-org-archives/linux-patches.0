Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C03183CA6;
	Mon, 12 Aug 2024 16:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479519; cv=none; b=Tm2aSoE+4uqXaZW/QjGdteqYqvzQZWvaJZYQzdaWqO1+hhZ1RB9CgB9Y3IuGTt3XXnMXFgqWYHcAwV/RzKhlcLSJDuOm/piqGFY4NKybxU+uW+n6SDvk96uezcA0/WTMMMTUoNcfI3Dah7oO9lBJ0lh3YefPnunlyR/4EiefWEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479519; c=relaxed/simple;
	bh=oTgKW8/yU9kzELSP76aG7vjh4bPyHcIfn2e721QvM+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/6yCt7dO3ku0sK884nFrqTeeu16ZO6+DRZEBvhdidY9xYWmF3I6FjEjThHYQ5Q78Sk4c0jla4tciE51J2094RP+plPGDxIRHnDaETKVgeu2fiz9rKDG2dwXcBcPYSJTKmuOdFMFL1W30zBPCRI0/a6mFnEAhhV8S/qksut2YH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3r1ZHF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3r1ZHF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E25C32782;
	Mon, 12 Aug 2024 16:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479519;
	bh=oTgKW8/yU9kzELSP76aG7vjh4bPyHcIfn2e721QvM+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3r1ZHF3x7vio/z7C8aTTMQhUOLfx+v4kIdA818vdW85R0bb00/H1I+D3xck3OURh
	 wCK4BrX9w4IBgJLMXI23Bxh1GoWQ199lIbXUiQxms9AiyzjdGUuKLIF5PCiG1YeAzJ
	 kP8JkZjYzF3C9GE0rIwDENzNM6jLUVpxbdjSmKp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/189] spi: spidev: Add missing spi_device_id for bh2228fv
Date: Mon, 12 Aug 2024 18:02:31 +0200
Message-ID: <20240812160135.800474703@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit e4c4638b6a10427d30e29d22351c375886025f47 ]

When the of_device_id entry for "rohm,bh2228fv" was added, the
corresponding spi_device_id was forgotten, causing a warning message
during boot-up:

    SPI driver spidev has no spi_device_id for rohm,bh2228fv

Fix module autoloading and shut up the warning by adding the missing
entry.

Fixes: fc28d1c1fe3b3e2f ("spi: spidev: add correct compatible for Rohm BH2228FV")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/cb571d4128f41175f31319cd9febc829417ea167.1722346539.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 1a8dd10012448..b97206d47ec6d 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -704,6 +704,7 @@ static const struct file_operations spidev_fops = {
 static struct class *spidev_class;
 
 static const struct spi_device_id spidev_spi_ids[] = {
+	{ .name = "bh2228fv" },
 	{ .name = "dh2228fv" },
 	{ .name = "ltc2488" },
 	{ .name = "sx1301" },
-- 
2.43.0



