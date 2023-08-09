Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5DA174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E9CC433C8;
	Wed,  9 Aug 2023 11:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578806;
	bh=2Q+xWbnrtJlVGt5zYyl6yxsmBcRlkA6WkgiD6//fj+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0aln0u/7A2kJZICRCopiWxUcT6ZyEyZR9I9Q9bvNYivm3JG/OKUsuAqVDFzjX9i9g
	 CPwK0lMqm2Yos9CB2sQuBbjU3RmPtEpZmNcgsmC2RRx/WjfM60XZdC3Jg0aS7vlX+s
	 OAXzJIMThRIQZL9ySJ8FDZWwrA8YNSKTP2+FArrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.15 64/92] arm64: dts: stratix10: fix incorrect I2C property for SCL signal
Date: Wed,  9 Aug 2023 12:41:40 +0200
Message-ID: <20230809103635.802256673@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dinh Nguyen <dinguyen@kernel.org>

commit db66795f61354c373ecdadbdae1ed253a96c47cb upstream.

The correct dts property for the SCL falling time is
"i2c-scl-falling-time-ns".

Fixes: c8da1d15b8a4 ("arm64: dts: stratix10: i2c clock running out of spec")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts      |    2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -129,7 +129,7 @@
 	status = "okay";
 	clock-frequency = <100000>;
 	i2c-sda-falling-time-ns = <890>;  /* hcnt */
-	i2c-sdl-falling-time-ns = <890>;  /* lcnt */
+	i2c-scl-falling-time-ns = <890>;  /* lcnt */
 
 	adc@14 {
 		compatible = "lltc,ltc2497";
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
@@ -162,7 +162,7 @@
 	status = "okay";
 	clock-frequency = <100000>;
 	i2c-sda-falling-time-ns = <890>;  /* hcnt */
-	i2c-sdl-falling-time-ns = <890>;  /* lcnt */
+	i2c-scl-falling-time-ns = <890>;  /* lcnt */
 
 	adc@14 {
 		compatible = "lltc,ltc2497";


