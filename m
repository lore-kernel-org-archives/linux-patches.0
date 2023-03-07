Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A653BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E638C433D2;
	Tue,  7 Mar 2023 18:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212151;
	bh=Qpo+mdHi3VPJd+6/dhlUEoEDTnOv/1zRW9w+U4yzKUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtS/2laJXpdCWK1/ot9QhSwXdRnWzyNK5C1ziO6hKA5JCcR3ZSC6H3XI21K0CPdA/
	 /tg8MvH6pTgU4RQKa8ag1ems+aJG/X1BvhBn4EqFx4nkIucUcJIY88EikuzTBBx7u6
	 ci5GsnlfYRZ2lauKNeQNfBhlrLVa+Xu/FmmRmn34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Douglass <jamiemdouglass@gmail.com>,
	Petr Vorel <pvorel@suse.cz>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/885] arm64: dts: qcom: msm8992-lg-bullhead: Correct memory overlaps with the SMEM and MPSS memory regions
Date: Tue,  7 Mar 2023 17:50:28 +0100
Message-Id: <20230307170005.920092419@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jamie Douglass <jamiemdouglass@gmail.com>

[ Upstream commit d44106883d74992343710f18c4aaae937c7cefab ]

The memory region reserved by a previous commit (see fixes tag below)
overlaps with the SMEM and MPSS memory regions, causing error messages in
dmesg:
	OF: reserved mem: OVERLAP DETECTED!
	reserved@5000000 (0x0000000005000000--0x0000000007200000)
	overlaps with smem_region@6a00000
	(0x0000000006a00000--0x0000000006c00000)

	OF: reserved mem: OVERLAP DETECTED!
	reserved@6c00000 (0x0000000006c00000--0x0000000007200000)
	overlaps with memory@7000000
	(0x0000000007000000--0x000000000ca00000)

This patch resolves both of these by splitting the previously reserved
memory region into two sections either side of the SMEM region and by
cutting off the second memory region to 0x7000000.

Fixes: 22c7e1a0fa45 ("arm64: dts: msm8992-bullhead: add memory hole region")
Signed-off-by: Jamie Douglass <jamiemdouglass@gmail.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230202054819.16079-1-jamiemdouglass@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index 49f30efdbe656..d1962dc24bb7e 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -55,8 +55,13 @@ cont_splash_mem: memory@3400000 {
 			no-map;
 		};
 
-		removed_region: reserved@5000000 {
-			reg = <0 0x05000000 0 0x2200000>;
+		reserved@5000000 {
+			reg = <0x0 0x05000000 0x0 0x1a00000>;
+			no-map;
+		};
+
+		reserved@6c00000 {
+			reg = <0x0 0x06c00000 0x0 0x400000>;
 			no-map;
 		};
 	};
-- 
2.39.2



