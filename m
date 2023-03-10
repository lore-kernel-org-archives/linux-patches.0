Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6191D8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CD9C4339C;
	Fri, 10 Mar 2023 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456952;
	bh=RuZiY6yLzvYHFG0mh9YDrMKd81C9VY6sdaK2qMlPu18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLP9qapGBlelRXHk6Nop8Xr3Fl9UnhC85GLODOXOI3+bnDBTewZqXGaU08K2IRCDr
	 iJQuQFpWVW+kN3fysyG8Jk48aJ0/J7my7J15rjFvqxogoozA2nCYTASb5cvUQjdTev
	 RhtTVGrKsVMkqAaeRzzh1ueyjh3rgut5WwCgJjHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Moon <linux.amoon@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 141/211] dt-bindings: usb: Add device id for Genesys Logic hub controller
Date: Fri, 10 Mar 2023 14:38:41 +0100
Message-Id: <20230310133723.028945726@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit b72654148e34c181f532275d03ef6f37de288f24 ]

Add usb hub device id for Genesys Logic, Inc. GL852G Hub USB 2.0
root hub.

Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230118044418.875-2-linux.amoon@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/usb/genesys,gl850g.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/genesys,gl850g.yaml b/Documentation/devicetree/bindings/usb/genesys,gl850g.yaml
index a9f831448ccae..cc4cf92b70d18 100644
--- a/Documentation/devicetree/bindings/usb/genesys,gl850g.yaml
+++ b/Documentation/devicetree/bindings/usb/genesys,gl850g.yaml
@@ -16,6 +16,7 @@ properties:
   compatible:
     enum:
       - usb5e3,608
+      - usb5e3,610
 
   reg: true
 
-- 
2.39.2



