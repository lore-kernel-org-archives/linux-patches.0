Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206FD8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E43C433C8;
	Sun, 16 Jul 2023 20:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538083;
	bh=JLmTFhhiJx+jeTkmH2n3N7jH6lYJdxLI0yNrC+26B7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ez2d3zT7NCLsgY1tOMLS/18C7NuJI94LTE75kxRr9bApkBnHWSGFo/K6ap5UOXvNQ
	 Qow+cnzs0oTg1rp9xTtH884XXFZHzEszVMKUf1pT2evw2gILJYCpxHxYcruu2NkiO3
	 w7rdRkDZKNpFUCt8KBg79od0kaiIbfn/ur0t7I4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 325/800] arm64: dts: qcom: pm7250b: add missing spmi-vadc include
Date: Sun, 16 Jul 2023 21:42:58 +0200
Message-ID: <20230716194956.619060491@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 83022f6484b11a60dbf9a95a88c7ef8e59c4b19c ]

This file is using definitions from the spmi-vadc header, so we need to
include it.

Fixes: 11975b9b8135 ("arm64: dts: qcom: Add pm7250b PMIC")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230407-pm7250b-sid-v1-1-fc648478cc25@fairphone.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm7250b.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/pm7250b.dtsi b/arch/arm64/boot/dts/qcom/pm7250b.dtsi
index d709d955a2f5a..daa6f1d30efa0 100644
--- a/arch/arm64/boot/dts/qcom/pm7250b.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm7250b.dtsi
@@ -3,6 +3,7 @@
  * Copyright (C) 2022 Luca Weiss <luca.weiss@fairphone.com>
  */
 
+#include <dt-bindings/iio/qcom,spmi-vadc.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/spmi/spmi.h>
 
-- 
2.39.2



