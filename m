Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C14338F54;
	Tue, 26 Aug 2025 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208270; cv=none; b=dQ9EEK68UMKG88RCh5OoZuUKtOWtXIOJ7KWv8qGLj9holqqP828u1IRp9A2YR78yyW+jl5+ZGENqe5U8icZk9IoC/R8JukcUpmZbXWiEBTKz7h33rlfxQT+RrUDhRbFlQh0Dht7AwcR5M5pEzLESGDK7O+m5VFBwnP/39Wcnt9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208270; c=relaxed/simple;
	bh=feC+uPoT9tpxCojU0ahGcMMp59zeLUNg+JDEPcCa1dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFB5GplDLZnYzsOh2p52pxpomrhQsDbvT9aoqNvwjK7wagpmQnn70jVT0WakI1Xw+QwgHR2+1hLgp+VO3Krkeosrqxj4mk56LSXIdKNn2MVumCWJEOUKtgkHQnFRl/CGxZR36kEtv2ruSjr5rdVuMCw5excO2HzgaxLnTYyolec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLp2XLoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLp2XLoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB81C4CEF1;
	Tue, 26 Aug 2025 11:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208269;
	bh=feC+uPoT9tpxCojU0ahGcMMp59zeLUNg+JDEPcCa1dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLp2XLoVy9htKYNnmnb3E9Q+X5oTwrPP/gCW21eixe6B2GtHFdbxVMUTd8x7WyB9e
	 k/upylQNmZUwEvY5eLMtkn3ychVmZX7VoOkmgVEcoKL9mORYo34/jHdcIJ0DR9b43H
	 lH53YU7TR0bSTvEMpDFYQFh/BYHZdxlkkCZSUeys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 047/322] scsi: dt-bindings: mediatek,ufs: Add ufs-disable-mcq flag for UFS host
Date: Tue, 26 Aug 2025 13:07:42 +0200
Message-ID: <20250826110916.555233345@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Macpaul Lin <macpaul.lin@mediatek.com>

commit 794ff7a0a6e76af93c5ec09a49b86fe73373ca59 upstream.

Add the 'mediatek,ufs-disable-mcq' property to the UFS device-tree
bindings. This flag corresponds to the UFS_MTK_CAP_DISABLE_MCQ host
capability recently introduced in the UFS host driver, allowing it to
disable the Multiple Circular Queue (MCQ) feature when present.  The
binding schema has also been updated to resolve DTBS check errors.

Cc: stable@vger.kernel.org
Fixes: 46bd3e31d74b ("scsi: ufs: mediatek: Add UFS_MTK_CAP_DISABLE_MCQ")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Link: https://lore.kernel.org/r/20250722085721.2062657-2-macpaul.lin@mediatek.com
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
index 32fd535a514a..20f341d25ebc 100644
--- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
@@ -33,6 +33,10 @@ properties:
 
   vcc-supply: true
 
+  mediatek,ufs-disable-mcq:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description: The mask to disable MCQ (Multi-Circular Queue) for UFS host.
+
 required:
   - compatible
   - clocks
-- 
2.50.1



