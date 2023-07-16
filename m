Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842BC8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071BCC433C8;
	Sun, 16 Jul 2023 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538296;
	bh=EyYRh+3otg3D/HkayMLbR/CSzGXR5oVy6A/UB67R580=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCrbqKEo9Q0/UY6OKHoG87vkROS1tkVsQHFOO9M0zIiiQMsd4fp48esoTwMzzdwyB
	 RGZ6s89ukkAo8RLxNgyqgaSxmU29GCXg3fTYBZGavdv3amb9JVnPoC5m08cGpdJns5
	 qbvhpMqPqOtSZFJIQNXkJxTcUUn9xTLNmL4FYlKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 393/800] arm64: dts: ti: k3-j721e-beagleboneai64: Fix mailbox node status
Date: Sun, 16 Jul 2023 21:44:06 +0200
Message-ID: <20230716194958.199688437@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 155e7635ed1f3814d94d12556a3a0fed41d05b76 ]

Mailbox nodes are now disabled by default. The BeagleBoard AI64 DT
addition went in at around the same time and must have missed that
change so the mailboxes are not re-enabled. Do that here.

Fixes: fae14a1cb8dd ("arm64: dts: ti: Add k3-j721e-beagleboneai64")
Signed-off-by: Andrew Davis <afd@ti.com>
Reviewed-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20230515172137.474626-1-afd@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts b/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts
index 37c24b077b6aa..8a62ac263b89a 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts
@@ -936,6 +936,7 @@ &ufs_wrapper {
 };
 
 &mailbox0_cluster0 {
+	status = "okay";
 	interrupts = <436>;
 
 	mbox_mcu_r5fss0_core0: mbox-mcu-r5fss0-core0 {
@@ -950,6 +951,7 @@ mbox_mcu_r5fss0_core1: mbox-mcu-r5fss0-core1 {
 };
 
 &mailbox0_cluster1 {
+	status = "okay";
 	interrupts = <432>;
 
 	mbox_main_r5fss0_core0: mbox-main-r5fss0-core0 {
@@ -964,6 +966,7 @@ mbox_main_r5fss0_core1: mbox-main-r5fss0-core1 {
 };
 
 &mailbox0_cluster2 {
+	status = "okay";
 	interrupts = <428>;
 
 	mbox_main_r5fss1_core0: mbox-main-r5fss1-core0 {
@@ -978,6 +981,7 @@ mbox_main_r5fss1_core1: mbox-main-r5fss1-core1 {
 };
 
 &mailbox0_cluster3 {
+	status = "okay";
 	interrupts = <424>;
 
 	mbox_c66_0: mbox-c66-0 {
@@ -992,6 +996,7 @@ mbox_c66_1: mbox-c66-1 {
 };
 
 &mailbox0_cluster4 {
+	status = "okay";
 	interrupts = <420>;
 
 	mbox_c71_0: mbox-c71-0 {
-- 
2.39.2



