Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017328;
	b=kay3QyUrUEHJLWdkDczlosoKVFXWbCxCv/42ZEzy1txxi48OJezUPV84lnRyq9Y/0vM6
	 NY7gP4tux1CJHpIvx+4q7YhzGSZzIURdc5NcNL/f6QNjvTExvkJ4GhA4Xn8EooAGwc3gc
	 G/3LcQpUKq/8dVg1cxq8uM85uNUd5o/kQbmRAySZE18/AqSXnRK0h2B9JOG6x747GqGzM
	 1DWSOZvnJAXyUwlnNRHVkIsGIdgZw/IUznNb39ogNdXfkCQ9z42bVxmIFfHxWML4UQreX
	 lvaHGeb6CoerSvsSoFtrEHfgdsPg5pMM2m7i4fP4HZj5pZQM/MqOveG2WPdrIBMDK+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=81jV1+eqzF1Eh0TPzJbqVpkJYIBShMVRN3FWIE9FDws=;
	b=npDw81/ViwlwAGwqSIUxokqPLq2CuRt2dRGIiXCt832ajDmQ5rnS3GyNI1bmp4ILuGps
	 79Ig6Fn2OIN8pHWvcxqTXIP4rza1fqYwqJIgugFgIGiG8DdNaqDtkJcSfClckK0rZ3X2d
	 j4A7DWH5GHsrPFl+rL8pM1dXRLQqpoxQC6ZurFF9qgZr/mdaAchhKEwnDFVm2LOa/nR83
	 PQy0AEkroOfTuiFTFZ98twpCvzUmWdWRJFrO+8MyRe7gT2RUENc/O64uyjSMWVGVNlwOX
	 64NKbYniM14ah6yl2nIm4b6BoI2or5jSmZVvdb2A1e4SJJmKEVg9MayucxKEL/D5JGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFhiFBmi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FF9606A331;
	Wed, 18 Nov 2026 15:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFhiFBmi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7177A1F000C4;
	Wed, 18 Nov 2026 15:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017328;
	bh=81jV1+eqzF1Eh0TPzJbqVpkJYIBShMVRN3FWIE9FDws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFhiFBmiu7iEBkSSddJ4Dl6rnInsJYGin1GuZ2FddUsF6scqh4/sXRFQusP61P6mW
	 uFa8t8uHCFKd8gUS28CRsaGBlXTCBM9xg3e9FfJHjmbxjNJnka2IX80N9s4Ltuan5I
	 joYQsSGbKEnnH6gWdjt0tkG2b0ZLh0ZB2RyxGri4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Muzaffer Kadir <muzafferkadir@mainlining.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0845/2651] dt-bindings: vendor-prefixes: Add General Mobile
Date: Wed, 18 Nov 2026 15:34:45 +0100
Message-ID: <20261118150318.301748710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muzaffer Kadir <muzafferkadir@mainlining.org>

[ Upstream commit 7034bec693b752bcd7ebb4fa00dc3b429b4dc4f7 ]

Add vendor prefix for General Mobile.
Link: https://www.generalmobile.com

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Muzaffer Kadir <muzafferkadir@mainlining.org>
Link: https://patch.msgid.link/20260921-msm8952-initial-support-v3-6-b96fd3fe298b@mainlining.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 8e7b69b9c1f9e..ba97798666cf7 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -666,6 +666,8 @@ patternProperties:
     description: Gemei Digital Technology Co., Ltd.
   "^gemtek,.*":
     description: Gemtek Technology Co., Ltd.
+  "^generalmobile,.*":
+    description: General Mobile Fzc.
   "^genesys,.*":
     description: Genesys Logic, Inc.
   "^genexis,.*":
-- 
2.53.0



