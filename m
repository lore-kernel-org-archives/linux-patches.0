Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD3C22D4C3;
	Mon, 10 Mar 2025 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628677; cv=none; b=jfr7w8yZjbwNrU0y2MVytVN6HcohmTD5zn9T3oBsf28ej2VGG5EtJFzdM4hcteiDZTSOz17Aa9rtl2NTFXbJPTLyi52RymKXM6Atvo1sEP6S6aUbBvAw/n2bO7tmwDk8Pp1FZLXckd2vzzguc9thQqKz99vV9k6IbpkmrdsSeyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628677; c=relaxed/simple;
	bh=XqgrkdWTh6sKVlSXuakEdV/bBPBWd2VWqAh4OpVLhzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dewj8tIaYIXKLzX+Z1zXSSeCBO5bj5QiZDXzDKsmXRZgX31yqot+Wws1G5T0wRwsGYdMV15iJA0Fg0GwsbkCyOamPSnU0Jh5131JXSdsCjzUsUsH0ERu+Hx3mOl/AZ1fHm04nlENr22dTbCne3XeDV+fRWRMJeX5TzySWHeY0ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZf1LgkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZf1LgkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0AEC4CEE5;
	Mon, 10 Mar 2025 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628676;
	bh=XqgrkdWTh6sKVlSXuakEdV/bBPBWd2VWqAh4OpVLhzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZf1LgkABQqaX+EpCZMyjX4q2Q/elGRWC2mvMwd+tP/OIy8HteZgl5xuQviaDUFIo
	 cmYsKFFj1CQ0z891qepmkrV7LAQQ4fP3nKK4VlA4I3fVyH//7bV1i4CxAGT4Xp3rqa
	 JxuS7k+mJm+P+A5zQkkVqJpVjtI2+47g/0y5Yl6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/620] dt-bindings: mmc: controller: clarify the address-cells description
Date: Mon, 10 Mar 2025 17:57:56 +0100
Message-ID: <20250310170546.770641680@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 25ac8e2009708..093bdad8daf82 100644
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



