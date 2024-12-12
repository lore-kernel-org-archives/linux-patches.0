Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295F453365;
	Thu, 12 Dec 2024 17:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023115; cv=none; b=ARj+FC2aQEKLAtt8OIQiz8e+o8+wHdcQnvFfjWMSqtU4YAycHWUabkXdGXnNCXhFhgG9bJ6B9qzXQmMvEI8uHFZHswuZJWo7XYn1y4jdI0089AcX3WI6kANHf0GplZ1HBFRdzKqmYisw83WLM31t7tiYORuLHU0UyJaXXlHzt/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023115; c=relaxed/simple;
	bh=tGoQwn5IvNGkZsh9SfKIxYiCblZE8CcrSPLZKHDijnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFZ0hA8w7MoY4d3a3LDmHkg3WDqdNFkV+2c6zHY5tE3vDZ0FHdPxR68Bzzi6Ex3ED8NPSH5BhG+csvnjK2SDMVsFJejQ9NY64y5GFWpapD723WB8dlv0LTfHjEbbibtZk/wPpxATies7UlDeX94ZE9xXiJsfetFLQRnjmZuKoTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijnIuUzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijnIuUzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995C8C4CECE;
	Thu, 12 Dec 2024 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023115;
	bh=tGoQwn5IvNGkZsh9SfKIxYiCblZE8CcrSPLZKHDijnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijnIuUzKOALp2LTCA0edPBcc/qMPWZnni6/1YbOj+ttx50QVu/zVl0eOtSm5sIpZU
	 yK4LLzgCfN//CGZpWc24u/kGyRZrFGxKGmRVXOuv+3dVURW/qdEFfWxS8CGs6SoWUB
	 ooUbEqBD8VvrrstrXEa8ARFnoZy2ehzNCWQL8bpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 429/565] dt-bindings: serial: rs485: Fix rs485-rts-delay property
Date: Thu, 12 Dec 2024 16:00:24 +0100
Message-ID: <20241212144328.639686813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



