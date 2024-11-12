Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACCE2309AE;
	Tue, 12 Nov 2024 10:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408046; cv=none; b=MExhxUfFgIDh/vPzzMk9eb9KFwKrUiJC3IuGYCtyOuciicuYxlTkR1wHBckm4Gu1dl0p2Jzuq/Kt4o6+cYue9z6AoV1Hyg0pUNnA9lkud53RLl5zSMHqZnDuYhaDou2CPVlxu8JmF3w7q36ZEp+WrCQPTxnOjoKd5Lq3YoIt6a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408046; c=relaxed/simple;
	bh=BFvbITjshpdntVzQDsIUpXKT4kH/u8/pigm8HRQwnzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DH1gObo/DDf6q7VXmLz4Q/lbF8/SfD6d5wVG3K/SmMFTXY8jw4/cQ8wUpQiWT0KGKLb8RxMLsNkm6LWEztmd+bKYFaWC/6tw2jhJf/uij2jkFI+UlqAXg5TSjoZlyAf26SUCoNx0MXwj//KOQOgbs8rfCLJ6M+Uf6VGm2iTccww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3ScMY/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3ScMY/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A996C4CED4;
	Tue, 12 Nov 2024 10:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408045;
	bh=BFvbITjshpdntVzQDsIUpXKT4kH/u8/pigm8HRQwnzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3ScMY/bngfjR07XOJa5ODHOLqY7H2qujO53pyMjDnd3bRc0pnosTThEMI5FH07NQ
	 73FGXcOuOINHUSrvEBmTTtuYTia5akoYQfV7Omk9pGDLrt+M67aFXo188nZeRQKPzL
	 3os1xaCdko6pA+/UpLFq8ifO196DzlH7O35gd/AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 043/184] dt-bindings: net: xlnx,axi-ethernet: Correct phy-mode property value
Date: Tue, 12 Nov 2024 11:20:01 +0100
Message-ID: <20241112101902.518416775@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Gupta <suraj.gupta2@amd.com>

[ Upstream commit b2183187c5fd30659b9caccb92f7e5e680301769 ]

Correct phy-mode property value to 1000base-x.

Fixes: cbb1ca6d5f9a ("dt-bindings: net: xlnx,axi-ethernet: convert bindings document to yaml")
Signed-off-by: Suraj Gupta <suraj.gupta2@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20241028091214.2078726-1-suraj.gupta2@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
index e95c216282818..fb02e579463c9 100644
--- a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
+++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
@@ -61,7 +61,7 @@ properties:
       - gmii
       - rgmii
       - sgmii
-      - 1000BaseX
+      - 1000base-x
 
   xlnx,phy-type:
     description:
-- 
2.43.0



