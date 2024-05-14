Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB451E4B0;
	Tue, 14 May 2024 11:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685796; cv=none; b=j7fGWAyWcIJ8E3XAuDwxq+SZp7oJCzL9UKWOesM/1UYFMcbh8FxDzCalixBYfkAVIJ6aXJMOr/+CVC38dZdYGNO0NEiD7cO4GcyvxbTHZDvwAiv8vkGfL0FGt2fH5jjyJzCwuXSlRUIbBBOUCN+HF5Uv58SYbXBKx/x/3WyiDu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685796; c=relaxed/simple;
	bh=uUVEHiK/2PMe1zySq0PDmYJaH+7ghOwymUVO56Li4Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmJ05tMztE528QekwdgAoRv5uISo8Oe67sXUW//Ur6/cvB8Zl4Rn8mV2MWC0KsWzA29LWXQ/hOTrKFSuNetZg+fKt6aET3L5Nk3rc0HGflRg3rNrh0v5H4+JLDwG0IKfEyK5UCMy80jED+G1hocnMTddx75H6Ek3kOuPff//yFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrTW4u2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrTW4u2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EDCC2BD10;
	Tue, 14 May 2024 11:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685796;
	bh=uUVEHiK/2PMe1zySq0PDmYJaH+7ghOwymUVO56Li4Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrTW4u2bUV/Qh1OmYmYx8kGxSBbVhUrQYuSpmsQuSiMbHmnGpEqbHZlHtisw8aski
	 /7aGlA4W3F3CPatwbRwxmIJ0/8al9isooA04N+Sfs9FjDOyFTWJjtI4xwMMpqCsIwQ
	 q9TosUJDN76hKmJH2B/NcRlRMXi5xtC1EUXNU5c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 248/301] dt-bindings: iio: health: maxim,max30102: fix compatible check
Date: Tue, 14 May 2024 12:18:39 +0200
Message-ID: <20240514101041.620117297@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 89384a2b656b9dace4c965432a209d5c9c3a2a6f upstream.

The "maxim,green-led-current-microamp" property is only available for
the max30105 part (it provides an extra green LED), and must be set to
false for the max30102 part.

Instead, the max30100 part has been used for that, which is not
supported by this binding (it has its own binding).

This error was introduced during the txt to yaml conversion.

Fixes: 5a6a65b11e3a ("dt-bindings:iio:health:maxim,max30102: txt to yaml conversion")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20240316-max30102_binding_fix-v1-1-e8e58f69ef8a@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/health/maxim,max30102.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/iio/health/maxim,max30102.yaml
+++ b/Documentation/devicetree/bindings/iio/health/maxim,max30102.yaml
@@ -42,7 +42,7 @@ allOf:
       properties:
         compatible:
           contains:
-            const: maxim,max30100
+            const: maxim,max30102
     then:
       properties:
         maxim,green-led-current-microamp: false


