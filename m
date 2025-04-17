Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1647264A63;
	Thu, 17 Apr 2025 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914867; cv=none; b=L27AdWmwRGTbyPTq5j6A/tvVLyvLRX3PDyFQTyd8f2Mo4exNmdLwAkRAEKuAmM7gHsRhL2piTfCllcNahVDIuqOT+NLZ2sC576TOZTnhMrdA3EteuJPtTrD7LlH1MSynI2H7Ikamdlf7xVtK6jRrqJOwPbW2+cfgyLAra7hA394=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914867; c=relaxed/simple;
	bh=pHJWvVq/9PzR+TSexxqNtfamSEK3JbKXMNNl+PI0Pco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpJFKVR4XQ3wcY03cK2uifkrbr/mNR1BAJpmjSbLlaNX6U0xmMDnpo+wboG2Ju4NqYgqXGFPPZyCERIuRw7l/QTC6gpyrxNQQ5DF17qBo+aFCpoftoz6E639uSSeZYfVjOUekV0o1SMzM3r4tJkrxQKj4E25wzYX79pwphAwTQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMSVuJAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMSVuJAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7666BC4CEE7;
	Thu, 17 Apr 2025 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914866;
	bh=pHJWvVq/9PzR+TSexxqNtfamSEK3JbKXMNNl+PI0Pco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMSVuJAy1PeqdaexARXaxwOjNbpPV91aq52rioi6H5HQ4jxBw/u5wmR0PEMK2gIWk
	 XA8MOjUHovTE9As62qsF4HbNcEnuWuFTMqxGrKSLGBwRhB8QK5p80L7jzaAdZ8/LQg
	 TjtUUBbvnhfn+HDUD9oQ2VKJ59IHeY7c0BgfdfiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 6.13 357/414] dt-bindings: coresight: qcom,coresight-tpda: Fix too many reg
Date: Thu, 17 Apr 2025 19:51:55 +0200
Message-ID: <20250417175125.823648227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit d72deaf05ac18e421d7e52a6be8966fd6ee185f4 upstream.

Binding listed variable number of IO addresses without defining them,
however example DTS code, all in-tree DTS and Linux kernel driver
mention only one address space, so drop the second to make binding
precise and correctly describe the hardware.

Fixes: a8fbe1442c2b ("dt-bindings: arm: Adds CoreSight TPDA hardware definitions")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250226112914.94361-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/arm/qcom,coresight-tpda.yaml |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/arm/qcom,coresight-tpda.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom,coresight-tpda.yaml
@@ -55,8 +55,7 @@ properties:
       - const: arm,primecell
 
   reg:
-    minItems: 1
-    maxItems: 2
+    maxItems: 1
 
   clocks:
     maxItems: 1


