Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3F22F430D;
	Tue, 17 Jun 2025 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175718; cv=none; b=QjkYj6gKFaD/pVi3vHIcWZQ+0yl8uSvMKf90wjdsGSj6gXLzzl1RaxR+8901XXvsOOj5EoxZuKUaRDSQe9K1Tx+SYEIruQFKndYygqd1tqB5pGM8RMNuby62h+NV7HyyLOBp/Q41fjtmiW6xnKhYpCypfqy/xaEW7XRxeXl/ZOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175718; c=relaxed/simple;
	bh=ke7Hh5J3uKUCRbLvLhgfnchaC6OP7RxJ11V36077Skg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE3jvO1D/NH9dzw6Wf+fb9vEEyPnaE+fXQxIDjj65SGu82krFSyOzgMWNoNWy4FuhryW2k6ujFSplaGk6MsHlU423WlAOxR3/7bTyLWDYVx8LkMYlGyh1B9qzymQ7jBnXcpn5IsrGoGXNtWg3OuE/8iap4pjfnz2ngUff7Zlz68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvyehRSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvyehRSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07852C4CEE7;
	Tue, 17 Jun 2025 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175718;
	bh=ke7Hh5J3uKUCRbLvLhgfnchaC6OP7RxJ11V36077Skg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvyehRSW4RtYEWVDef8/5Mtbc1+mnXljjfYZ0mMn0erFWaq8JfyYwgsDDM3tIDSg5
	 bn0SZqyMNGSPpbF9KoJCnEuW9q2Yc3lJLCRXHPxs0rWGzNJKemaafJvzQnrEH2OElw
	 bajCsKJDkb4D6JsWi7+eLI0hGY6rj4+JRoFWSN7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/356] dt-bindings: vendor-prefixes: Add Liontron name
Date: Tue, 17 Jun 2025 17:25:00 +0200
Message-ID: <20250617152345.662799215@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 9baa27a2e9fc746143ab686b6dbe2d515284a4c5 ]

Liontron is a company based in Shenzen, China, making industrial
development boards and embedded computers, mostly using Rockchip and
Allwinner SoCs.

Add their name to the list of vendors.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20250505164729.18175-2-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index dc275ab60e534..7376a924e9aca 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -773,6 +773,8 @@ patternProperties:
     description: Linux-specific binding
   "^linx,.*":
     description: Linx Technologies
+  "^liontron,.*":
+    description: Shenzhen Liontron Technology Co., Ltd
   "^liteon,.*":
     description: LITE-ON Technology Corp.
   "^litex,.*":
-- 
2.39.5



