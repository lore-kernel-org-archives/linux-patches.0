Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060778;
	b=bOcwf9CgIJ2gdWA7jOq+GDOomljS5VdW8bguPGHs1fJe7Xs1zMH+TRsj2ucSYGw2IAyZ
	 9WX6lYUmSzpgICEpFGhvKk3L0JgsQyo4CPqvZ7R++yiaqBXZBjkEOLMVYEZZVEyLpbqvb
	 5trbnyF4iOzyVdEA82gZ0BE/W5VstW8LQrrcTLfAHNEczq96HllVVTLjo4cM0ILdA+Tji
	 qiGlknW+5TWI6EXH0V/WEVX6fEeTTWq0gFv08MFrQ63bVMVrqWAJhjt+MmjpPeOhgLp1h
	 A7AC48QXpdb6Wte7sRx3HhQEMDskoL+6xiyvEUz5d8ZEseNqM+BNaw48176mDxZy/aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k8z7Of9iYf5C/h5jkgDbjCdcn5Ie69vQzKHGsYX5kiI=;
	b=GaYjE3VDDUcCCaj64x0AA7FFtROqjZ7HsyRfgJ3yAzc2uCkRApzGhyeLEee/yL2xeFmq
	 9Fv2ZYWLUv+RMtAw/iO0N3HWgF3h/RinEzXq2TLRn87cgdn2wH6oOFhv3ylineVd9EYB/
	 zVcN2dBvdMGHCBJIilMzBvfEonrKaAY7QBTd+/JqCOO4PV88Q6NCEVB+NNBK89w5FIgx1
	 ELwYIa35mPUSlBqbykBkAkvfLDkzwR4tusRPU2y39nfO3rHZJ6Yp+l00vimgRfUgpIiqI
	 fR3PW/CCGCYnEYOEyKycR3QeYJ1DLmZGmWdl5NqK+6BrYtitb5L9ayiyKzShX+28LUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4hrOgwP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECB8606A320;
	Thu, 19 Nov 2026 03:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4hrOgwP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7B21F000C4;
	Thu, 19 Nov 2026 03:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060778;
	bh=k8z7Of9iYf5C/h5jkgDbjCdcn5Ie69vQzKHGsYX5kiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4hrOgwPYZFARIEwDTulW4UaQTHjftwLH2djxijMZr+9Midf9w7i2ew4SJdKeXwfg
	 j3WAcFu3s9Xcks8ehU6AxmUgFOyPlR7aMCw68cuuVgFY/4Dr3pZbc1L/l0H6gpLzbV
	 7jiQEaMb7w2lY0HlV4dicpjDmMZJlDigC+KVkECI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Uvarov <i.uvarov@cognitivepilot.com>,
	Rob Herring <robh@kernel.org>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1320/1848] dt-bindings: add compatible vendor prefix for Forlinx
Date: Wed, 18 Nov 2026 15:55:58 +0100
Message-ID: <20261118150014.879374116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Uvarov <i.uvarov@cognitivepilot.com>

[ Upstream commit 157da630c7ff848439f721257f26655b5ae2d856 ]

Baoding Forlinx Embedded Technology Co., Ltd. is the manufacturer of the
Allwinner R40/A40i-powered FETA40i-C SoM and the OKA40i-C dev/carrier board
based on it.

This patch adds the DT vendor prefix for Forlinx in preparation for a
further patch, which includes a devicetree for the OKA40i-C board.

Signed-off-by: Ivan Uvarov <i.uvarov@cognitivepilot.com>

 1 file changed, 2 insertions(+)

Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210407111428.3755684-4-i.uvarov@cognitivepilot.com
Stable-dep-of: aa906abf611c ("dt-bindings: vendor-prefixes: add Free Mobile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 207a697009af6..aeb046d4b1d48 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -383,6 +383,8 @@ patternProperties:
     description: Firefly
   "^focaltech,.*":
     description: FocalTech Systems Co.,Ltd
+  "^forlinx,.*":
+    description: Baoding Forlinx Embedded Technology Co., Ltd.
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
-- 
2.53.0



