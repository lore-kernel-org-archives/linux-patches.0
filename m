Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018232;
	b=K4V81MahaLOJA4EKsCY4SBDBRABl1515G53UKEZLE7XxmSa8Xq6Jee0u6cjd3s62kZ2f
	 mWaKOu0A6zesMqdHm6l3WaHBVNiKvB0ZLp1o6/HSsY/bMChn00heOwFtq/lED6SICcrEk
	 sQNoRmzgwzTdMUuJjiPNOImFmXBRldjz0pCy8vVCsp3b4MV7ztGybHJ72wefeNRaPX9II
	 BrUAAItqOHxcjP77QwfRe+9Sv8Jy8lDOHczfegy2QYuA2abI4qoBGApocgKltJSYfdBWo
	 2gBt0FnU+6ETUGdi8WanL5U3WGrToiRaSmI2/p+CBQGDCDNOsi2OyrCjJsDeDEczGvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z90qzirU7SywAUXU19fOeKd54Y05zgRgG68ZqAgcqmo=;
	b=4/mP4APKQxQ5cL52Qzw/nesefAtdolj5EpgslDRBn8JqH1iptIfGgnI5oN36qPAk2qb4
	 dEpzJk1c2RFIP0FlgjIJF9ZbVQdm2v9YODBTMiMqMeKgi/ScJlCuKdby2Dws69w4UBOUE
	 1FN3Dvl68QXVXGxwEZybgWe8z/M1akja0sv40RkB3yB5jZo0tLzVCcw5Yv2w7JRkZ+Vjl
	 YDqY6zMm4/g+fnoEysllt+ElZDWAepWm4VHOCeEMlWmSEDrmZaaMPJ4fgFq3F1RkYQ575
	 5mu9aDJoIGCMBRU1QKRrv+ZHEF6apfrPBv20PVLT5adUWAhP0vqeFaECwZ2XLEay0CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RkrchBIw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8899606A320;
	Wed, 18 Nov 2026 16:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RkrchBIw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1571F000C4;
	Wed, 18 Nov 2026 16:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018232;
	bh=z90qzirU7SywAUXU19fOeKd54Y05zgRgG68ZqAgcqmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RkrchBIwAe6HiujB/kbuYfTmMEyvqL47Jk6YEIe61VhRhQcVJYh5RQsd4Xbzv1IOr
	 fH9NWOHfxRIippRyXgDtzuUGgoBqDG9aHAAGBmS9R91562CrOtLa77frnifoiCb7Pa
	 x26fV0Y+B93Zuv6anh8oa1MksG463is/8G1JsF78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1166/2651] dt-bindings: timer: sifive,clint: Remove spacemit,k3-clint
Date: Wed, 18 Nov 2026 15:40:06 +0100
Message-ID: <20261118150329.988611695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit 5397ba147c28427d3728812dec999fdab0f53619 ]

The SpacemiT K3 implements separate ACLINT MSWI, MTIMER and SSWI
devices. The existing spacemit,k3-clint compatible incorrectly describes
the SSWI register space as a legacy CLINT.

Remove this compatible, as it never matched the actual hardware and
has no remaining users.

Fixes: 6cdeb30db4d8 ("dt-bindings: timer: add SpacemiT K3 CLINT")
Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260918-k3-aclint-v3-4-cf4fd4050e14@pigmoral.tech
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/timer/sifive,clint.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/timer/sifive,clint.yaml b/Documentation/devicetree/bindings/timer/sifive,clint.yaml
index 3673836e14dee..d53f52e80d887 100644
--- a/Documentation/devicetree/bindings/timer/sifive,clint.yaml
+++ b/Documentation/devicetree/bindings/timer/sifive,clint.yaml
@@ -34,7 +34,6 @@ properties:
               - microchip,pic64gx-clint # Microchip PIC64GX
               - sifive,fu540-c000-clint # SiFive FU540
               - spacemit,k1-clint       # SpacemiT K1
-              - spacemit,k3-clint       # SpacemiT K3
               - starfive,jh7100-clint   # StarFive JH7100
               - starfive,jh7110-clint   # StarFive JH7110
               - starfive,jh8100-clint   # StarFive JH8100
-- 
2.53.0



