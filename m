Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7CF32A3F1;
	Wed, 25 Feb 2026 06:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002789; cv=none; b=Y8jhg85i4MjfhtEF2Bw0m9gxTGQcAbDDzzabcp+uerUJLyogRELu888r6dvocRr9l8cB7gw1zmO10FLaTtiXxAjonZOYK1zjdOf0M81vT3HaO2Q0VKdt5FlhkpLQ3HNllMpoGGd5cRKcQs2MWkDpH4AQPr2V+IsnYrEzISJOdqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002789; c=relaxed/simple;
	bh=wWWBQ8qBC3SbFl6tfaDBzcM3z7o2ERJ5KdaTyKBmXow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mm3URhLhrxrCqqYJuvh40N15hBzdg3HnhWIccQLdeVeNCx9SfoSdXYr1kjJ4bWoPwjzEmwEFJ2eVUoH7o8s3Cyl3RF3cQPGqhWoAU/3qRoNeHpiFaeOLgaA1A2TOboGddn+c72/x0argk5Zve0R8QNzDTl5nku41UOFlFQ/SpBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwlU6A/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwlU6A/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF357C19425;
	Wed, 25 Feb 2026 06:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002788;
	bh=wWWBQ8qBC3SbFl6tfaDBzcM3z7o2ERJ5KdaTyKBmXow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwlU6A/aZWQnTG1y0ESING9DRG9IMPgzvdLgD7yjeuuHo0yXMuLnputbHjSaPX/i+
	 yBkkuI+g14z9FT9048UNIQw5uYY1A273Pzr3hC1cfjgS/e6CMy0h6Evy9SI2enQGc9
	 Bq0fqjmQ5fyXFAFlksi8KmyUu7lmdJzGFcc6FkhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 631/641] ASoC: dt-bindings: asahi-kasei,ak5558: Fix the supply names
Date: Tue, 24 Feb 2026 17:25:57 -0800
Message-ID: <20260225012403.795585684@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 80ca113671a005430207d351cb403c1637106212 upstream.

In the original txt format binding document ak4458.txt, the supply names
are 'AVDD-supply', 'DVDD-supply', and they are also used in driver. But in
the commit converting to yaml format, they are changed to 'avdd-supply',
'dvdd-supply'. After search all the dts file, these names 'AVDD-supply',
'DVDD-supply', 'avdd-supply', 'dvdd-supply' are not used in any dts
file. So it is safe to fix the yaml binding document.

Fixes: 829d78e3ea32 ("ASoC: dt-bindings: ak5558: Convert to dtschema")
Cc: stable@vger.kernel.org
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260212021829.3244736-4-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/sound/asahi-kasei,ak5558.yaml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/sound/asahi-kasei,ak5558.yaml
+++ b/Documentation/devicetree/bindings/sound/asahi-kasei,ak5558.yaml
@@ -19,10 +19,10 @@ properties:
   reg:
     maxItems: 1
 
-  avdd-supply:
+  AVDD-supply:
     description: A 1.8V supply that powers up the AVDD pin.
 
-  dvdd-supply:
+  DVDD-supply:
     description: A 1.2V supply that powers up the DVDD pin.
 
   reset-gpios:


