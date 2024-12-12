Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8FD2165F0;
	Thu, 12 Dec 2024 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019184; cv=none; b=l5jTQgiAx550HDD3wml6Z9kcGO3tu8wB2IBLcLIDBRZOmIkkBIHaAuPkpCm0UQvqkvNM+FGUpL43pKzR5BaIRluzluD1GrSqXL4nSBk3CtCTuiA2aMvnTVRWO8x3syOrVTMnscBzSv7qo7HPX4uvvn31TbcZR9LET0rhMd2RFWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019184; c=relaxed/simple;
	bh=YoHEPQAN8r407efeJV+tvE6064Zk6aGq/uFRY8V/9Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAw+m9ANbsgl9I3kjgheD18fvhqd/MYcem7f5rGe3qwsMKOJVvIPv044mvMmkAZFmYAVWfOSFXATSn+qnLdqCuhKXgZA0Y/3QuzqDCmttVBw5JIs4x5il3jpFN8BEMcpK91OZoepJ4yref0VrXtNXIRNkV+zuRnN0aAvKbv2Tx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yo5TYpx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yo5TYpx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAC4C4CECE;
	Thu, 12 Dec 2024 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019183;
	bh=YoHEPQAN8r407efeJV+tvE6064Zk6aGq/uFRY8V/9Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yo5TYpx1jZoF5ATKt0jRe7YKB4NakqcCnVCVgiCNlnxiimW8ytXUZtFys2/9/pxvA
	 +x7woULJT6DHFLtLs2YwvwE5xlkLywH+VZxHg+Wd0E10BNaFf2WwxM8Aeu98QrxUWJ
	 +C2pnBmpSOOtbKK2FjLG+EpkZlngrjd/P9DoeG7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Prusov <ivprusov@salutedevices.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/772] dt-bindings: vendor-prefixes: Add NeoFidelity, Inc
Date: Thu, 12 Dec 2024 15:51:26 +0100
Message-ID: <20241212144355.757997001@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Igor Prusov <ivprusov@salutedevices.com>

[ Upstream commit 5d9e6d6fc1b98c8c22d110ee931b3b233d43cd13 ]

Add vendor prefix for NeoFidelity, Inc

Signed-off-by: Igor Prusov <ivprusov@salutedevices.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240925-ntp-amps-8918-8835-v3-1-e2459a8191a6@salutedevices.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 6e323a380294a..77e9413cdee07 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -869,6 +869,8 @@ patternProperties:
     description: National Semiconductor
   "^nec,.*":
     description: NEC LCD Technologies, Ltd.
+  "^neofidelity,.*":
+    description: Neofidelity Inc.
   "^neonode,.*":
     description: Neonode Inc.
   "^netgear,.*":
-- 
2.43.0



