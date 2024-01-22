Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6A464A80;
	Tue, 23 Jan 2024 00:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971279; cv=none; b=WjxNq4jcEYLOmNx5+93Mst0rxPm9xalv2tI4BR4gE+CzxnHKdyc6m+fMQJLKgjN5soCVD44J+Kjgg1aa7Y4NMW3CPt6ER2/RkZwEM5N23Xl/jSm1Obd0efWuu6i/Ppz/n/Jo/NlXmxINwp5IOArlmpB1kWerwiZy/AVrZhWmk2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971279; c=relaxed/simple;
	bh=AJk5x1KbsVSiI+ByeRHLXWxYwlUcnNjbWzkjpZIFMm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5QffkH1WbiqqZNQMPaV94ucV+LsaukAB1G4YKIODR2ypr/aiZfk4vojiyTMG3UGZgd/KbKMn58CXJPjhSJm8xuWCDFtVOmxl5stPw5TCNZ7ucAOnlsMBu/KV5xMh9IbXgBW5FNRY3Hp4M+RfgBO4pY3r7fQSYSXL8u15lgP/OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xO5kMobW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xO5kMobW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA15CC433C7;
	Tue, 23 Jan 2024 00:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971279;
	bh=AJk5x1KbsVSiI+ByeRHLXWxYwlUcnNjbWzkjpZIFMm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xO5kMobWvFpEGFSuTAdEkw8k/YE9ulcrjqsO4DMaMU3w7G1ki5iYafcrL9dm2Lx9t
	 fYQjFISzcvitTXL2gqk0Je1lQl9DfWBKe9VeI5MndErL6g6Njw7N2MtRwWaVtHm2hC
	 ed56JsF4nA0o7qeXwMKWI/HncdUTYZh895VU1jPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@bootlin.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/417] media: dt-bindings: media: rkisp1: Fix the port description for the parallel interface
Date: Mon, 22 Jan 2024 15:56:03 -0800
Message-ID: <20240122235758.686465331@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b3661d7d4357..2a0ad332f5ce 100644
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



