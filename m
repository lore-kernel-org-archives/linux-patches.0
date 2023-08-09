Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5601773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BE3C433C7;
	Wed,  9 Aug 2023 11:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579802;
	bh=+T4KfMXrIzKSvCBCS4l3Oq8BfhKOi+o2IFeWjEnYbCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcGMcuZaOGEi74xtLLxDEE0lxeRK4ejc2Ac/SNHQydZY2kpya+ie2LCiX4VECjvrr
	 piTm6ZuKKT6/owsHZG/LHklQgj/KNrm0/7elT0ZZS6MnyDaxSsHJ/Ml8oOMaEYQopN
	 toFW7PmcqR1e6UNkZfA7yUf6sLw8PBaYvf9ynPaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	Mark Brown <broonie@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 4.19 121/323] spi: spi-fsl-spi: remove always-true conditional in fsl_spi_do_one_msg
Date: Wed,  9 Aug 2023 12:39:19 +0200
Message-ID: <20230809103703.649765214@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

commit 24c363623361b430fb79459ca922e816e6f48603 upstream.

__spi_validate() in the generic SPI code sets ->speed_hz and
->bits_per_word to non-zero values, so this condition is always true.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-spi.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -387,12 +387,10 @@ static int fsl_spi_do_one_msg(struct spi
 	cs_change = 1;
 	status = -EINVAL;
 	list_for_each_entry(t, &m->transfers, transfer_list) {
-		if (t->bits_per_word || t->speed_hz) {
-			if (cs_change)
-				status = fsl_spi_setup_transfer(spi, t);
-			if (status < 0)
-				break;
-		}
+		if (cs_change)
+			status = fsl_spi_setup_transfer(spi, t);
+		if (status < 0)
+			break;
 
 		if (cs_change) {
 			fsl_spi_chipselect(spi, BITBANG_CS_ACTIVE);


