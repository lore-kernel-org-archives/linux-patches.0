Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A7D1714A1;
	Thu, 15 Aug 2024 13:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730047; cv=none; b=imuKy3qrua9y+O3kZf9SxH4c3v/gVZLF++DU2sF/FK8d3hPpdBzutME2etwH2nXP0ja+CZVRXsiy/Q3/5Pwy3l4ewbi3l2ZyWw6lyOwANIb0rOVPDWvtZ+wEJJPmuXo21QVi+lK0pMmoNK/HxrVNMu5xvSAHxIc4MbmnUn8HcGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730047; c=relaxed/simple;
	bh=0Qs8sbp/YW8fz7D4D+a2D4hAIEgXUMy3wkq87VW/cRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr3MNBXQYU7/+WjAQw+VUS/3rJ8fALukdhis2Ju7DU8RtiIvUfCunqbny1liyNNcp53RndmByvFGlBxKQf2H3b1AxUvHPkRfXSpYr/r2n5T517o9l/9i3S0465WYO2sFmd8WFLSUuMSVxHAq2YPSGY+za/DQnAwCxHAQAUbk/nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5XE3tQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5XE3tQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BEAC4AF0E;
	Thu, 15 Aug 2024 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730047;
	bh=0Qs8sbp/YW8fz7D4D+a2D4hAIEgXUMy3wkq87VW/cRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5XE3tQRNwSnjeaAw5RnoNiSW/Ch+sJ9jmzokTGH0+DKLkWBodiK1VB3tLqDvuuOT
	 sLb/MCdKLS9GtC1O+JgM5q6RXJjy3zKot4d8aone1YDguhhn+yGirmJl//QaLayd6a
	 zEQFilcA4lqTMhEScCVb3VZ+aiWoHTvQTG4E6CdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Maxime Ripard <mripard@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 287/484] spi: spidev: add correct compatible for Rohm BH2228FV
Date: Thu, 15 Aug 2024 15:22:25 +0200
Message-ID: <20240815131952.494912513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit fc28d1c1fe3b3e2fbc50834c8f73dda72f6af9fc ]

When Maxime originally added the BH2228FV to the spidev driver, he spelt
it incorrectly - the d should have been a b. Add the correctly spelt
compatible to the driver. Although the majority of users of this
compatible are abusers, there is at least one board that validly uses
the incorrect spelt compatible, so keep it in the driver to avoid
breaking the few real users it has.

Fixes: 8fad805bdc52 ("spi: spidev: Add Rohm DH2228FV DAC compatible string")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20240717-ventricle-strewn-a7678c509e85@spud
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 14bebc079ddbd..99bdbc040d1ae 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -715,6 +715,7 @@ static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
 	{ .compatible = "micron,spi-authenta", .data = &spidev_of_check },
+	{ .compatible = "rohm,bh2228fv", .data = &spidev_of_check },
 	{ .compatible = "rohm,dh2228fv", .data = &spidev_of_check },
 	{ .compatible = "semtech,sx1301", .data = &spidev_of_check },
 	{ .compatible = "silabs,em3581", .data = &spidev_of_check },
-- 
2.43.0



