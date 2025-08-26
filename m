Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61143196C7C;
	Tue, 26 Aug 2025 13:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214914; cv=none; b=fgLTvtCyIca/RTJv7g3C2FSY0ffKwXSsg/h6FfnOccDH2pw6rFyTX5CA6beEGOssbtfDM563fB3hsRTXfE0AbVcX4AdvqGmF+MldVYIQY0IS+27Jw11DOM47sCLF3NiSjTmCANSJ/1MqX7uuTLFsMKDgYCdmQlT1mO5Fl5ftUiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214914; c=relaxed/simple;
	bh=f5xG0cj0m/WRSr6ri8+5R6SJrKw5+WDMKNpK8y2UsBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEjvqXmYpCEHrfLuycD+2R839aoFISbnhTuWwOkVWJ07ZI++D9MqoNgNQOY0mldzspSd/YmrnZIhQh7XlogOYNdE5DneptsEK+aCh/iWI+lNQcZsZqgdDzx5E3YA2hQBwcIjFCv1rbvMGVsswx6h0TPoSrDGZAuMJ82YRMTSdg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXrxOenG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXrxOenG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9037DC4CEF1;
	Tue, 26 Aug 2025 13:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214913;
	bh=f5xG0cj0m/WRSr6ri8+5R6SJrKw5+WDMKNpK8y2UsBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXrxOenGO2Q/qvk8nYTDBBJsE/iD5WXMuljBrIw8GeBZNpvrfa8++wL6E0bV/CD60
	 b1ojNOvxVVrSx28rgFtg65uV1vrh5boDuUQvz19BkmyINws8VVCW2lUUTvBr9ekZdc
	 fXtuDs8LQrwg22AqX2En/KuRbx+3ktix9saobVFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 286/482] dt-bindings: display: sprd,sharkl3-dpu: Fix missing clocks constraints
Date: Tue, 26 Aug 2025 13:08:59 +0200
Message-ID: <20250826110937.855522013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 934da599e694d476f493d3927a30414e98a81561 upstream.

'minItems' alone does not impose upper bound, unlike 'maxItems' which
implies lower bound.  Add missing clock constraint so the list will have
exact number of items (clocks).

Fixes: 8cae15c60cf0 ("dt-bindings: display: add Unisoc's dpu bindings")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250720123003.37662-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dpu.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dpu.yaml
+++ b/Documentation/devicetree/bindings/display/sprd/sprd,sharkl3-dpu.yaml
@@ -25,7 +25,7 @@ properties:
     maxItems: 1
 
   clocks:
-    minItems: 2
+    maxItems: 2
 
   clock-names:
     items:


