Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628BA25E831;
	Tue, 11 Mar 2025 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706351; cv=none; b=tDEhXzLgrDCHaAMClWoMJ1XSSV2W5PsuPBYC812O+Cw0KDFo6Drl0EB0DFXVNt93O4+Iq9UJ2udpXQXYMxoWdgyZ/3DdPXhenzBEQeH64pFe1a73hAVghYKMqXPfUviOwcGfTnQQw7q7TJxIHNUbtGNVky4KE/qPFJdth4ltqM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706351; c=relaxed/simple;
	bh=NG6V5d4kpyBvz5Z3FDG9Ov2RS4cc4LKfx1Cg31sP2q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ7IAdNRyQlgkMVoYqEbLFLIW54biSdjeW8zj1brRiy65IavLv5ED8ibLOsh2mFvoiYrVjlun4C7cFQe6WbTlAPeip3zAXbJhDcxDShxg3eJF2XYjy4sYNHmAvbnMAHNCnRlUd2OX6i+NveS+30txNow9e7Yh7tVjEu+uR6pFOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tudfDOs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tudfDOs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD14CC4CEEA;
	Tue, 11 Mar 2025 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706351;
	bh=NG6V5d4kpyBvz5Z3FDG9Ov2RS4cc4LKfx1Cg31sP2q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tudfDOs3SBsSgCowq5Yi8koqwSMPC3rZIiUFE30XekVLxdNT91lNZRn8pwxR8oVbZ
	 39ExnCahFd86OYO8EBP6wchnG/LvPJZdQUQXTGTpvZ9N3hJ15avJ/pSemkpo9xnPK6
	 PZBeURlvXrpEHHtQsRh9bJdeylvtBrSmEcQNTd3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/462] dt-bindings: mmc: controller: clarify the address-cells description
Date: Tue, 11 Mar 2025 15:54:45 +0100
Message-ID: <20250311145759.109834585@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit b2b8e93ec00b8110cb37cbde5400d5abfdaed6a7 ]

The term "slot ID" has nothing to do with the SDIO function number
which is specified in the reg property of the subnodes, rephrase
the description to be more accurate.

Fixes: f9b7989859dd ("dt-bindings: mmc: Add YAML schemas for the generic MMC options")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Message-ID: <20241128-topic-amlogic-arm32-upstream-bindings-fixes-convert-meson-mx-sdio-v4-1-11d9f9200a59@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mmc/mmc-controller.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
index 186f04ba93579..b7976809d8f68 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
@@ -25,7 +25,7 @@ properties:
   "#address-cells":
     const: 1
     description: |
-      The cell is the slot ID if a function subnode is used.
+      The cell is the SDIO function number if a function subnode is used.
 
   "#size-cells":
     const: 0
-- 
2.39.5



