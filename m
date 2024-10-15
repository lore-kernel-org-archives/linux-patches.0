Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8921AF0AC;
	Tue, 15 Oct 2024 13:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997721; cv=none; b=SDWtJ7b2EzPqATeKCt0XAkpqTzeun57/bhhTMPYIrgurU/FeBNbBTAa0/r1jOxY7O6U5JkhIX9QQsbsb5jgHE8yaYfJ4miFvXT0OqzgMoSjesLROTrNJFMB7lhF2gMNOI3wYNmEU6WFD6lzvK58LtRrYJdPSDtbmtC/tpd0s7Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997721; c=relaxed/simple;
	bh=OxUy5jRXRBInv1WSm9w5LViYVwXc/McTyrpNgH/dtQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOidyasImaetDIgHFIEtCjXe2vFitrCDE/103P97HLO/UGu5J9YS025wERTZekxZeINm+PsCIoC+LRykzAfTfXKnYolnMPoisB59v5/XPzHO7VG0mW0Hv6Sr2SHp2ZyFdM4I2TnmO2eVIc1czX9vfURURZ0Vt5/rOeAz0Ffp5Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbiWb6zW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbiWb6zW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA20C4CEC6;
	Tue, 15 Oct 2024 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997721;
	bh=OxUy5jRXRBInv1WSm9w5LViYVwXc/McTyrpNgH/dtQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbiWb6zWGdzhOyZT5zR4CMycVwKXl2WToK5Tzfc1lorTPby1eFVCtZajEo8cU2ErM
	 nGxKHM0vr3ivKKwcYYD2QXE4SQPUSVTO9HxhYYdrn5/DFQ91a2I8hk/bry2Y/m5SXL
	 X3c75AncA9c8WlK6bnumcVxDJcgGKfWJZZ9mhTW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 265/518] spi: lpspi: Simplify some error message
Date: Tue, 15 Oct 2024 14:42:49 +0200
Message-ID: <20241015123927.221748940@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 0df874c6712d9aa8f43c50ec887a21f7b86fc917 upstream.

dev_err_probe() already prints the error code in a human readable way, so
there is no need to duplicate it as a numerical value at the end of the
message.

Fixes: 12f62a857c83 ("spi: lpspi: Silence error message upon deferred probe")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-By: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/253543c462b765eca40ba54c66f4e3fdf4acdeb7.1659735546.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-lpspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -919,7 +919,7 @@ static int fsl_lpspi_probe(struct platfo
 
 	ret = devm_spi_register_controller(&pdev->dev, controller);
 	if (ret < 0) {
-		dev_err_probe(&pdev->dev, ret, "spi_register_controller error: %i\n", ret);
+		dev_err_probe(&pdev->dev, ret, "spi_register_controller error\n");
 		goto free_dma;
 	}
 


