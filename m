Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0599DC8FF
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A15C433C0;
	Mon, 19 Jun 2023 10:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170576;
	bh=VFkdDgufTkYR8yTESG6NXD+dY23pjlZxJMEBOt6Rw4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cROVp2QLc7f8h5LHBJa5WFJqdSOuvDSPD9eEbuQSz2MbfAPnopMsbW9SBZQ2zsuTT
	 fRdSdb+MKOF0cdsOqsEQq/Gs6CBE/Q4gvAtNbbBcsY6CklfY8uMLtjE6F52mLYV523
	 oshBpAVKSupTILUlllA9UksLkXrMRPyilOg+6zCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 4.14 12/32] nios2: dts: Fix tse_mac "max-frame-size" property
Date: Mon, 19 Jun 2023 12:29:00 +0200
Message-ID: <20230619102128.159752481@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102127.461443957@linuxfoundation.org>
References: <20230619102127.461443957@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Janne Grunau <j@jannau.net>

commit 85041e12418fd0c08ff972b7729f7971afb361f8 upstream.

The given value of 1518 seems to refer to the layer 2 ethernet frame
size without 802.1Q tag. Actual use of the "max-frame-size" including in
the consumer of the "altr,tse-1.0" compatible is the MTU.

Fixes: 95acd4c7b69c ("nios2: Device tree support")
Fixes: 61c610ec61bb ("nios2: Add Max10 device tree")
Cc: <stable@vger.kernel.org>
Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/boot/dts/10m50_devboard.dts |    2 +-
 arch/nios2/boot/dts/3c120_devboard.dts |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/nios2/boot/dts/10m50_devboard.dts
+++ b/arch/nios2/boot/dts/10m50_devboard.dts
@@ -108,7 +108,7 @@
 			rx-fifo-depth = <8192>;
 			tx-fifo-depth = <8192>;
 			address-bits = <48>;
-			max-frame-size = <1518>;
+			max-frame-size = <1500>;
 			local-mac-address = [00 00 00 00 00 00];
 			altr,has-supplementary-unicast;
 			altr,enable-sup-addr = <1>;
--- a/arch/nios2/boot/dts/3c120_devboard.dts
+++ b/arch/nios2/boot/dts/3c120_devboard.dts
@@ -118,7 +118,7 @@
 				interrupt-names = "rx_irq", "tx_irq";
 				rx-fifo-depth = <8192>;
 				tx-fifo-depth = <8192>;
-				max-frame-size = <1518>;
+				max-frame-size = <1500>;
 				local-mac-address = [ 00 00 00 00 00 00 ];
 				phy-mode = "rgmii-id";
 				phy-handle = <&phy0>;


