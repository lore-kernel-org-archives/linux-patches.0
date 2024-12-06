Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9E753A7;
	Fri,  6 Dec 2024 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498272; cv=none; b=kDil7JGwIHdnXbeHB7my0IQTa2NZ+jyl4bxyEH68DBLXuRg8zy98i4/FNCIKwwz2DFyHt4lPOBTgwQnsu2B8g/hEz2c8dxPl2x49GqYYURR7wJoyGh1CO3znG0dmiz5s/HekPSVs5HDFHiPmadZLn8WStVabK6mLB7WwSb5B88E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498272; c=relaxed/simple;
	bh=yC5dlLunwOdBVuJ5Aet+8taqQYHc9Q94tycu4+clO0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEe9it4Fjwbob1oXoqXPaxkCKP2ys/N2bu0bYv9LO7YKf41ykuiwkOilc2w3hpAVpcfTd8VNYewnZZ0cH/cjIB3R0RbyI7TjxKKvlY0vnbY4QBJF7x/hlNVm+H1nH/G/MFi7SNCbDljTBQ2KJ1gZdOlPfCurx6NKApuSoQQPobA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efNrIFHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efNrIFHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1588C4CEDC;
	Fri,  6 Dec 2024 15:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498272;
	bh=yC5dlLunwOdBVuJ5Aet+8taqQYHc9Q94tycu4+clO0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efNrIFHJehJSq2K6PM9lKSqS/har3NyQQk31wfOP0ypQWJlxTBA7wVirwAswNpKem
	 jn0C29zo2ScUh4yfrM12f2rRbrxRpR8QDorQzfhuO/r5BXLG29RAT1dW0Zu8z+fmKs
	 tWK59LIjPOe0cOCwaJ0r+LD1z2VzPdrMJYfsE2/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.6 518/676] dt-bindings: serial: rs485: Fix rs485-rts-delay property
Date: Fri,  6 Dec 2024 15:35:37 +0100
Message-ID: <20241206143713.594766735@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Michal Simek <michal.simek@amd.com>

commit 12b3642b6c242061d3ba84e6e3050c3141ded14c upstream.

Code expects array only with 2 items which should be checked.
But also item checking is not working as it should likely because of
incorrect items description.

Fixes: d50f974c4f7f ("dt-bindings: serial: Convert rs485 bindings to json-schema")
Signed-off-by: Michal Simek <michal.simek@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/820c639b9e22fe037730ed44d1b044cdb6d28b75.1726480384.git.michal.simek@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/rs485.yaml |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/Documentation/devicetree/bindings/serial/rs485.yaml
+++ b/Documentation/devicetree/bindings/serial/rs485.yaml
@@ -18,16 +18,15 @@ properties:
     description: prop-encoded-array <a b>
     $ref: /schemas/types.yaml#/definitions/uint32-array
     items:
-      items:
-        - description: Delay between rts signal and beginning of data sent in
-            milliseconds. It corresponds to the delay before sending data.
-          default: 0
-          maximum: 100
-        - description: Delay between end of data sent and rts signal in milliseconds.
-            It corresponds to the delay after sending data and actual release
-            of the line.
-          default: 0
-          maximum: 100
+      - description: Delay between rts signal and beginning of data sent in
+          milliseconds. It corresponds to the delay before sending data.
+        default: 0
+        maximum: 100
+      - description: Delay between end of data sent and rts signal in milliseconds.
+          It corresponds to the delay after sending data and actual release
+          of the line.
+        default: 0
+        maximum: 100
 
   rs485-rts-active-high:
     description: drive RTS high when sending (this is the default).


