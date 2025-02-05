Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEA8FC0B;
	Wed,  5 Feb 2025 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763622; cv=none; b=drf4unqSNHGRWA1uSrRTfp7glhB8rGgEBicR54uK9uIUYyWOBRgwwZFysJEvZJRU1/YAvcH/p6vpLJ40pKATvhZtXsbc0GjjOYT5xjQ6W6UQyNnhdqFEsKk+j8RsEUWLKvzL8l2XCgdSaVk68E9lgEfFWtV9xjUAA91KbqsrChY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763622; c=relaxed/simple;
	bh=NaUzkvJb19fGHoflLuFmWk+SHRJuK4nqmyg8tFPu/FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpH9+sS9/bb+gZ2C56q4FjpROpS8Kc/wh7CdC2urAv6tage8wetci8jBvROMAK0YgtNHrmuvAxADXQIrksPMm1oiXa+NWrKvyHdP5ZjhIgYhL9o3ILC+odd3WG1yybwjh+CBwXOaRll4GhBkFQX9+6VgXm7YTUfsc30HEkfYia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+FLcwkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+FLcwkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11508C4CED1;
	Wed,  5 Feb 2025 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763622;
	bh=NaUzkvJb19fGHoflLuFmWk+SHRJuK4nqmyg8tFPu/FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+FLcwkOcUBgANMfGMlJYA/sHm2uxgmIvyPFTH0lXb7GlNRa/fQLccNYlQsbQFM4I
	 7XsRleoZEP9VcRarboyfFd/e35l2d5OnIbTPWIt9dftdCmnuM83sV4QiheX9dv0fOS
	 1YN3N+3mfZNmWuRj7V8ilq10gYB2N0L0fE8Iv4iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/393] dt-bindings: mmc: controller: clarify the address-cells description
Date: Wed,  5 Feb 2025 14:39:39 +0100
Message-ID: <20250205134422.591994862@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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
index 58ae298cd2fcf..23884b8184a9d 100644
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



