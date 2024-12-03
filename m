Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1AE1F8907;
	Tue,  3 Dec 2024 16:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242466; cv=none; b=igWLdNcoScJ5MmuHtwmLx6rZ66ynL9LgQkT22xPU9akZgk4wB2v4SBgQBA5KHthhqVDevowt9Yiexq74SJ5SbI2z9C3TITP5W+Ki14n1ywkg6K9ZY9QME5M3XguAd4o8kvy4rYAd3fl49JeLVOEVsO9EfeP0a1XMnMMRiUjuflE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242466; c=relaxed/simple;
	bh=ZoErjDthbfqxKHOVpqMBvnofjxSV1kq+PXpAVX4NEbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHXAjINhXuv4zjXkfKVT5Opd1ddtWplHjaNBs8JHc7LqjDMCvdDkO2YdWPFHDhAsd0Kv7ULigAluXASLh4VeeQyO5TDFY0IHNplP2qIT0TCbCYonzYsxLeLhvqVYgYsh5gnrbKXX9s78Hga7QVDxLRfgoDmfpiyfoSAmMst92t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNKmJYPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNKmJYPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE701C4CECF;
	Tue,  3 Dec 2024 16:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242466;
	bh=ZoErjDthbfqxKHOVpqMBvnofjxSV1kq+PXpAVX4NEbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNKmJYPwsrj95tLn7nzXMP7FZzHnBDf7BocZz0XVgGJ8e+Qx3G3UdjPH+GcwT38Mn
	 ju0fBD2qY1sfvs0FcHWRN+gJFdvaWaZLvclAh+ExWNkCnaQjnnDprQsepH4fRx7b7/
	 Fdc/O/OZRl7hz+GtwqrKbW7fxBW20jS0NU676Wic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.12 711/826] dt-bindings: serial: rs485: Fix rs485-rts-delay property
Date: Tue,  3 Dec 2024 15:47:18 +0100
Message-ID: <20241203144811.495675096@linuxfoundation.org>
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


