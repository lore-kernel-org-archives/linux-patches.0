Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FAB144609;
	Tue, 23 Jan 2024 00:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969534; cv=none; b=CWta+AdquvecGR4FQOmct8ot3CZYdCOb0fxKrMDJmJKvWUwYZoYrGlnj1IhYcqHU+0x2wol2WsNlCTIbOXmFNINjy1IqeHAlp9ppprTyZ9boF1IVmnDG9EPeHAkYYp+ryanwdcbXb1CZKNLy/iTC8O4R+C+HfdJgquEUgIyRH2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969534; c=relaxed/simple;
	bh=xQH5g176OSWTOmxHC+vUzRLVjK7mBATMaW8d/VP2GAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNIt4wtdGIGVYxyhYPVylsnkdeahv+LcE1dBa+cBgoB3kjrVM7a5sdlCDb+tVH6GGdJdwN30Cc7rBYoNzyzt1Somw9gVz6INYvQGfznqX6j7yEpnZZINHEje/KhKbXmhvhOZS66b4uTJ8hd+kY8UbzxVaIYH7HjJ4X6WKH9qako=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N020bz3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N020bz3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D76C43394;
	Tue, 23 Jan 2024 00:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969534;
	bh=xQH5g176OSWTOmxHC+vUzRLVjK7mBATMaW8d/VP2GAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N020bz3ubgVzKTMOfcNYILcTVq7w4uOjxuoCc96wscSt+a5fHMVpjhqoUXMTXQFl6
	 /TV+9OJP8EYwidoaBzvbY1JfBTYygaXlS82Q52p7TCG/+Q/k7r7yxXYUBCb0698zeK
	 v1XmXxg4AIpkZki907SBQNmLYn9JyLBaz7eE5l1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@bootlin.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 309/641] media: dt-bindings: media: rkisp1: Fix the port description for the parallel interface
Date: Mon, 22 Jan 2024 15:53:33 -0800
Message-ID: <20240122235827.581693949@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehdi Djait <mehdi.djait@bootlin.com>

[ Upstream commit 25bf28b25a2afa1864b7143259443160d9163ea0 ]

The bus-type belongs to the endpoint's properties and should therefore
be moved.

Link: https://lore.kernel.org/r/20231115164407.99876-1-mehdi.djait@bootlin.com

Fixes: 6a0eaa25bf36 ("media: dt-bindings: media: rkisp1: Add port for parallel interface")
Signed-off-by: Mehdi Djait <mehdi.djait@bootlin.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/media/rockchip-isp1.yaml      | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rockchip-isp1.yaml b/Documentation/devicetree/bindings/media/rockchip-isp1.yaml
index e466dff8286d..afcaa427d48b 100644
--- a/Documentation/devicetree/bindings/media/rockchip-isp1.yaml
+++ b/Documentation/devicetree/bindings/media/rockchip-isp1.yaml
@@ -90,15 +90,16 @@ properties:
         description: connection point for input on the parallel interface
 
         properties:
-          bus-type:
-            enum: [5, 6]
-
           endpoint:
             $ref: video-interfaces.yaml#
             unevaluatedProperties: false
 
-        required:
-          - bus-type
+            properties:
+              bus-type:
+                enum: [5, 6]
+
+            required:
+              - bus-type
 
     anyOf:
       - required:
-- 
2.43.0



