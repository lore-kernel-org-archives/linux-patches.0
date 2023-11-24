Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A0839FD0;
	Fri, 24 Nov 2023 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiTOgL/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C11C433C7;
	Fri, 24 Nov 2023 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848720;
	bh=LeEsibanNtpcv2le2piUY1ttFp+4gHNOhYNStsaiYG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiTOgL/boz8qwHmQ9qxqHKKr5lizj4HNgvXOiSwEsOYsUdvYFZscwKJD1jxyerole
	 HGQRIHbcMQkjPo4gX5ftLqe7KqoVqbITysptw//yRK7FAdsLYbMQKwQXHVh6PZjAXy
	 dd/5E8aTKe5g8iJRgq1vRHCFdAkxrfigKHKKPKCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Chen <rong.chen@amlogic.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 55/97] mmc: meson-gx: Remove setting of CMD_CFG_ERROR
Date: Fri, 24 Nov 2023 17:50:28 +0000
Message-ID: <20231124171936.201599920@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Chen <rong.chen@amlogic.com>

commit 57925e16c9f7d18012bcf45bfa658f92c087981a upstream.

For the t7 and older SoC families, the CMD_CFG_ERROR has no effect.
Starting from SoC family C3, setting this bit without SG LINK data
address will cause the controller to generate an IRQ and stop working.

To fix it, don't set the bit CMD_CFG_ERROR anymore.

Fixes: 18f92bc02f17 ("mmc: meson-gx: make sure the descriptor is stopped on errors")
Signed-off-by: Rong Chen <rong.chen@amlogic.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231026073156.2868310-1-rong.chen@amlogic.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -931,7 +931,6 @@ static void meson_mmc_start_cmd(struct m
 
 	cmd_cfg |= FIELD_PREP(CMD_CFG_CMD_INDEX_MASK, cmd->opcode);
 	cmd_cfg |= CMD_CFG_OWNER;  /* owned by CPU */
-	cmd_cfg |= CMD_CFG_ERROR; /* stop in case of error */
 
 	meson_mmc_set_response_bits(cmd, &cmd_cfg);
 


