Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428B48C0B;
	Sat,  9 Nov 2024 00:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731112112; cv=none; b=LEIyn5d27t2wYZat2z6+NTC4gAfSzQmFrYNgdHJ3rsRRrpFNch5pNGr41vS4hhkhJVA80zmOyIuM3bKlsVAEp8jh9VSlo797VDdFEcLxncVQtHaJYn3pm/diZxZ8PJIBRfKx6agRmLElDhh1emFrNdKdcrtH++tJL8hEz8GwwZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731112112; c=relaxed/simple;
	bh=IBNh7dabfqa0UK+cVMrAB06ypmHTvI7x+e/C8pdK9Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oytrdH0CBdOe1s5ngi8UsQnHtCNw2xSLvWMRd1cEY+L2Zxa+LZnbQBDQzrt2OrtRhLe7kHDF5uJ0FL6UjA+vXGQZuRZnipqDOK++fkQPispcbrDR3xHk/vYLJz3g8Lbv24Dgu+y0I2Gnt94s6q8/cqR+ffflAsJqJWOTlu+Ocg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BgMiFkT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BgMiFkT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2A4C4CECE;
	Sat,  9 Nov 2024 00:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731112111;
	bh=IBNh7dabfqa0UK+cVMrAB06ypmHTvI7x+e/C8pdK9Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgMiFkT3kJMEDUFQwJv2OFXBZsChigON7OoHIvHLSPEsexdQU1gZ5c1OU1Ho5qApS
	 LWGwPhjEcm4zvBMFIysFQOHMQCsw60Y7fh+GO+0sZuDlSk2y+MlNJBxFrIH2lW7j8F
	 moZzKlkHFrKUeiLAE4nfQDI4/Cuhi2y8NiHC7u6xmFhD0npwO9tqHEYj0XT7aPXILL
	 HoFKTJ4ZAEo+jL4bLxXCSaqIZ0a26E6+7oVT/xeuDoUNqij+tpZH2zxRmuxoDAj9eP
	 ycxOsJUR9TDHVB7RBsgPS4fXkoZ3ju85c9B405TnJ4fMbiFItMuyNFd70tRUJc0i0n
	 ubW3Pdi/6UvmA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fei Shao <fshao@chromium.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 2/3] dt-bindings: spmi: spmi-mtk-pmif: Add compatible for MT8188
Date: Fri,  8 Nov 2024 16:28:27 -0800
Message-ID: <20241109002829.160973-3-sboyd@kernel.org>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
In-Reply-To: <20241109002829.160973-1-sboyd@kernel.org>
References: <20241109002829.160973-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fei Shao <fshao@chromium.org>

Add compatible string for the SPMI block on MT8188 SoC, which is
compatible with the one used on MT8195.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20240911143429.850071-2-fshao@chromium.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml b/Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml
index ac99883a3f29..7f0be0ac644a 100644
--- a/Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml
+++ b/Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml
@@ -25,6 +25,7 @@ properties:
       - items:
           - enum:
               - mediatek,mt8186-spmi
+              - mediatek,mt8188-spmi
           - const: mediatek,mt8195-spmi
 
   reg:
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

