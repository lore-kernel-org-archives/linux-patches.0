Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026088;
	b=VU5LavFbvMcQWbi1cDOLz1GtCbr/KQiOSWzP8cGLwkmOdPNI6/R1aDYi0I9edx9cu9ui
	 tuuTPAQsOca9IdJrNd7RZ2hni1+6HXyaN9J4P/olJkNeSqWFGaJFZhXFcu1nMex9yum+I
	 4neOk90nc61AFhzmVC0JnKOUcwUE5MOaljmeojvzw1IDxe2peWvUGfNHCRQ99tesYlOCR
	 OgN3EHnzc9t1oHUo2qLcmRCCK3/EwN/IlES8eI7FbbGh2MlVpAeBcU+/1Nbnfn1NF4oz8
	 ggh4eJc2xHjWzTRBbFgY4aFeY9vQAlg/JBsvHh+fgRjRrjWvD9QFdUNlY+9Y3A79AfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aBR0WldBqEy8NmVY2CYtbyv4EeuxzoXsZL4GrkhJxZM=;
	b=tDRnzxx1h+UpVWTGXaOcZTaKUJyJGj4E8eLJ34eclDTv3Eun4hC3gNcai/FjMEiNeW6z
	 DLdC9glpxjgJ5jTs2I3trngTp7Mv87e83BlwxZItsxzA3zcoQbfJ3csj1IhGEaI2b2o2U
	 t/f3vVROlzNDHbHG81GuPkGAYmvzwg/DvJwNmvkHcKQ2Nk4CGNAegF8xuQaXKH3ymK4kX
	 v8tfQ4i95Op/XhahaASmgN2cyRov2iCR44pmIs6f+NkOsBLDLwfWXhs4qFPAem0SinVK5
	 WF9jb5hrw60VoWPYaF2+l8ImUlwC21X/ivdShGFxpNNcA9jRUliVUwcZGifD4HrenWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptxfVNEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF79606A31C;
	Wed, 18 Nov 2026 18:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptxfVNEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967961F000C4;
	Wed, 18 Nov 2026 18:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026088;
	bh=aBR0WldBqEy8NmVY2CYtbyv4EeuxzoXsZL4GrkhJxZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptxfVNExh+TpHOCQBGgCN41UeccFnG2JjR7XlkyVLqC3smqgefv2ISiBI1sCuQuto
	 WTXZ/6epG5CQN2h2WhVGZ+RAxP9QXYnZkncGIPX6FU/ZYMyCHXokx8ZkRBzclPULyC
	 WqMWcv71D62PrS9dn3CbjdaOouVg/1oRLwXfdIyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1310/2151] cxl/pci: Update only the Port GPF timeout fields
Date: Wed, 18 Nov 2026 15:50:45 +0100
Message-ID: <20261118150209.822489260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit b5d14009bdb1973d54a6ea111a660b3dae115be5 ]

update_gpf_port_dvsec() rebuilds the phase control register from just
the timeout base and scale, so the rest of the register is cleared by
the write. The other bits are reserved today and nothing is lost, but
the full-register rewrite would clobber any field the spec defines
there later.

Read-modify-write the register and change only the two timeout
fields.

Fixes: a52b6a2c1c99 ("cxl/pci: Support Global Persistent Flush (GPF)")
Assisted-by: LLM
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20261008034619.28059-4-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index e54991c74e6b3..cb28b33c03eae 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -870,8 +870,8 @@ static int update_gpf_port_dvsec(struct pci_dev *pdev, int dvsec, int phase)
 	    FIELD_GET(scale, ctrl) == GPF_TIMEOUT_SCALE_MAX)
 		return 0;
 
-	ctrl = FIELD_PREP(base, GPF_TIMEOUT_BASE_MAX);
-	ctrl |= FIELD_PREP(scale, GPF_TIMEOUT_SCALE_MAX);
+	FIELD_MODIFY(base, &ctrl, GPF_TIMEOUT_BASE_MAX);
+	FIELD_MODIFY(scale, &ctrl, GPF_TIMEOUT_SCALE_MAX);
 
 	rc = pci_write_config_word(pdev, dvsec + offset, ctrl);
 	if (rc) {
-- 
2.53.0



