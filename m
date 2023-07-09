Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32905522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A991EC433C8;
	Sun,  9 Jul 2023 11:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902157;
	bh=JLmTFhhiJx+jeTkmH2n3N7jH6lYJdxLI0yNrC+26B7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7zb7jra18tdO5dx9SrC6xc4FhpQ8Qvvim7HxQwSbL27ZoweDZuNxNlvLCZB6bku+
	 P4pcbf4iHHbwhSyXVaWaKQsKPkWefzb4dY6PWGh9HiQE5ytAiTdYw1y3V1fhveNvWe
	 V0GgzgTdMArS89U4k8lBP+2fEFEjJtbnk/MBsQ0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 248/431] arm64: dts: qcom: pm7250b: add missing spmi-vadc include
Date: Sun,  9 Jul 2023 13:13:16 +0200
Message-ID: <20230709111456.974023341@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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



