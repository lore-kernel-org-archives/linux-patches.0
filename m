Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454FA268C4F;
	Tue,  8 Apr 2025 12:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114293; cv=none; b=KxcJ/5wjDv0Ji9v3GOffcETqTHxLBwWtSz+OKzmDFXzKA8S64X3equ/VLeRmzBYswWqijR65e2iEjbuSHG1vQYTNWfzU89Ak9+c8onsB1KFGmkqE8CxSAh7D5lqjwgtyywo6pfYhC/xk6IkhY5/TMMpPXlVI3jDd8fzVcJ5cako=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114293; c=relaxed/simple;
	bh=2oSSo/d99f4RuMnJuqJsiKGicPgpPEq2ykIuW8dxfDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCkWSZ6BzLycFk0m0rRlRVA/9dVmGWNkZ6xMwZ5oBkRZGmTqYFHM0XbRGnVY+9lrjMwEqoqtI3D2BrinFLOBE1CHw+1h51y60QP2ET/UcyUl0K3ESbeGXP7JMcuYO1dgKoR5h/a3idfNzkuulcf9PxO8aan01M/Vsof1bETHdnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fK+LeV8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK+LeV8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8630C4CEE5;
	Tue,  8 Apr 2025 12:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114293;
	bh=2oSSo/d99f4RuMnJuqJsiKGicPgpPEq2ykIuW8dxfDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fK+LeV8nfWLkK9ORMUIKarhZ41xN/uGQUylPBH2hAuXpQFMkCwXoAT5y4byoAVgRu
	 RC70VH9ri6oNJ08Me8kMwKDxKHJe3a9hHByCdPrm4LNWJAuS2zMwPzvnFrOWG2dpiM
	 TnZvXfXi62ppHLl+CaUwW/vB6K62T9RfD79+ldco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Maud Spierings <maudspierings@gocontroll.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 054/499] dt-bindings: vendor-prefixes: add GOcontroll
Date: Tue,  8 Apr 2025 12:44:26 +0200
Message-ID: <20250408104852.584558520@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maud Spierings <maudspierings@gocontroll.com>

[ Upstream commit 5f0d2de417166698c8eba433b696037ce04730da ]

GOcontroll produces embedded linux systems and IO modules to use in
these systems, add its prefix.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Maud Spierings <maudspierings@gocontroll.com>
Link: https://patch.msgid.link/20250226-initial_display-v2-2-23fafa130817@gocontroll.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index da01616802c76..a985e22f9241d 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -589,6 +589,8 @@ patternProperties:
     description: GlobalTop Technology, Inc.
   "^gmt,.*":
     description: Global Mixed-mode Technology, Inc.
+  "^gocontroll,.*":
+    description: GOcontroll Modular Embedded Electronics B.V.
   "^goldelico,.*":
     description: Golden Delicious Computers GmbH & Co. KG
   "^goodix,.*":
-- 
2.39.5



