Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C66FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52380C433D2;
	Mon, 15 May 2023 16:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169772;
	bh=TXKItwxrTfBoYe0oOuo94XUFSly+tpmtflGT5Hiac+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wbql/Gl2bTCg7RkKey7LgkWMXOo8OlGK3rBSk51IkCtSYcQYDh5pqR4jiWRuwV3wD
	 ciyhNp6XB+K2cQG8gq5PIoBjpZKOkBjSSRslypHyk1aK1WCIt3mZiQRZunPTewuYg8
	 /v2+dlOJQyIhsmKqQoz/6CFuO6A5xxF1aDBeHad0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 6.3 166/246] ARM: dts: aspeed: romed8hm3: Fix GPIO polarity of system-fault LED
Date: Mon, 15 May 2023 18:26:18 +0200
Message-Id: <20230515161727.613802135@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zev Weiss <zev@bewilderbeest.net>

commit a3fd10732d276d7cf372c6746a78a1c8b6aa7541 upstream.

Turns out it's in fact not the same as the heartbeat LED.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Cc: stable@vger.kernel.org # v5.18+
Fixes: a9a3d60b937a ("ARM: dts: aspeed: Add ASRock ROMED8HM3 BMC")
Link: https://lore.kernel.org/r/20230224000400.12226-2-zev@bewilderbeest.net
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
@@ -31,7 +31,7 @@
 		};
 
 		system-fault {
-			gpios = <&gpio ASPEED_GPIO(Z, 2) GPIO_ACTIVE_LOW>;
+			gpios = <&gpio ASPEED_GPIO(Z, 2) GPIO_ACTIVE_HIGH>;
 			panic-indicator;
 		};
 	};


