Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE802673AA;
	Wed, 20 May 2026 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295121; cv=none; b=GmQF+noEfAyQefj3wPHJGdhqEgQfaiClm2pdgHVScfk++UkPqTf4nVm6dJzhkgt9pncueZsIvPY7P54MG8sNW7qeS85tyfMDBt57wB8Q+qP4BYD/W7pJdfGPiKMxGGaJ3vQtEboyQT4PRxXg8BxmJzXlXflp88JXXiyUJXEwJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295121; c=relaxed/simple;
	bh=DzdM7T6Sqt+PbTI/f56XHxKz4bL0o+SmV8KskWBfWSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7rV3dEk0a4GSzsAY8F34GENlcJHh9n2Al8TvcX+SACrVn9RKMsU6+YeSm12fITw4tGu5PnULWM5STq+pevnlwf9MPbYjnc4hnDpf7Nh0nO0Kpa0Ek2HXm8ArnK/WnM5t87kzpRKRToxmglhyjlxeB2qTJPybLFwrVcYIKemN4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHaQrERF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHaQrERF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A148E1F000E9;
	Wed, 20 May 2026 16:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295119;
	bh=9IkyTZ+YMKjJyCLWNgo6MqWHpB+etrPDPeS5Z4vVs24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHaQrERF43TPIc6u7ik3pUdJaPv54Fuh0cjb/JbHkc2e7zKXkwxIeL1ggOL9PHzXK
	 A9zS5jzgvNaaiowzroLZXkujaSCjUuNZs8eoSoIwL6GNB9EmLHgKpe8TOyFIY0mXzx
	 x0D61uD9/ecoA19KZscGdkgpGZJV+viKUxOObDHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robby Cai <robby.cai@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0296/1146] regulator: dt-bindings: fp9931: Make vin-supply property as required
Date: Wed, 20 May 2026 18:09:06 +0200
Message-ID: <20260520162154.911835946@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robby Cai <robby.cai@nxp.com>

[ Upstream commit d342f5e355aaa4ff4fb5bd4a4aab70ed3a4f3c35 ]

The FP9931 requires a vin power supply to operate, so mark vin-supply as
a required property in the binding.

Fixes: 80bbdefdfb417 ("dt-bindings: regulator: Add Fitipower FP9931/JD9930")
Signed-off-by: Robby Cai <robby.cai@nxp.com>
Link: https://patch.msgid.link/20260313133102.2749890-2-robby.cai@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/regulator/fitipower,fp9931.yaml          | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/regulator/fitipower,fp9931.yaml b/Documentation/devicetree/bindings/regulator/fitipower,fp9931.yaml
index c6585e3bacbec..00d66b9230475 100644
--- a/Documentation/devicetree/bindings/regulator/fitipower,fp9931.yaml
+++ b/Documentation/devicetree/bindings/regulator/fitipower,fp9931.yaml
@@ -66,6 +66,7 @@ properties:
 required:
   - compatible
   - reg
+  - vin-supply
   - pg-gpios
   - enable-gpios
 
-- 
2.53.0



