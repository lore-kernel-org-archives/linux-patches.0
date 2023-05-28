Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE217611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B433C433EF;
	Sun, 28 May 2023 19:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303113;
	bh=erdNnoZgfd/iNtqADvIk3GyLIYvRZ/U+gVLnY8eI2cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAF44KKVOwKyDgWjgJLC/fVKPv5x+EGKAYSnW+23YLWQfrnpc9s3zzdaNIfZQz0f/
	 En+Vq8cAgDCF1p90NvCvewqNdgzZ2pnld6ahw9gkL5UpYbfnvMH/8ASrSfENkPAXSJ
	 sUV7CvcVXlB6LPvbD5oMuhLsaN6kzCcOrhRUK3i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Marek Vasut <marex@denx.de>
Subject: [PATCH 5.10 160/211] ARM: dts: stm32: fix AV96 board SAI2 pin muxing on stm32mp15
Date: Sun, 28 May 2023 20:11:21 +0100
Message-Id: <20230528190847.479320747@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Olivier Moysan <olivier.moysan@foss.st.com>

commit ee2aacb6f3a901a95b1dd68964b69c92cdbbf213 upstream.

Replace sai2a-2 node name by sai2a-sleep-2, to avoid name
duplication.

Fixes: 1a9a9d226f0f ("ARM: dts: stm32: fix AV96 board SAI2 pin muxing on stm32mp15")

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
@@ -1102,7 +1102,7 @@
 		};
 	};
 
-	sai2a_sleep_pins_c: sai2a-2 {
+	sai2a_sleep_pins_c: sai2a-sleep-2 {
 		pins {
 			pinmux = <STM32_PINMUX('D', 13, ANALOG)>, /* SAI2_SCK_A */
 				 <STM32_PINMUX('D', 11, ANALOG)>, /* SAI2_SD_A */


