Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957502248A5;
	Tue, 26 Aug 2025 11:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207131; cv=none; b=d/CtvRnrtXEfximiD7johwwwvWvofz0CpoCSJ+DlV3qLzZOk7Rp7fcQdGjaKdRk1v4vZ1WMOD9fjy1EuJgNqIClaZ3HDH7FzZ5KGVh9QdwFdvcYsksUK0DDVQRnqWaBRr4JLFgR8IposCAucGG7HGcsXGRbmN9c9AJY0MR73CQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207131; c=relaxed/simple;
	bh=Skeb+NcWBdh632nc5tNZ+DfqYYiB6bvxQPCZEgGpN/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUm1RLKTK9vSi+SDu794MeV4iCshNgU8x2tnI0hMbb97LkfUni+qWpZ+Mfkyaae7NiS6B816eIZKkd7cDyIConUipySXJOCjjuqm/D75t2Z46/Hj1oTaSti/LMi4o6Kz+YrurGF6F4De6nNT5vnErrL/EiaJ7WpWbdJQK0i0F+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NAyzI6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NAyzI6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2ACC4CEF4;
	Tue, 26 Aug 2025 11:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207131;
	bh=Skeb+NcWBdh632nc5tNZ+DfqYYiB6bvxQPCZEgGpN/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NAyzI6/han8qn35IWd+wWqHY9D1nRqzUI6G0M4L5nZT/hkUTwlZcppD9WyQoZz02
	 wCFOj81rWem+BJFKFDp7f9P4UQGrLgxNqLLalsM7/J9dcFGCkBd6qvH4S00Qg38oXv
	 zIToVKjUna6pDjUc91ppYsmBWhCZU07pc9OGva4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.16 063/457] dt-bindings: display: sprd,sharkl3-dsi-host: Fix missing clocks constraints
Date: Tue, 26 Aug 2025 13:05:47 +0200
Message-ID: <20250826110938.916375711@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 2558df8c13ae3bd6c303b28f240ceb0189519c91 upstream.

'minItems' alone does not impose upper bound, unlike 'maxItems' which
implies lower bound.  Add missing clock constraint so the list will have
exact number of items (clocks).

Fixes: 2295bbd35edb ("dt-bindings: display: add Unisoc's mipi dsi controller bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250720123003.37662-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dsi-host.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dsi-host.yaml
+++ b/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dsi-host.yaml
@@ -20,7 +20,7 @@ properties:
     maxItems: 2
 
   clocks:
-    minItems: 1
+    maxItems: 1
 
   clock-names:
     items:


