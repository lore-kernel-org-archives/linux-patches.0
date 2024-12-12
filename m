Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD2722B581;
	Thu, 12 Dec 2024 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020184; cv=none; b=lPpj7nt7sRQnmaJ1rEI5dmkIrNzBhjn6jQVoub5oRf2nlLhFIQUCI7UlgitpedI84pJWyleXnPeGzqx03nll5GJO2O2Aij8bIRArkUx+jNKKF8X4rWZCNnm6TR6sawb0eYE2wH4KaWqi/Cu12BbZKpSMYlbkDE0HaaUM9e67fbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020184; c=relaxed/simple;
	bh=cLtkwnmOxR4Bqpb7uuvpJqRICW7a+Qlc6KR23U79iuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWl0LAKMl11rQbLsZecIuRKNWOz/VVh99M/cgVbg0CinSxvMrMBq70JvgF0khu/c3no3R64MqaP5rNkBZZWq91pbh0ts4o5REkiTj6kwH92fFykgtZKRbHdpOLK5Cazo3cyU4fs4KYF+c9gP6sW+mTqrXnWaeXScxLOAMH4Aq9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spRvjP2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spRvjP2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED4FC4CECE;
	Thu, 12 Dec 2024 16:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020184;
	bh=cLtkwnmOxR4Bqpb7uuvpJqRICW7a+Qlc6KR23U79iuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spRvjP2tKgghAYq5b7Vh0SxHWe+IqAZjGBsk/UK8XZoZnDiTIbnhCmlXPh4RHt1T+
	 GeFHmA4x0vuZC8uFkEZvAR6GacGNTvLv59ShsrQHyEQE6KqcfLb8katKx2BW1PJh/w
	 m31lLZLpMa5ZY27wjoQwbtcSjXE/lRL2YjQ42OU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.1 400/772] dt-bindings: serial: rs485: Fix rs485-rts-delay property
Date: Thu, 12 Dec 2024 15:55:45 +0100
Message-ID: <20241212144406.446664199@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 
   rs485-rts-active-low:
     description: drive RTS low when sending (default is high).


