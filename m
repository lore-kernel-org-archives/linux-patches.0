Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F02334392;
	Tue, 26 Aug 2025 11:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207139; cv=none; b=aSvpTbeudZhUY+uhZ0qm61/57NS2oA4jaz9f+9XZlj37giY+I8ai1aCNYMOt3yiWUkmKa6wjZooZ4nnImtHzXjWhd330mpUo42vgDLb9E0DxSLUr+SVU/PIkGybsD3SZ13hH8QLNTClWFAkEOteDShrAJS1dFo7gur6+XIGcTsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207139; c=relaxed/simple;
	bh=3eZ9OwRysDGjrAsBGyT7JU9QMj0ogduLdLexiXK4CiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJ/kDIY5buSWEt4lvU9jK+v907r991AXNMRPC5bWsbhw8e3pGRG6cCnXfwRO7/VtdZNpVjJv0ES/H1WAF0w60dq8oDBzSYvuY7u8mzUoEfoVX+9OvmZ5/EHh1NQSg4UYvuKlykXGTgTPxa1dyvgJBfBfYznIxQW2kYBkI1A7elk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDDmEK6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDDmEK6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CDEC4CEF1;
	Tue, 26 Aug 2025 11:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207139;
	bh=3eZ9OwRysDGjrAsBGyT7JU9QMj0ogduLdLexiXK4CiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDDmEK6XKPDbvV9od2jOjv0aF010rQE7oFU1MzEWCi7W0GyVUF2dG+niFVG6HlSEy
	 Db0f6eyPCyjTns5NGCe7qu4ruhmPdH/OEzFL/3qjQf0qwFVhKn5TueXooQ9r2Q+uTD
	 vcVhllK8vqfCRxVdNWE7gBnLuZ951RBtAHVSkOv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.16 065/457] scsi: dt-bindings: mediatek,ufs: Add ufs-disable-mcq flag for UFS host
Date: Tue, 26 Aug 2025 13:05:49 +0200
Message-ID: <20250826110938.967253492@linuxfoundation.org>
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
 Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml |    4 ++++
 1 file changed, 4 insertions(+)

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


