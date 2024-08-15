Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339291714A1;
	Thu, 15 Aug 2024 13:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729769; cv=none; b=DfFUE7dUD74pNFsWaMG3kx4rmE2Il/T/L056YNXbFJdJfgLZPQcrU5DE7HRo7QLdR4q1PNfn3Mqmbese43aNgXpA+Qdrn7ri8Ax6B3HJmvsv++ieizNLu7pFjkSawkPn4GTj8w5cDTipIWAFOIV04gLyV60PKlZYHCEg4L2kg1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729769; c=relaxed/simple;
	bh=A0L1BmXOVnZ8BjlR1Es5PhMGhfNxDg/lsc0/PcpoLxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Udz73LW4mn4kC8bYgjYTc3CUReM8txbzqmDsuWMYouGoG5YzWeGb4/cTnIYZDDHS+eO+h+B5Ld6Om3tpAXqDJzjmj3+l+ttSkC9EzA5XFdlXMcrBRelom8y/Pki0/17qgqA7F8DTPg7S1b+c7IH2Rk+NTe2jXLqH2IdaURCNgqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nb460b9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nb460b9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B135AC32786;
	Thu, 15 Aug 2024 13:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729769;
	bh=A0L1BmXOVnZ8BjlR1Es5PhMGhfNxDg/lsc0/PcpoLxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nb460b9OMAzxYZ9qB7dEgBqWmhpEGCuBvhfkmYIdNoMgQZiTJsMxBtk6WpbUcu3Uz
	 BBuxkZwGuFMvZRiIDINyZn7Ft0wX+sXrQ2kZvj8mFmRzDVeb1w2JKkotchSHakM9no
	 GffF2t4YK5wtC2eFgu+mMYQNLpnxdbb1xSeGHG1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.15 170/484] dt-bindings: thermal: correct thermal zone node name limit
Date: Thu, 15 Aug 2024 15:20:28 +0200
Message-ID: <20240815131947.981949848@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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


