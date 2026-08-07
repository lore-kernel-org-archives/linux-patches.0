Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B89739CCFC;
	Fri,  7 Aug 2026 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117439; cv=none; b=biYpYwuvg2sWm+PgLMZP++9hnigwQjqUGBfV8b48NFSpMrwZFd9NASennynndZV3/GauuBuMAa17fab42hNMrx7hrLMBm4lXFYxHc7T+Luq0zzAuVhe8u/VKKdMWGWE9tqTutxMgqS5TNP8D192N14JtivVQ0VtQiXAqlDJcQ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117439; c=relaxed/simple;
	bh=135S7f/YkDWbalAafwXSmU7p5h7gpGxn1VBDLvuXTe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1DrllvEAPWZ7VO7ovx4CiXH8RyPccHOmDPCikIR19K1Ryg1tTVMp11/HLUyLQMOQOyKAEZvw4n9Cc8YemMSmJIiur+5tJUmY974Dy/eWx+ndntODpzuPie63rbDqqDXY8G0rKNwUv0nkdfxV84nJZeEeGO2jkJki40uAZl0vEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQl2ze5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQl2ze5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980051F000E9;
	Fri,  7 Aug 2026 15:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117438;
	bh=IHhCi319bS1lLyLg2mE8dZr7T5POPgEDT3xu3+UCsy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQl2ze5I0E0VdpjnDm9vynmvG5kWaeuIev6adZ9o+O5uAw8I6ldDoF2F6xyxHrKlf
	 I7qOtomwQDLcpiIubduWibiPDmKBxG75Kf/asSsPGDsLhUvzc/+/izHQPv5XJRaqeD
	 GytAp4Nfr20KhYTf3T+U1VZTeYEi8A9NRImMxYW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.1 320/438] scsi: ufs: dt-bindings: Add missing mcq reg for qcom,sa8255p-ufshc
Date: Fri,  7 Aug 2026 16:38:36 +0200
Message-ID: <20260807143434.793676805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shengchao.guo@oss.qualcomm.com>

commit 4d5282c06ca198319c2de41b10511ddcb8068f42 upstream.

Qualcomm UFS controller found on SoCs SA8255P/SA8797P has a MCQ I/O address
space. It should be defined in the bindings even though Linux driver
currently doesn't utilize it. Fix the binding before it gets adopted by
DTS.

Fixes: e2725ed2a7fb ("scsi: ufs: dt-bindings: Document bindings for SA8255P UFS Host Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
@@ -14,7 +14,14 @@ properties:
     const: qcom,sa8255p-ufshc
 
   reg:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+
+  reg-names:
+    minItems: 1
+    items:
+      - const: std
+      - const: mcq
 
   interrupts:
     maxItems: 1


