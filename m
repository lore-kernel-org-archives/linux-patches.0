Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93087129E89;
	Tue, 30 Apr 2024 10:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474641; cv=none; b=Si82DWvgrp78bV2jIdWkVRKlnHogFk4j5FgXgLSeMls53TUVK8IBzPgz3i4pcBLj5L8JkehQjPY7GWLyPqfzy3ofJydgyxy9MWYugWBi6TIKklloTu+UFWtqbAisahGE31Rcb3DB2pXaXYqstSRS2FMrJXGlIbBc/7ZGgZG+Aa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474641; c=relaxed/simple;
	bh=qa7YbAGl0fTGj5Cz2w+RR7lppzY0bGgUCir0hmrUX3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1l/Ef3CWD6w6USzhNQx5K+MczGQ+mHVV8Nj8APGUuwW1aeQFukKbOvBGa+4q74ozxOPQC7ywc7nB/uXuFk88Vg8qujeb00562o1j4+io8ib9VBnSYwPSl3b+IyQPjejtzb//E+U13iwL7w8Jc7AUGQOma7alD6L8pjSpXFLsG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPaR1WrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPaR1WrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA76C2BBFC;
	Tue, 30 Apr 2024 10:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474641;
	bh=qa7YbAGl0fTGj5Cz2w+RR7lppzY0bGgUCir0hmrUX3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPaR1WrEiQ5Ut7VXP2/GP5L3UhA8DgJKiIW1a0jBvotrE+oLfSHAZdPHt7ejWfN+7
	 WafNk+AWNxg4aYj+VwPRBYYEGuGPAiMU9nbOwoLzjnoegGlLoAMq3fde3NM6ll0n2O
	 nFJUGmj/wjrIHbKapaerzgNXQNcMtfE9nfY+wDj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Marek Vasut <marex@denx.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 217/228] dt-bindings: eeprom: at24: Fix ST M24C64-D compatible schema
Date: Tue, 30 Apr 2024 12:39:55 +0200
Message-ID: <20240430103110.066914329@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit b3de7b433a323bb80303d77e69f1281bfab0a70b ]

The schema for the ST M24C64-D compatible string doesn't work.
Validation fails as the 'd-wl' suffix is not added to the preceeding
schema which defines the entries and vendors. The actual users are
incorrect as well because the vendor is listed as Atmel whereas the
part is made by ST.

As this part doesn't appear to have multiple vendors, move it to its own
entry.

Fixes: 0997ff1fc143 ("dt-bindings: at24: add ST M24C64-D Additional Write lockable page")
Fixes: c761068f484c ("dt-bindings: at24: add ST M24C32-D Additional Write lockable page")
Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Marek Vasut <marex@denx.de>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/eeprom/at24.yaml | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/eeprom/at24.yaml b/Documentation/devicetree/bindings/eeprom/at24.yaml
index 1812ef31d5f1e..3c36cd0510de8 100644
--- a/Documentation/devicetree/bindings/eeprom/at24.yaml
+++ b/Documentation/devicetree/bindings/eeprom/at24.yaml
@@ -68,14 +68,10 @@ properties:
                   pattern: cs16$
               - items:
                   pattern: c32$
-              - items:
-                  pattern: c32d-wl$
               - items:
                   pattern: cs32$
               - items:
                   pattern: c64$
-              - items:
-                  pattern: c64d-wl$
               - items:
                   pattern: cs64$
               - items:
@@ -136,6 +132,7 @@ properties:
               - renesas,r1ex24128
               - samsung,s524ad0xd1
           - const: atmel,24c128
+      - pattern: '^atmel,24c(32|64)d-wl$' # Actual vendor is st
 
   label:
     description: Descriptive name of the EEPROM.
-- 
2.43.0



