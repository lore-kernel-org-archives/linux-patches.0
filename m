Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EADE6BB53;
	Tue, 23 Jan 2024 02:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975370; cv=none; b=McvZEKm6b8M3MliGoyBVr91yD1HOrGvPcTXMHW0Dwf5vYVMzGrpNUcaN7hRkFq/3Oec6roJ37zIQjuwPjAVwjcfKw+XYDv5dc8kWs8ow/DVn3ZONZeD3o9Tb6X9Lv/pSCLSM06hULraX6zm9s82R4Vmw4NNYd8A7UjfvV9olx7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975370; c=relaxed/simple;
	bh=XzYVPlnIxSMWnMrq0ItNbYeMurKznfdRY53fuZW4zmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ib+pLIBBRxjuTAGMsQTZOXdLBEMTQB0LpFctILgOTEK2WzJVlvtZqY089qqJxOczEkJ5Y+L8U4jPPPHCTCsc9YnCO9XKtS+xOsi8DC9xcdeopI4vMWGtYNFXtwQd9J48t+MUdAicrKPYuXvPz5/eD5/4qgjT0dcv7UlNS2PmsCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdvJSWxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdvJSWxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DF6C433A6;
	Tue, 23 Jan 2024 02:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975370;
	bh=XzYVPlnIxSMWnMrq0ItNbYeMurKznfdRY53fuZW4zmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdvJSWxzztE5EqB//S4lyHQ+SeSfv9oaUgCVmOnmFo8kezNqDsB+FcAqZekFANT2w
	 fqnhcXxFcIQZOip3ydmRNAMcBoluVv8qnSqaKo6spiL8fAXgRBN3m/8GJ8sGqCIy5P
	 ZCMbaDGEaIvx2vn8aiWCSFsa+tpGjg0uD37oXE/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/583] ASoC: tas2781: add support for FW version 0x0503
Date: Mon, 22 Jan 2024 15:55:58 -0800
Message-ID: <20240122235821.422206623@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit ee00330a5b78e2acf4b3aac32913da43e2c12a26 ]

Layout of FW version 0x0503 is compatible with 0x0502.
Already supported by TI's tas2781-linux-driver tree.
https://git.ti.com/cgit/tas2781-linux-drivers/tas2781-linux-driver/

Fixes: 915f5eadebd2 ("ASoC: tas2781: firmware lib")
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://msgid.link/r/98d4ee4e01e834af72a1a0bea6736facf43582e0.1702513517.git.soyer@irl.hu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-fmwlib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 1dfac9b2fca2..61b05629a9a9 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -2012,6 +2012,7 @@ static int tasdevice_dspfw_ready(const struct firmware *fmw,
 	case 0x301:
 	case 0x302:
 	case 0x502:
+	case 0x503:
 		tas_priv->fw_parse_variable_header =
 			fw_parse_variable_header_kernel;
 		tas_priv->fw_parse_program_data =
-- 
2.43.0



