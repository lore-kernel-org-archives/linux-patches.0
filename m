Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0ED42048;
	Fri, 23 Jan 2026 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192441; cv=none; b=i8exq49+QK6RfGs3qZBqGOGagQfdsfv7ki1zMIsz7SB//G1dY5um23l6w+fFnBpqP2SklqB55mXLk6kXvHZqH8wrrQA8qVOLNW8TOXMO5tpMM48BAE3ZwvcccdPBdHLHJBHZKRe2ZvCHuRW2gCraehm0wrAsdCnDKYFXk+Ri6DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192441; c=relaxed/simple;
	bh=soXCYqTDRDABq0Y8UXoiniC7tbF6j/Q2IdBLpYLWa4g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Pc6nIbDoS3ROCbbES0a3xmia4qfYFa+WKy10tvuj0bBJz6Z7fF+OhldrgnR5bFRBmk1SEOnmA7tYqk5VX5pl3hidr0QbhAkB15S5qmz/V61Kii4E5NlXwAdh0nKgszzC6QzJaMWUI/t0Zz979+/8zxnKWhNugmg3JUYlH2cwBcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzNwB7bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzNwB7bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2DAC4CEF1;
	Fri, 23 Jan 2026 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769192440;
	bh=soXCYqTDRDABq0Y8UXoiniC7tbF6j/Q2IdBLpYLWa4g=;
	h=From:To:Cc:Subject:Date:From;
	b=YzNwB7bb5rHrweI6gYgm+uQR2XBa3bqInGQuOKcx7l+HruyHagOO+suyGJ/LKAFmW
	 hF4gM1CDVOEmaJboTlO1VHdnHYGN/dRHm87RdS6ubm1vctt5iAldwFKDXiPTfYWhD7
	 34myfDyTHWWiGKiDcvqO04ErFO87rmbrCoLiTKlo4z8nJtkHG/xMu62pISC43bbW/X
	 UJoxx2l1/gJS8KDE/LZpOi0y5DsXLhUCJIJvWYefWsgNaU9mqg04Aee8/TmNPU+76/
	 h6YF6qAKc3kn3iP9xjfCAZlKjYIzc8y1YfDhmqFUNFJQI6WV8dcIuyF6QCMDD/WLiU
	 YIuodFS9qXWkw==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 00/10] spmi: Patches for the merge window 
Date: Fri, 23 Jan 2026 10:20:28 -0800
Message-ID: <20260123182039.224314-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the collection of SPMI related patches for the next merge
window. Highlights include support for a new version of the PMIC SPMI
arbiter found on Qualcomm SoCs and the SPMI controller on Mediatek
MT8196 SoCs. Otherwise there are minor DT binding updates on top of the
new binding files for the previously mentioned new hardware support.

AngeloGioacchino Del Regno (5):
  dt-bindings: spmi: Add MediaTek MT8196 SPMI 2 Arbiter/Controllers
  spmi: mtk-pmif: Add multi-bus support for SPMI 2.0
  spmi: mtk-pmif: Keep spinlock until read is fully done
  spmi: mtk-pmif: Implement Request Capable Slave (RCS) interrupt
  spmi: mtk-pmif: Add support for MT8196 SPMI Controller

David Collins (1):
  spmi: spmi-pmic-arb: add support for PMIC arbiter v8

Janne Grunau (1):
  spmi: apple: Add "apple,t8103-spmi" compatible

Jishnu Prakash (2):
  dt-bindings: spmi: split out common QCOM SPMI PMIC arbiter properties
  dt-bindings: spmi: add support for glymur-spmi-pmic-arb (arbiter v8)

Louis-Alexis Eyraud (1):
  dt-bindings: spmi: spmi-mtk-pmif: Add compatible for MT8189 SoC

 .../bindings/spmi/mediatek,mt8196-spmi.yaml   | 138 +++++
 .../bindings/spmi/mtk,spmi-mtk-pmif.yaml      |   1 +
 .../spmi/qcom,glymur-spmi-pmic-arb.yaml       | 150 ++++++
 .../spmi/qcom,spmi-pmic-arb-common.yaml       |  35 ++
 .../bindings/spmi/qcom,spmi-pmic-arb.yaml     |  17 +-
 .../spmi/qcom,x1e80100-spmi-pmic-arb.yaml     |  21 +-
 drivers/spmi/spmi-apple-controller.c          |   1 +
 drivers/spmi/spmi-mtk-pmif.c                  | 472 +++++++++++++++---
 drivers/spmi/spmi-pmic-arb.c                  | 304 +++++++++--
 9 files changed, 977 insertions(+), 162 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spmi/mediatek,mt8196-spmi.yaml
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,glymur-spmi-pmic-arb.yaml
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb-common.yaml

-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

