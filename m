Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE3E3A8C2;
	Fri, 24 Nov 2023 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcEthtao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA89C433C7;
	Fri, 24 Nov 2023 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849451;
	bh=uT1LOeqCjcHhgoE2rwbY1eij3SBS4vjNHD9Ud5Jqz4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcEthtaoJGM8t28WeitcgudYxMx4EC1gouZl0ZEOD7kvack4vVQwlNnj+Uq52AgDP
	 hU4++wQb0pjkeMm38Jgg33q+fDjk2P/Pcz9EB1+PxvpFTiZEIXuAlNdorjJUh5DU6x
	 xrcnVxVqQ9uhGpxlkLjq3tB//Haycox1fDqVa+/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/530] dt-bindings: serial: fix regex pattern for matching serial node children
Date: Fri, 24 Nov 2023 17:45:28 +0000
Message-ID: <20231124172033.013029944@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 42851dfd4dbe38e34724a00063a9fad5cfc48dcd ]

The regular expression pattern for matching serial node children should
accept only nodes starting and ending with the set of words: bluetooth,
gnss, gps or mcu.  Add missing brackets to enforce such matching.

Fixes: 0c559bc8abfb ("dt-bindings: serial: restrict possible child node names")
Reported-by: Andreas Kemnade <andreas@kemnade.info>
Closes: https://lore.kernel.org/all/20231004170021.36b32465@aktux/
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20231005093247.128166-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/serial/serial.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/serial/serial.yaml b/Documentation/devicetree/bindings/serial/serial.yaml
index ea277560a5966..5727bd549deca 100644
--- a/Documentation/devicetree/bindings/serial/serial.yaml
+++ b/Documentation/devicetree/bindings/serial/serial.yaml
@@ -96,7 +96,7 @@ then:
     rts-gpios: false
 
 patternProperties:
-  "^bluetooth|gnss|gps|mcu$":
+  "^(bluetooth|gnss|gps|mcu)$":
     if:
       type: object
     then:
-- 
2.42.0



