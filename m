Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E3D1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574ECC433D7;
	Wed, 23 Nov 2022 09:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196118;
	bh=x59k8a8dxn+UmFAVzcjKfgR6g/7yTXPX/lXKHoUuAsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3S4iEIxAOFkUjc6W6QfkLidozeq5bLfWqrdXuud7DD4+ECAdcKd0+gUxIoBW/dZS
	 BNKwJqpbSQBRvkKq0uju9F+1SlFrCGFq+cKEVSs2YRdJzxuHhEg0JA28uWfA2e4WH7
	 xiNnGM/WSTH5Nm6Sjg4yZxCVAwYyfoFyHZclDBxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 123/181] slimbus: stream: correct presence rate frequencies
Date: Wed, 23 Nov 2022 09:51:26 +0100
Message-Id: <20221123084607.689013782@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit b9c1939627f8185dec8ba6d741e9573a4c7a5834 upstream.

Correct few frequencies in presence rate table - multiplied by 10
(110250 instead of 11025 Hz).

Fixes: abb9c9b8b51b ("slimbus: stream: add stream support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220929165202.410937-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/stream.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/slimbus/stream.c
+++ b/drivers/slimbus/stream.c
@@ -67,10 +67,10 @@ static const int slim_presence_rate_tabl
 	384000,
 	768000,
 	0, /* Reserved */
-	110250,
-	220500,
-	441000,
-	882000,
+	11025,
+	22050,
+	44100,
+	88200,
 	176400,
 	352800,
 	705600,


