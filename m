Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE071A6195;
	Tue, 30 Jul 2024 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358485; cv=none; b=MxA+h5TfTJ8yVhe2QxbLTHlcuI3wO+6YaStMXmxKW6MeUV1P6EAvZSxdQGgBcpHBmRdwA45ItHy26KTJp+okjj4K3knF9Yb3VrqPuHLz1pa8qrM4ukQpC7TF/04iWk6BpwpE1Qh2LZXLmB7U1wB/P7NVpskt5mhKzcVwu5fnkKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358485; c=relaxed/simple;
	bh=mNh62+3wOmyAQRy3drx/TN+WxSLSEHLGQ8rY3dyVRBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9pl+FebH7IUVOD1UKZCUgt7UXmfvCPQxxKImYgvcV2eBIEavyuOr6/ZuYJvKgeCtAwZPP30P6BlBZ+H8GtDcK70Xl8H4JPHVIwSKjUakBE0KvAbuZZg1PKrszpDpTktYOO7ffbbeFtfTn+6aIue8WPLUHxgX/1IAEVz3FY3oho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKMjrlPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKMjrlPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D768C32782;
	Tue, 30 Jul 2024 16:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358484;
	bh=mNh62+3wOmyAQRy3drx/TN+WxSLSEHLGQ8rY3dyVRBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKMjrlPSSVI2QEnmga/lh3hcmAFU8evRZxQV/PIl+SH2N+j0cTleo7nmLwEMY+tmO
	 48V01yzJzajmMSX1Eojcef86KDzlT6RgGEdMbgxkCwJgU95GQgMdHI44jV+Lq61CDa
	 tzQONh+4H0cZK+uSE8sKLB7uoEXTz068us/S2BMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.6 366/568] dt-bindings: thermal: correct thermal zone node name limit
Date: Tue, 30 Jul 2024 17:47:53 +0200
Message-ID: <20240730151654.166926464@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 97e32381d0fc6c2602a767b0c46e15eb2b75971d upstream.

Linux kernel uses thermal zone node name during registering thermal
zones and has a hard-coded limit of 20 characters, including terminating
NUL byte.  The bindings expect node names to finish with '-thermal'
which is eight bytes long, thus we have only 11 characters for the reset
of the node name (thus 10 for the pattern after leading fixed character).

Reported-by: Rob Herring <robh@kernel.org>
Closes: https://lore.kernel.org/all/CAL_JsqKogbT_4DPd1n94xqeHaU_J8ve5K09WOyVsRX3jxxUW3w@mail.gmail.com/
Fixes: 1202a442a31f ("dt-bindings: thermal: Add yaml bindings for thermal zones")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240702145248.47184-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/thermal/thermal-zones.yaml |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
+++ b/Documentation/devicetree/bindings/thermal/thermal-zones.yaml
@@ -49,7 +49,10 @@ properties:
       to take when the temperature crosses those thresholds.
 
 patternProperties:
-  "^[a-zA-Z][a-zA-Z0-9\\-]{1,12}-thermal$":
+  # Node name is limited in size due to Linux kernel requirements - 19
+  # characters in total (see THERMAL_NAME_LENGTH, including terminating NUL
+  # byte):
+  "^[a-zA-Z][a-zA-Z0-9\\-]{1,10}-thermal$":
     type: object
     description:
       Each thermal zone node contains information about how frequently it


