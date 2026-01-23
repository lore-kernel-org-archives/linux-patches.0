Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CBD296BBB;
	Fri, 23 Jan 2026 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192445; cv=none; b=Ch+5nzT7nv6ko3d9DiY3ptXDRLQK9D9Pfn4L6G2YFaiXjtzfSEw8Cyc1vTOsxNUDjb7mnuzt1ISFHucjS2QgFm1I9mfzg3Gey61VAxv4LYDdrwsTyn3wQwTTpae5+Z/9YymOPEEor084eDJDB/dmCnIbV/QAIKUJWiMoBfGkhfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192445; c=relaxed/simple;
	bh=dHX8y3FqAr3oZW2LJ+xZJXB1vnxS35Mbou7CqzWgRCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMeEeVmjUjInP8n9KvoMm7qo3pEiOYKy2TMRQrXp1oJo4mbnExkeVKPh1C4lG/hq7d1PA5DvkUiGzQwmTlKh6qJfNMVlGKp7x4i/hFgvTEyPVRnysVo18w7QphQhZDjd21GXIJO82+Rm7isBWZC4KJKzPu7NDi9QDWKf8G3iqJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfJMLekW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfJMLekW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D684C4CEF1;
	Fri, 23 Jan 2026 18:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769192445;
	bh=dHX8y3FqAr3oZW2LJ+xZJXB1vnxS35Mbou7CqzWgRCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfJMLekW/tHE/D8V+0TV9MLrUhnuiF2QLTeDQqRBZYZSaIpxFtTmWpYAHWeglsEo3
	 +JBRCRH83vZ91kmTz7j90a9zyEWbq/CKZJ4HCxDYveLvnIRZ9ZVCH1ZTy49icexeZt
	 UbaxbPvAQRR/UqnNjcsI8x6cL3Wd55D4l0bU6f6OOGD5drLiMT0g1HJzRrVLfuU1wa
	 S4NS3bjK9t+yrYvt6prK0nKoNxEIR04hSfUkQY/F87naULYVU9Jb4+bE9gnu+HzdLr
	 fffKCeDDvyuIcCPJrDfvCSehwl4wNJkmxSxKNfIUSzOgHUexj0NBVv0xTXRFf62eC3
	 IS0Cqil4m5Dcw==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 10/10] dt-bindings: spmi: spmi-mtk-pmif: Add compatible for MT8189 SoC
Date: Fri, 23 Jan 2026 10:20:38 -0800
Message-ID: <20260123182039.224314-11-sboyd@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260123182039.224314-1-sboyd@kernel.org>
References: <20260123182039.224314-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

Add compatible string for the SPMI block on MT8189 SoC, which is
compatible with the one used on MT8195.

Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml b/Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml
index 7f0be0ac644a..dc61d88008a9 100644
--- a/Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml
+++ b/Documentation/devicetree/bindings/spmi/mtk,spmi-mtk-pmif.yaml
@@ -26,6 +26,7 @@ properties:
           - enum:
               - mediatek,mt8186-spmi
               - mediatek,mt8188-spmi
+              - mediatek,mt8189-spmi
           - const: mediatek,mt8195-spmi
 
   reg:
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

