Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125A413CA93;
	Thu, 12 Dec 2024 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023867; cv=none; b=dmcVQ2LSsi/qp0X4WPTEfZwz+KBK+UJqdgk7X4pOwmyGjT3EmeFzEW3/61d1baIzO8DeUybjUaRdlC4tWwUKMJjQsfa9bxv2I7Sx58u1snNgDQJFQQg2Q1IDFKg+MJ9IxhbbIGFHmj9gZg9Q7GWpVlyINan+r7cJ9OdtYUToDGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023867; c=relaxed/simple;
	bh=G9vAWf3hjsSKU+fVUokDFFtpAjLgGkGv24yZpAei6eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGx2InfwLfsB4c6sbtjdxK0o9iOKOj/FrJqoBbGQaLTz6M7sOMDrEJ0wIOsfl7GHyHvD1/oWKMkyoZX02/NxhkaIB1ZgVT9BzTmoWtbMSjsZ2y+feOs7gbYhDOEyGDzuDek3BaljJJQanIC7+pinBczAWkvNI7P7XuhuULHHHNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8cpSJ9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8cpSJ9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1EDC4CECE;
	Thu, 12 Dec 2024 17:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023866;
	bh=G9vAWf3hjsSKU+fVUokDFFtpAjLgGkGv24yZpAei6eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8cpSJ9BX46XF3fZ2ghe1vp1At9eQcbXgK/fFN4fREfHoLcrmDk+qEwyKO23Cwn7K
	 rfeqDtiIbA+GyBiKx6tENBaWVzN9Z8CjJukGNCZBTwT9w/3aubwhWRnNDwE2GPUb10
	 WI61oA0eypwiGuwB8dWze/RDZtwv4Zh/CIdEqK7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Prusov <ivprusov@salutedevices.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/459] dt-bindings: vendor-prefixes: Add NeoFidelity, Inc
Date: Thu, 12 Dec 2024 15:57:26 +0100
Message-ID: <20241212144257.781503507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2735be1a84709..e04be09dd0291 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -718,6 +718,8 @@ patternProperties:
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



