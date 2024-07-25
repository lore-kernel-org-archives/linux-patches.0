Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00F519AD91;
	Thu, 25 Jul 2024 16:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721925999; cv=none; b=A3A/8XVNI4lwcbwXXQrVyKkYKkvL+k0uEOwZRPFom/hVLrDgh7gGkWfidUsnghpT3aO3CvLsCAkdgIhh42CLf0ioetxuYakYCgVTagFi1TmYl6vW7sYpYInZkhsNDJymU5n9jvDJi7RIaWsijiJhAhnC+O4gWJw516ZdRbplOnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721925999; c=relaxed/simple;
	bh=SSWd5Cnq+ZrCshF93rK3w3XNcMN4l49cB+5OMG1g2/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8h4z0S+XXwliGVXwHrIcp0Hg87/AVXRk0CNcgCtD3C0bF+vnq5fkBpn1cxFgLQgfnsDy4R1PaYRBmD18qh2XNAf/Iegjfd0/XEAX2ary0C7jXbMTfIeof9OuFXooMuJpfToXJcjPnA9NozONurmI1tPUXPXM7yMYRL1zGlGCx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTG8Lmd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTG8Lmd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389D0C4AF07;
	Thu, 25 Jul 2024 16:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721925998;
	bh=SSWd5Cnq+ZrCshF93rK3w3XNcMN4l49cB+5OMG1g2/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTG8Lmd9g7jMyyYZIVEFgD8oNX95GGLhdAiZC3eO1TrIki9UxSp1K7J9p9reii4FA
	 072BcifkbzYfeoNdMe/rkoVRT9Gb81EB2e38ZOMDOuIXIbH7rI3KifZq+emNFrkRZC
	 lYANVl4ZYm+kucbd6Gt6Inwo1V6un/6JuNJtRQ4L9NcQEmDt5d/ZYF+b3Dy8ErCljU
	 LyiFwRTgYTbI7lR6NczmFu7HT0P9YPfGHqO3PmhJf7nrRBn+nROGnOgLppQ5iZf1ar
	 +dcjz68D/NOf+coXHvAcYYr1QoZFuDaHic8wDdCkIwnFEK8ze4zraIrumATWg1RDEd
	 ZX3ilsM5w1hbw==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/3] spmi: add missing MODULE_DESCRIPTION() macros
Date: Thu, 25 Jul 2024 09:46:31 -0700
Message-ID: <20240725164636.3362690-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
In-Reply-To: <20240725164636.3362690-1-sboyd@kernel.org>
References: <20240725164636.3362690-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Johnson <quic_jjohnson@quicinc.com>

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/spmi/hisi-spmi-controller.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/spmi/spmi-pmic-arb.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://lore.kernel.org/r/20240609-md-drivers-spmi-v1-1-f1d5b24e7a66@quicinc.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/hisi-spmi-controller.c | 1 +
 drivers/spmi/spmi-pmic-arb.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/spmi/hisi-spmi-controller.c b/drivers/spmi/hisi-spmi-controller.c
index fa068b34b040..3cafdf22c909 100644
--- a/drivers/spmi/hisi-spmi-controller.c
+++ b/drivers/spmi/hisi-spmi-controller.c
@@ -344,6 +344,7 @@ static void __exit spmi_controller_exit(void)
 }
 module_exit(spmi_controller_exit);
 
+MODULE_DESCRIPTION("Hisilicon 3670 SPMI Controller driver");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION("1.0");
 MODULE_ALIAS("platform:spmi_controller");
diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 791cdc160c51..f240fcc5a4e1 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1891,5 +1891,6 @@ static struct platform_driver spmi_pmic_arb_driver = {
 };
 module_platform_driver(spmi_pmic_arb_driver);
 
+MODULE_DESCRIPTION("Qualcomm MSM SPMI Controller (PMIC Arbiter) driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:spmi_pmic_arb");
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

