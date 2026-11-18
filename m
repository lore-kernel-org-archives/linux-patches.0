Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040204;
	b=BQRhqRyxN3AyjyVNy8SiT88YmcQOk+W+aDJIGF671ZF0XwdAYQ56fP6zrjF82URhUY/C
	 zjd2D6LieO3CDg+mFXQQ39vFCjj5QrXwxmBUzT3nsnym0sRfS7/mXEOMBWO4X9RdRvGUB
	 2xvDKytOHAy6b99ctxMGgj+26W+AQRqZvcA8JtNp/ZVsZIVhdqoV1lu6Gwezvxg+wxZuO
	 4DbkMocr9zO8V/nXWffyg4p2wBVE2gRpEbAM6ZgIaAScS30vR7j0K9em9z7Ot00pBY3OW
	 Dc2gGPOWJISZgwFBzHPS21eeFYrbSOmbbFNJXlSRWpi190IPTPTUl8DvfGaIYlR7PXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WGo7XOvVEXmb4DVTi2/Z6bzZvU0mIJSBowwGsdtLTBE=;
	b=OWzEI6ChJIwRIvztXfTr5EgnLTVTrWZVVVLYKRt9R7pKK9t+CzDrZBajlk9w3em9pD2s
	 BZo8BbNH6B387uR55UpGiV1x8gxFKdRc758VF6qmxO1I81l1ZH/vPshyGUPJYxMV5hvVl
	 Aut7U4SDNn7/e47dkV9UpKrgSZDaUJLvcaZkKLl12RmlcVe9yJm/QE3pLHskhOEFBlf/t
	 687RgHxXjP2eJ6AsbrSlO4MwPSV/eLt6K+bZn+9REiqACm5BTcev0/tSSQWOekAwrp8yx
	 XXtS3DRkXeJETxFoAXDaVo5JWh2o6K8RzAL4TSdpwlqNmPi1y1hjzzyqZE5FA2cypDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jgVy/N32";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D67606A31C;
	Wed, 18 Nov 2026 22:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jgVy/N32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248B31F000C4;
	Wed, 18 Nov 2026 22:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040204;
	bh=WGo7XOvVEXmb4DVTi2/Z6bzZvU0mIJSBowwGsdtLTBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgVy/N32WKY/MBxIx+ZdrJSYmJKW23LO3SlE5kPEGrVfhPI1oenFjDigb4GXdVXPu
	 BLiFEU6lSCemIuLQ4XtaOguzfw+joHv9A7vGjMcPWfjDiwIEZa5o6fMU391QrIvGPN
	 gQje+Mi51lLoW1v9UN7jn+2zMAF0f6P5EJtW2i2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2375/3318] dt-bindings: vendor-prefixes: Add Chip Wealth Technology
Date: Wed, 18 Nov 2026 15:49:57 +0100
Message-ID: <20261118150432.800616459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 58e6378c119da..5df24b8ebf647 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -260,6 +260,8 @@ patternProperties:
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



