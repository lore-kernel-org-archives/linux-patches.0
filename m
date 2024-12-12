Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A6521E085;
	Thu, 12 Dec 2024 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024678; cv=none; b=MGGFY0Sg1Mx4MYJDkoaykZQv21pbT6os3AaOXQDcecsWS94c/YBvHtQDLTfZye/qtSL0xath9WyJjP5QoLu2Wz/B5E1qXzXjTRKvN16yDVo5tc4J6ldrYtH/0OGqeYfuPYRkjGjg2suw4nTNwbxmbNdYUTSzN9ZQYFyEvzD8flI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024678; c=relaxed/simple;
	bh=Z9nnz45R8TyKNw0CQQmzEEvpHaWWs4502Bgin+Bmppc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ru3RBGPP3pYPX2vGZH25fxCuNZZf49d1PS4gsHCJY1mIiC3Hmt26VSYi7FZYxtYto+EfZxXPi76iuapzTSDjlXEbXWunP1WrI30ECNUNW71IbH4sKFEkUjP7udmHSmv3rRLWPTjZki14Oq8fHhtKjxr/eIhRzfdWMzlCPIlQM3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbYdL+VR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbYdL+VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9A6C4CED0;
	Thu, 12 Dec 2024 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024678;
	bh=Z9nnz45R8TyKNw0CQQmzEEvpHaWWs4502Bgin+Bmppc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbYdL+VRC4E4GQfboHky7Zh9il+UNItR9rPKg01VFNIXbkYRd7UV8Zu+lhSbZHMHT
	 P+U9XYiEcKiIZiD+gG7MUYvmise9zatHaOoOWT9zVr6B/zNaQ4lnvR/xgQCTng8EL+
	 3WJDpRxe9M3IdSa7zdqY/WniOjSjBU6vVcBqN4iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 348/459] dt-bindings: serial: rs485: Fix rs485-rts-delay property
Date: Thu, 12 Dec 2024 16:01:26 +0100
Message-ID: <20241212144307.407760037@linuxfoundation.org>
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

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit 12b3642b6c242061d3ba84e6e3050c3141ded14c ]

Code expects array only with 2 items which should be checked.
But also item checking is not working as it should likely because of
incorrect items description.

Fixes: d50f974c4f7f ("dt-bindings: serial: Convert rs485 bindings to json-schema")
Signed-off-by: Michal Simek <michal.simek@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/820c639b9e22fe037730ed44d1b044cdb6d28b75.1726480384.git.michal.simek@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/serial/rs485.yaml     | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/serial/rs485.yaml b/Documentation/devicetree/bindings/serial/rs485.yaml
index 518949737c86e..bc43670c69fa9 100644
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
 
   rs485-rts-active-low:
     description: drive RTS low when sending (default is high).
-- 
2.43.0



