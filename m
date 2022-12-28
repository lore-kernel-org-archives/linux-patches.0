Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2B623AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E0FC433D2;
	Wed, 28 Dec 2022 16:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246679;
	bh=Wsda+XD+JwQsJLyyqlUbDKjCumuiyPp1cAJKGf+TYRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PObIXpUet5C/gztkc8Hy823sGFLU99eVlo1wl7M++tfzwc6wMiEg6z6aehDdXwEdk
	 CPRJzq15VfqH2qnoqkgXeYXGI1LZ2v4nO7QMNKgUIB79raVnOoMyA1esNMpC842Cje
	 LSQfY/YvNMF6+0O3UtEKgmTtyBYkZKxUpWSvsf/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Rob Herring <robh@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1096/1146] dt-bindings: input: iqs7222: Correct minimum slider size
Date: Wed, 28 Dec 2022 15:43:55 +0100
Message-Id: <20221228144359.940746334@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 99d03b54ef8506771c15deb714396665592f6adf ]

The minimum slider size enforced by the driver is 1 or 16 for the
IQS7222C or IQS7222A, respectively.

Fixes: 44dc42d254bf ("dt-bindings: input: Add bindings for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/Y1SRU37t74wRvZv3@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
index b4eb650dbcb8..913fd2da9862 100644
--- a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
+++ b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
@@ -498,7 +498,7 @@ patternProperties:
 
       azoteq,slider-size:
         $ref: /schemas/types.yaml#/definitions/uint32
-        minimum: 0
+        minimum: 1
         maximum: 65535
         description:
           Specifies the slider's one-dimensional resolution, equal to the
@@ -687,6 +687,7 @@ allOf:
           properties:
             azoteq,slider-size:
               multipleOf: 16
+              minimum: 16
               maximum: 4080
 
             azoteq,top-speed:
-- 
2.35.1



