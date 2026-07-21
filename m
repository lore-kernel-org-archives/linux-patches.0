Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E77326D44;
	Tue, 21 Jul 2026 17:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655695; cv=none; b=O7lblRX8MOB8PG/f8342ox09dKuIj+wgbIByJFJ/CHcntNIzd6yrqPlfiAKYkBuGEaT4zW8kf/ASZiDW2h9uptF/HWneaxfkAc1L5zMwlxpQLwmgKb6kZmGTlPz+ROuSscELWx++AGrBywEzqsrxggklcX0Ljt6voloYiKPtWwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655695; c=relaxed/simple;
	bh=3JnyVryBUd/H17ct26eUD3MTAJWOCAOfFIG5v6WIwjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frYQEGpior11jvQucuUcVTt6c05LYCa+Fa7FCOk16cucCeyPHeeEyn5fptrWhcIJN4KAX50TyRSqLTObhHRHvN6AyOsdNtHUy7jglJ7QMTwuub+n1dS3XyJbV+2Js9JIwvS20rF3GekqiVbhYiNg9r4yYGkgJAfdkfEw0FRsSrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1rutryD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1rutryD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1CD1F00A3A;
	Tue, 21 Jul 2026 17:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655694;
	bh=9vRtXSdHBDz6Jf62zzIkbZWZVsNv9hAIY8PQd1wMItk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1rutryDkkc9GSDfsQsQB9aK7cICA26UYsnK0jH1yxMBRgdl/eKqsKInnyYjWwTgC
	 0PbOBz8b8V2b/ykJppsP5kZsMWI7pSe3Wc86STZrGPJLDJmIAhBuJ+0iK2+JeH5Dfe
	 dhreyopJp8PvCFzstdBv4Ud0xhcJpXB5b5mBGxj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0107/1611] dt-bindings: vendor-prefixes: Add Displaytech Ltd.
Date: Tue, 21 Jul 2026 17:03:43 +0200
Message-ID: <20260721152517.256295082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit 42112cff8cb78ff6120983ba71bd14d52ce9dccd ]

Add "displaytech" vendor prefix for Displaytech Ltd. .

Signed-off-by: Marek Vasut <marex@nabladev.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260422210806.80948-1-marex@nabladev.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index f1d1882009ba9e..a9cf85fd6fbec7 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -419,6 +419,8 @@ patternProperties:
     description: Diodes, Inc.
   "^dioo,.*":
     description: Dioo Microcircuit Co., Ltd
+  "^displaytech,.*":
+    description: Displaytech Ltd.
   "^djn,.*":
     description: Shenzhen DJN Optronics Technology Co., Ltd
   "^dlc,.*":
-- 
2.53.0



