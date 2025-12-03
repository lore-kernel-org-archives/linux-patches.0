Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA61340D90;
	Wed,  3 Dec 2025 16:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778974; cv=none; b=gnc1UmIgOTGrgxsncBk9/vM6vQqQl+urWVoWoI72sTkQqEs17sPN7S+tKUf61XNFXfFbC/imJHsuIe8YjVBl7IrBQFxuhHIuMnF9M4CTdMbsokizpQAYRxI5TfiMFYQnLTWbuGNnG6to21/huLsRq+VqRma2hUtNYD8shQzch3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778974; c=relaxed/simple;
	bh=IksAtroRzMpIkWRp/rtoMHWB4MSkwupaPAITfPNDdMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1TPW0MZSN40OEDmM3rBeXZBQLBM8l27eQKhSXInGhm338ZRdaE7bOYVLNcoYjTI79YoS0ZAgNwUX6ZBnorCs7OIB6qiFfPG3Yhy1y8iIpTuT8obTpy5vn0n3qRxM6iFewAVm8k5DYE7ez7A6micjyg4NLq5qZ6XL7g8maIQMBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tlGSavI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tlGSavI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68056C4CEF5;
	Wed,  3 Dec 2025 16:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778974;
	bh=IksAtroRzMpIkWRp/rtoMHWB4MSkwupaPAITfPNDdMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tlGSavIPwu6IUVwK0l5rw2flG6Kbc73PVVgYFhAF1NtAWHraHIaw2tFOXt8eiO1I
	 Bj+X2um5ThonIAbz+WrrRMctrViQYydb1KnXuJK82kwfiR4XZWK4JfBtfGgbBwd1Ft
	 bO2VZfkPlB28it7BRU3YfyRtDKELdvYTQGS1oZV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/568] spi: rpc-if: Add resume support for RZ/G3E
Date: Wed,  3 Dec 2025 16:22:00 +0100
Message-ID: <20251203152445.056600934@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit ad4728740bd68d74365a43acc25a65339a9b2173 ]

On RZ/G3E using PSCI, s2ram powers down the SoC. After resume,
reinitialize the hardware for SPI operations.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20250921112649.104516-3-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rpc-if.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index ec0904faf3a10..b294ac56470a0 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -195,6 +195,8 @@ static int __maybe_unused rpcif_spi_resume(struct device *dev)
 {
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
 
+	rpcif_hw_init(dev, false);
+
 	return spi_controller_resume(ctlr);
 }
 
-- 
2.51.0



