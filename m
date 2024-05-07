Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E9D71B4C;
	Tue,  7 May 2024 21:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116091; cv=none; b=Y1GIWvcJ1yTj9VGY9G6i5Ro30Jh2RmDB/oi1ZacHZCkC0wTuGhPZcIVG75yr19J0VMhu4oDFU+hgcH/jQMEaYh6ADFHXG5H01guEmatpGABUeWc66RSaHToontYJD1AFI++W1VUVQVKQqXe8hMiVNPY5F9Mq9N/T9ymSgP90tSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116091; c=relaxed/simple;
	bh=r5oe1vkus2mJ8VOrgZSUKhQsffL0l19+uK5j58WulmA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r+tUuddJzB/OMxP+m2JlExbbcas5MEFzKWGreeDJDaLX0deAPQpeqZG/jp2Evg/AZlk2ZJNu3OgyNjWGxIIuShJltHIpfahgT+vQ+Gm7a1f9mUZHSGVtUBLZ5fUEaLVaY5ND2vf2TKE7lDH5X6SwjEtiHuX9Y+JgFon8Ogxcz1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8F296cM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8F296cM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8933BC2BBFC;
	Tue,  7 May 2024 21:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116091;
	bh=r5oe1vkus2mJ8VOrgZSUKhQsffL0l19+uK5j58WulmA=;
	h=From:To:Cc:Subject:Date:From;
	b=P8F296cM2OZtZAxfLS5Ogn1h17YB/yHng2rofbQLr9r9YQZbjID9Tr8kgwdn/1d8f
	 KWeTSP1zFiwXnl/Y5y2xJCLObbaAgJfKul6k4sB5Cz412sXHLBwCNQ3cksEAyRJFWH
	 /mUkugQdqA1yb3ycjVs5fw6eQA90NMljzApy9qoQKr2HSRTFdXBSZ40vvCzJ3Zh8hl
	 JdT64AC6ZHHfAILBSb1EmVeNb6noVP6vxGVyZpcuSgiost9PYy1VbfLVKOd5Vr3E1H
	 82MqMmzPW0bp/NzTQlMhW1sCf96fCG1wsQMLn5l00JZe81XrfRFFeBPGRyxB7KNxJx
	 DULHqiyomjGyA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Markus Elfring <elfring@users.sourceforge.net>,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Vamshi Gajjela <vamshigajjela@google.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	David Collins <quic_collinsd@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 00/12] SPMI patches for the merge window
Date: Tue,  7 May 2024 14:07:37 -0700
Message-ID: <20240507210809.3479953-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here's a stack of SPMI patches for the next merge window. The main
chunk consists of adding support for multi bus SPMI controllers found on
newer Qualcomm SoCs. Beyond that there's some cleanups in the bindings
and code along with a non-critical fix to avoid an exit path ida bug.

Abel Vesa (7):
  dt-bindings: spmi: Add X1E80100 SPMI PMIC ARB schema
  dt-bindings: spmi: Deprecate qcom,bus-id
  spmi: pmic-arb: Fix some compile warnings about members not being
    described
  spmi: pmic-arb: Make the APID init a version operation
  spmi: pmic-arb: Make core resources acquiring a version operation
  spmi: pmic-arb: Register controller for bus instead of arbiter
  spmi: pmic-arb: Add multi bus support

Johan Hovold (2):
  dt-bindings: spmi: hisilicon,hisi-spmi-controller: fix binding
    references
  dt-bindings: spmi: hisilicon,hisi-spmi-controller: clean up example

Markus Elfring (1):
  spmi: pmic-arb: Replace three IS_ERR() calls by null pointer checks in
    spmi_pmic_arb_probe()

Ricardo B. Marliere (1):
  spmi: make spmi_bus_type const

Vamshi Gajjela (1):
  spmi: hisi-spmi-controller: Do not override device identifier

 .../spmi/hisilicon,hisi-spmi-controller.yaml  |  17 +-
 .../bindings/spmi/qcom,spmi-pmic-arb.yaml     |   1 +
 .../spmi/qcom,x1e80100-spmi-pmic-arb.yaml     | 136 +++
 drivers/spmi/hisi-spmi-controller.c           |   1 -
 drivers/spmi/spmi-pmic-arb.c                  | 980 +++++++++++-------
 drivers/spmi/spmi.c                           |   2 +-
 6 files changed, 744 insertions(+), 393 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,x1e80100-spmi-pmic-arb.yaml

Cc: Abel Vesa <abel.vesa@linaro.org>
Cc: Johan Hovold <johan+linaro@kernel.org>
Cc: Markus Elfring <elfring@users.sourceforge.net>
Cc: "Ricardo B. Marliere" <ricardo@marliere.net>
Cc: Vamshi Gajjela <vamshigajjela@google.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: David Collins <quic_collinsd@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Neil Armstrong <neil.armstrong@linaro.org>

-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

