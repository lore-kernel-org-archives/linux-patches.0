Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCC7350299;
	Tue,  6 Jan 2026 17:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720125; cv=none; b=g5DWsP7kcAzF1Lr6puAq2VUet4ZzphNLsFqpn7zBDNiXvl1H7t2+Uer9tnYZ8Z/ulsRaldHr1cmERP5wJBMVRXS2Dp9fyLPzYx+3ZetaPHKQIAioc0AKhaf5qe6z+vkXRwLo2XnTFZnfWcHPkx3+QoyY7zlylxcV6OIkKysxLVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720125; c=relaxed/simple;
	bh=qJYUFmwP1oAq9fpZ6ecl5pc8frOm4vRPaWTz8DGkxxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5TckWClOYTmvVr9DuUbzvhPltMFW2LmlrR2k5utqTrDmr/zmQW/twi6BQpHrL9q7s1mbSEFqQBrVOBYjw8AFF1EXqH/kZLIE5qMy0ntjxNTla0TRtZapKgtic4/WoBzgJ9nCSp0AOVYZ/30RFK+YxwRn5i+7XvBb2vMqaawJ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wt4LkJrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wt4LkJrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE48C16AAE;
	Tue,  6 Jan 2026 17:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720125;
	bh=qJYUFmwP1oAq9fpZ6ecl5pc8frOm4vRPaWTz8DGkxxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wt4LkJrX13zjgNoh2eOCS1cFlsZ+r8vNDU3qUjxTQh8IuK/gm95DzJgFIttdn7duO
	 7ue4LpWpPHMXwu+O/kqXyZw7Wv4Wpgbcz/0m6a6YRh5KCXJ5zkcLAvqCqvXvofwRbr
	 umWCmLcyYJV0qDdkIlJ9cPZVq693u2izMI6EuhGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 109/567] dt-bindings: mmc: sdhci-of-aspeed: Switch ref to sdhci-common.yaml
Date: Tue,  6 Jan 2026 17:58:11 +0100
Message-ID: <20260106170455.360311673@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jeffery <andrew@codeconstruct.com.au>

commit ed724ea1b82a800af4704311cb89e5ef1b4ea7ac upstream.

Enable use of common SDHCI-related properties such as sdhci-caps-mask as
found in the AST2600 EVB DTS.

Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml
@@ -41,7 +41,7 @@ properties:
 patternProperties:
   "^sdhci@[0-9a-f]+$":
     type: object
-    $ref: mmc-controller.yaml
+    $ref: sdhci-common.yaml
     unevaluatedProperties: false
 
     properties:


