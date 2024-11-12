Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21C81CBE8F;
	Tue, 12 Nov 2024 10:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407729; cv=none; b=T1ZTTfNso7eoJMQwgsa7hg5l/hmr+lNCZQa7vUCj2NACmLyhVOBTIwdD5rQIT8/rluG5KFAep80fu65PdH03BNSFZk8aD1rG23cnbzk8R0JuVO2pTP+cPRq3kZln+ZLTndJRZYGKrD8nQmkFHIrXaPMoJ1wr3+QbSgBPn/kW+Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407729; c=relaxed/simple;
	bh=bwD5icwAZDgihN2Jxg8m0UwQp1Id+Kf3+8E6W3DhsoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgLXZj55mcM5g6Y9Yk+1Eot9F39ERxvW08z3C8NyL54qYmgpOVSK489x1h/zCMnCJmJ/sIOt1DzILyXJF+p3udGBrOcoQC2ydrwHxJ3nGVhXhX0FL3hqsctLBJVpQ26hHib3yImI+F2Ug6M7Iotadjz37Q8JM5olZ9fq//ic4go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0KRGmy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0KRGmy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E27C4CECD;
	Tue, 12 Nov 2024 10:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407729;
	bh=bwD5icwAZDgihN2Jxg8m0UwQp1Id+Kf3+8E6W3DhsoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0KRGmy+4WtGTAIe2gMcM+ykqdpUKYxZMy9wl6IxBtLow4JMvw4+F7l0dcXblvm9w
	 gz6rsxVIiBSF8EAM2jaliPu7eUHn+mcvrq37TQdAHe+c/UKYFHecslu0HS/IGdw7Go
	 jr5Dpfsa6QJMAYpPjfeCYNwMrkwd+zGQsV5ZMrgA=
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
Subject: [PATCH 6.6 032/119] dt-bindings: net: xlnx,axi-ethernet: Correct phy-mode property value
Date: Tue, 12 Nov 2024 11:20:40 +0100
Message-ID: <20241112101849.940775288@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 652d696bc9e90..f0d98c4705856 100644
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



