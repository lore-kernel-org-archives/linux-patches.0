Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB181DFED;
	Mon, 27 May 2024 19:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836733; cv=none; b=rI0p5q65ZflBwG90lZ4eFVXqa2TZPpnvZj3VF0jR2MhJTvdigbY44z16mxniJ8uKstNgcmck7IZr6AgsdID5bp9tfk2KY8XBJJyyw97D6M1p4BWKOE7p0SVWjId1c+fZlVWmsDiJESxKz50OP4RsXM0T9Ob+Git/wb2e90xMCUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836733; c=relaxed/simple;
	bh=pYiT2Bwv2U4Dj9prs7we4rJ3xP/RiWXoKzlUucYTUME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbIb1c6BUSyX21sJCkQ0fjUQZgacaMqhc7raYCrD4VD3iKAz7iDJ6QclSlgchzjcavPjGMEAc4LNAdTc02gTCi20+sLP6eYpZ96BizbpdlyzCGgVLxGeGmbuoRB1tMzm+jXKr5uXHlTl9cjhltQzRqX4C2HA98NGujg4t+RWejM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZq+rsgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZq+rsgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E10FC2BBFC;
	Mon, 27 May 2024 19:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836732;
	bh=pYiT2Bwv2U4Dj9prs7we4rJ3xP/RiWXoKzlUucYTUME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZq+rsgJU8WrGqPUx3McNL1gMfILA1ImtP429GPMv1c/hGaLB1mnH5Zaccseha00k
	 7Br/T7LvnB39OqVyDniM2ubO7TnD9mn1IkQAtRPeo2kmv8wjAaDENhUlzUICzo/s3h
	 uk1OxZ6BkFDvhlr+Ua1Pl40Uu0cQR5/rONisfMsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Rob Herring <robh@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 165/427] dt-bindings: thermal: loongson,ls2k-thermal: Add Loongson-2K0500 compatible
Date: Mon, 27 May 2024 20:53:32 +0200
Message-ID: <20240527185617.796024134@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit 25c7d8472f6e90390931e93f59135478af3e5d86 ]

The thermal on the Loongson-2K0500 shares the design with the
Loongson-2K1000. Define corresponding compatible string, having the
loongson,ls2k1000-thermal as a fallback.

Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/26524a63abd2d032e4c45efe6ce3fedb46841768.1713837379.git.zhoubinbin@loongson.cn
Stable-dep-of: c8c435368577 ("dt-bindings: thermal: loongson,ls2k-thermal: Fix incorrect compatible definition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/thermal/loongson,ls2k-thermal.yaml       | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
index b634f57cd011d..9748a479dcd4d 100644
--- a/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/loongson,ls2k-thermal.yaml
@@ -20,6 +20,7 @@ properties:
           - loongson,ls2k1000-thermal
       - items:
           - enum:
+              - loongson,ls2k0500-thermal
               - loongson,ls2k2000-thermal
           - const: loongson,ls2k1000-thermal
 
-- 
2.43.0



