Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6387A1F7071;
	Tue,  3 Dec 2024 15:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239806; cv=none; b=sgHuMuwpT8eFj4919/Np7Gah+89sCgAxW2n+zrlmWZq2Vb5Ahhe3FIzgPpUf6+4gB9zFTXBUcf08KHKqNmyHxARO2kpgEZNCMZYeNZ1vPV/03AfoYCHO3MvIyr6/NabbFIQNEuKagIskGdmilIaW1mYg4IW9tKtSiEXu83jLrvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239806; c=relaxed/simple;
	bh=qlBZwscEI1hOXVmyfy7SEAVEBf0Vi9+9u88RNTl82fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGb2M5+is6YOhxEGY+Ys2YrSGoLaaqdrZ967vdcA3CDiBiKjKnzIdwvTdb9zkNHC7di0JuCce6Xfql9ZwHUxZQJa2jRkfmyzDmeyEv8ItIF23diF4jytc88mBPFj7l0kGOODdiCte1wJ16yLfDe14C27/rI2UrVJ45Ti9JzzhiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWHjmPuV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWHjmPuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA7AC4CECF;
	Tue,  3 Dec 2024 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239806;
	bh=qlBZwscEI1hOXVmyfy7SEAVEBf0Vi9+9u88RNTl82fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWHjmPuVRdqXuPxtI74TbZNX3UMfS9wAWdJMEH9KpiPxMgNBkp430lre4nwJBIn3+
	 pRxgpXsYXkVuV55scURN/Ocw3Bzz+7cxREljjgZaP87PcnrFFDDkxcm4Lxv/boxmDi
	 KHJ1Edp+JGazVvFBqE+lRI/YL0e/WyrsWhIVNxZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.11 713/817] dt-bindings: serial: rs485: Fix rs485-rts-delay property
Date: Tue,  3 Dec 2024 15:44:45 +0100
Message-ID: <20241203144023.823560058@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 
   rs485-rts-active-high:
     description: drive RTS high when sending (this is the default).


