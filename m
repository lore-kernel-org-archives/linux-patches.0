Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048649;
	b=4ufNSnWjVLWjrKxqREH2se0Q8CVz6BoBvkVP0f/i3rPjjoDSEfLO4iti8UVjWcXyYqCk
	 qdPrZVdACEqPM/WOTs5FNAjTnEwJvtoDjRmGP2db73HjEZukzuOIk5pzr0spGOK6Ng3qB
	 qDrn53pEXlsqKm50fscZifc3TNKawFc1/9t88VoIQLRNN5eyQs5FyGh6IM/z95fwfIruP
	 e+mY1M6GOfGfyu0xyHnmfJ59AoddEiKjFD82+9R1arzLmBC5a7zU2h51uy0XxwpYjLcPR
	 lmB3/oeuHzU1Kh6VStPo8zgyJY46FIDFjmoH5EZ4WQvtnFpaRRHxKNDHlnKR+Fx/tMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yXUD3b8DxNgzXCOtJ65k9fdFyMhj3rLbsVO+IuMSVak=;
	b=g5DssH6W1VljK+AzJ8g7yWJYjMYhMuoGkRu9DmC99CJHRAIjZk/4qc2Lh3DRkbpbJLj2
	 gtyVMbwRCsJyeCvgfhrFA8kDMomW3ysYh6Qj5pLzRw+PecrzfmbyUF9EtCQAD1sdIdvDO
	 RgHThOyMsIYkZcYs7jr25/oHbs7vhoxw7vjg97US6SC3xhUI+PJLba4yuIi4ZbM2g/Owi
	 nI+nVp8LLtT0CaNw3/qup9+RrzAhatCalaeaLNzODC5K8cPMvXVd1x/+FPltJkSrNH1Pk
	 /rzH//ceEppPiHSqnRZic2q38G5f0HKFSMqe/9fDa7udsgwrNzhUsMhfMA9JlQGlmdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V/0SGN/a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF9C60A2610;
	Thu, 19 Nov 2026 00:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V/0SGN/a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BFD1F000C6;
	Thu, 19 Nov 2026 00:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048649;
	bh=yXUD3b8DxNgzXCOtJ65k9fdFyMhj3rLbsVO+IuMSVak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/0SGN/a+TCDnH1EDX6/qvvcjXca8YYeLkLdQRBtur6jq6xdhcPef+OLLKo/9Lnkc
	 ZWaRk/SEEwgpSunpLRGBqwkcuj5K3T7dOukVQhU67gv9OAsFXMLEvVC/CLkF1g5LLw
	 xNQJDndRvZM8B8XRhkjmujvCKIJJFJNkCaRoB8KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2069/2857] dt-bindings: vendor-prefixes: Add Chip Wealth Technology
Date: Wed, 18 Nov 2026 15:51:43 +0100
Message-ID: <20261118150315.915518847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 058ee00216a1356e710446b59a800065d2abbd80 ]

Add an entry for Chip Wealth Technology (https://www.chipwealth.com/)

Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260727-ayn-qcs8550-v9-1-e3db456e10e5@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 2daf0cf31023c..5ac28adcf572a 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -250,6 +250,8 @@ patternProperties:
     description: ChipOne
   "^chipspark,.*":
     description: ChipSPARK
+  "^chipwealth,.*":
+    description: Chip Wealth Technology
   "^chongzhou,.*":
     description: Shenzhen Chongzhou Electronic Technology Co., Ltd
   "^chrontel,.*":
-- 
2.53.0



