Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2D41DE2C5;
	Wed, 19 Feb 2025 09:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956138; cv=none; b=EtASm6zKorBbJhpIQn3aEIj7Gk6X6vxHF+MyoJu36LTTDhXnsoCzbzq0+csqqDi23J0dtOd5yik9+8X4Ypnm/cmC/8DNmIMez7CkJvQerD4FZlfIepmgtv7CAH3E1rCiBYdy9EiNPqBPNsBpWqdbTKHXUC08BmYoRok9NRbukzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956138; c=relaxed/simple;
	bh=zKgRheXyjtH+x9/M6WY6ieuB1XvTBwl93MfWiazKm+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmNk297gbIy0vK6eshjGZrzpsVVDWT5Ji2M28JHH9TLu79lZaQHgxyl8Q+iv2Xm9KUo8Feis+x/kqSo3VgWcmVHKegvc7FJPPY5r08SA1KcGjVSxHdhHKF7EVSOdeziCjUNv4oLJrsEIT8RJu3nnHTKQYn0HKIOXb8BNPEqPnik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yz7H1kcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yz7H1kcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3139C4CED1;
	Wed, 19 Feb 2025 09:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956138;
	bh=zKgRheXyjtH+x9/M6WY6ieuB1XvTBwl93MfWiazKm+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yz7H1kcFP36gfKvRa6U5s6TdpGieLczYOk6B/6fZnN09ZSFjqAdFgPrcL4n7Bbxty
	 q6oXmd65HSMAowBuJmtY8Xt5aStNUw7vp3ZG+gS118vpFK2ueHEey9UP9cqjp675yn
	 XcirD1IXG+aU7iKSXYktxGB4hAVt+kKSMARNT9ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/578] dt-bindings: mmc: controller: clarify the address-cells description
Date: Wed, 19 Feb 2025 09:20:50 +0100
Message-ID: <20250219082654.703129899@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 802e3ca8be4df..f6bd7d19f4619 100644
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



