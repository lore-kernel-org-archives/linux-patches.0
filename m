Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756C822D4C3;
	Mon, 10 Mar 2025 17:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628688; cv=none; b=FuF0T/CTU1qIFWtUZEvFl9Sxprq13r0bO3wspRn3b5iyW5FX3L0XfW77fF3KTr9ACHkKMJWBu9w28a4tSNTygGYWhxkFF35eOXceRY0f5H3UoIugGOvpF/cGTx/PolzSUdSsZP3NgLwWTzK4zBHq2VJktRFKj+lksnTutPxvx0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628688; c=relaxed/simple;
	bh=KHA7kX/JuC8xA6knEjimu+ptczoZRETZp3zBKPss2i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRGVAL0906OWQWklcRsmVeDsFVutVBICsz0+Z4l4+FJuNxGNat3U3t2oBqTvSQQMmjtcsQsI6zsOOH6qcRj09DnKBCBW9ZGQ0gk6dLTqnLUxqgpwvaIIL5AClJOFn/3DuVrxDrauegQcFj3aBiJcJ0DQIFht2bESFN0mCGFzdVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peuk5s9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peuk5s9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD49C4CEE5;
	Mon, 10 Mar 2025 17:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628688;
	bh=KHA7kX/JuC8xA6knEjimu+ptczoZRETZp3zBKPss2i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peuk5s9gGsdP/NqddANwON79KDr6CnH7NDeVeBR/GtOPFJO9kySuT7FF2kMs936kQ
	 vJDbqWUmrAFaYKwzTKIXW5iR7oJcKs5onmbyG0VqOnzCmwNt4oBoB8csf2epN0o3Yz
	 yqJvvTD9AqWYT5B5EMragGaBMFNkITgYI5YQxjWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schwermer <sven.schwermer@disruptive-technologies.com>,
	Rob Herring <robh@kernel.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/620] dt-bindings: leds: Optional multi-led unit address
Date: Mon, 10 Mar 2025 17:58:00 +0100
Message-ID: <20250310170546.927070740@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sven Schwermer <sven.schwermer@disruptive-technologies.com>

[ Upstream commit 21c0d13e3dd64581bab0ef4b4d0fea7752cc236b ]

The unit address does not make sense in all cases the multi-led node is
used, e.g. for the upcoming PWM multi-color LED driver.

Signed-off-by: Sven Schwermer <sven.schwermer@disruptive-technologies.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Stable-dep-of: 609bc99a4452 ("dt-bindings: leds: class-multicolor: Fix path to color definitions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/leds/leds-class-multicolor.yaml         | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
index 37445c68cdef9..f41d021ed6774 100644
--- a/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
+++ b/Documentation/devicetree/bindings/leds/leds-class-multicolor.yaml
@@ -20,7 +20,7 @@ description: |
   within this documentation directory.
 
 patternProperties:
-  "^multi-led@([0-9a-f])$":
+  "^multi-led(@[0-9a-f])?$":
     type: object
     description: Represents the LEDs that are to be grouped.
     properties:
-- 
2.39.5



