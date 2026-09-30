Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0895F4FECC4;
	Wed, 30 Sep 2026 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782834; cv=none; b=tIShZqWHkq7u6IcNvQl358e92RfCfvcfs9ertNHeZNjTCr2vRNOiq0wwF5sj+jU5sexUGL6AcUUxklZ/aicjf6AOikfEVqs5PNKxCrUTrGYg3ndKLgcv2ChV3Z4tohNHPGAOKTd31VV2i9Y217nP2THGIJrHf0i1ckj5fkBtphg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782834; c=relaxed/simple;
	bh=VEwosoPDA0maVdLd+ZFXA5TwPHykI+q5DWdTecpoTj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFwPrp8pemzaPLOqTGnJbQMHGqiazGvWevLkM7uuqDx3D9mSEc1m4WZihiUNMKkMPlZ+2vEbqX+OXoaot89HzQ8Bb957msIdKn76KRSU8yjlOwZXQuQaXQSBtQrNXOSBPyxTC+h10gIRMSByTt/DZAckt2TpY98vxbuQxp36dAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fikG1oO4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fikG1oO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADF51F0089A;
	Wed, 30 Sep 2026 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782828;
	bh=U3Buqx9NiuwnqCOFQRozkfEVmQIIEZR06hx1v+Q+cDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fikG1oO41z/avGN6/f95vHwzoxCZdeGrVvmkRV8Pd04qWhjuS0LWQJtUb4X/fecyQ
	 ruOk2plePuCZDlYyuSN+9Ks/mTcxZYPBV5dTVcWE16DA1VZwysoKARJEBeY+Abc2nq
	 r7uZ5vYvdkqgAsZJcwNCw+PbCR2yPETa+gVlabG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/595] clk: at91: pmc: #undef field_{get,prep}() before definition
Date: Wed, 30 Sep 2026 17:21:17 +0200
Message-ID: <20260930152351.699328469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit dbfe51513aae6bace00cc390e11cb486a64a63d2 ]

Prepare for the advent of globally available common field_get() and
field_prep() macros by undefining the symbols before defining local
variants.  This prevents redefinition warnings from the C preprocessor
when introducing the common macros later.

Suggested-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/pmc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 7b86affc6d7c9..94f6a3fcb5054 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -98,7 +98,9 @@ struct clk_pcr_layout {
 	u32 pid_mask;
 };
 
+#undef field_get
 #define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
+#undef field_prep
 #define field_prep(_mask, _val) (((_val) << (ffs(_mask) - 1)) & (_mask))
 
 #define ndck(a, s) (a[s - 1].id + 1)
-- 
2.53.0



