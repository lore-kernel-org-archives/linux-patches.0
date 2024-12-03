Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166DF5336E;
	Tue,  3 Dec 2024 15:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240821; cv=none; b=DuKH3DVgaHfZKQrd/3ZizrMCrUIIFkRLzldy58/HzlRaL2jKF7tnqLQzwFD27gqbbOlwTQkegDaoZw2xsRR/b6nT6DRfSDbwlNgo030Pf8kz+39asxY1CJYtbs7/gfgTHVVAdmSgpxZatPHyi6zGbXbxei9rbEXaefsQ/G+Pbq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240821; c=relaxed/simple;
	bh=LeX/DYeejuyuw92bcO8Aom5/WpIqOlkIl67kL9zF1Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+Q00wbIB/ZOdrFJOTUe1ew8uZlOGhBsxl8WKcX1NgYCJI6DcZMnZ4Fv8a6SddPvWqyZ+YPvaw3oEgaFDwiB6thpFbKhxMcrqjiadwo6ZXkV9YyXuZ7ZCuVoUO8zTh1I7W9cwS2nekiEu7Y1Ckq16BxxB+pJAAFB2QFgJtbaVvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lq07kJ2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lq07kJ2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DC5C4CECF;
	Tue,  3 Dec 2024 15:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240821;
	bh=LeX/DYeejuyuw92bcO8Aom5/WpIqOlkIl67kL9zF1Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lq07kJ2DogQVPwl6TYAnCa0vA1auLNQtN763oizxGHBa+1Tstu6+yhTtYY21QNxA3
	 YjPb+nHX00KQdJor/cnxmJ71tVkuEK2zrB6rQNLLHrQ1KjtpouqD2UOSdT3eT0HkiF
	 rkTRknh1h3Dx6jZw5EBVv7bu45wTju1zYadKeXAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Prusov <ivprusov@salutedevices.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/826] dt-bindings: vendor-prefixes: Add NeoFidelity, Inc
Date: Tue,  3 Dec 2024 15:38:59 +0100
Message-ID: <20241203144752.015107725@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b320a39de7fe4..fbfce9b4ae6b8 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1013,6 +1013,8 @@ patternProperties:
     description: Shanghai Neardi Technology Co., Ltd.
   "^nec,.*":
     description: NEC LCD Technologies, Ltd.
+  "^neofidelity,.*":
+    description: Neofidelity Inc.
   "^neonode,.*":
     description: Neonode Inc.
   "^netgear,.*":
-- 
2.43.0



