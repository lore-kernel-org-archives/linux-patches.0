Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B019D1FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108FFC433EF;
	Fri,  3 Feb 2023 10:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419697;
	bh=qbSGnQlAtzWva+t/AgMOcqav+DHSqPi2FkRVLWcY2gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsbKyeAZkioiGFXd7HARptpb2O1GyvjDNglcXfntkhNp8jVkZ+VKzN0MoUfDFZCyu
	 96h5aA1eygf1/J70Z+/WkfVCCZFjX7izIu5xv54O0iI3ItzHczoZnsxDFSgZ5u48aR
	 PuFoyzLxtoyUe5wTBqOKPIn6x+lpMyd9t1Fciwqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <petr.vorel@gmail.com>,
	Dominik Kobinski <dominikkobinski314@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/28] arm64: dts: msm8994-angler: fix the memory map
Date: Fri,  3 Feb 2023 11:12:57 +0100
Message-Id: <20230203101010.368148359@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dominik Kobinski <dominikkobinski314@gmail.com>

[ Upstream commit 380cd3a34b7f9825a60ccb045611af9cb4533b70 ]

Add reserved regions for memory hole and tz app mem to prevent
rebooting. Also enable cont_splash_mem, it is the same as the
generic 8994 one.

Reported-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Dominik Kobinski <dominikkobinski314@gmail.com>
Reviewed-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221230194845.57780-1-dominikkobinski314@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/msm8994-huawei-angler-rev-101.dts    | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
index dbfbb77e9ff5..7e2c0dcc11ab 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-huawei-angler-rev-101.dts
@@ -8,9 +8,6 @@
 
 #include "msm8994.dtsi"
 
-/* Angler's firmware does not report where the memory is allocated */
-/delete-node/ &cont_splash_mem;
-
 / {
 	model = "Huawei Nexus 6P";
 	compatible = "huawei,angler", "qcom,msm8994";
@@ -27,6 +24,22 @@ aliases {
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
+
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		tzapp_mem: tzapp@4800000 {
+			reg = <0 0x04800000 0 0x1900000>;
+			no-map;
+		};
+
+		removed_region: reserved@6300000 {
+			reg = <0 0x06300000 0 0xD00000>;
+			no-map;
+		};
+	};
 };
 
 &blsp1_uart2 {
-- 
2.39.0



