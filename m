Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB1F36CE11;
	Tue, 16 Dec 2025 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888006; cv=none; b=Dx1ZIpurgV98OICM+NMe71X5RN+rZ+m2M5UZSbQgJJG64g5JzoTF/cnuMavITxqe5GAywoue5+UNcp3Av8NhF/1FJ1nNeYqAQngj6LE+IAl1KuPk/z4KpO0V02o8OO6DrZJr1Z6EPLB456/fffX92JVnJs596rAefrLmN/cvZao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888006; c=relaxed/simple;
	bh=gCukoulbmHZgFYgUglxGcSAHmllOYbfIy4AqSSGNjZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZrY14e8aY8jGJhufhNJ9qOqQ/R6LI4A7mlhr076Ic0sU69P2SbrI0PllQrH/VCuErqsRoubwedwzodLee7GC7ZSWBCMd977hacXfLqMoU1GYWsIj70HG2FucgHMMVK0lC1iDJuXenrSN5iAaRmzUfSAznuAcckcXYRl+cF7K8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ek3xIvI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ek3xIvI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA01DC4CEF1;
	Tue, 16 Dec 2025 12:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888006;
	bh=gCukoulbmHZgFYgUglxGcSAHmllOYbfIy4AqSSGNjZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ek3xIvI7kjsg+DJjrrc1N3HdmRYpr75e9ljUDFAx1asPmM54ZBygVzleUHsKTdsJ+
	 ZY8Y190kPn0Ugfx6yEEw2ArmjC/4JT8D+0sK/QXt7pO9psnnRK8CNyTLDgaWAvzGe3
	 hVvoZcY9YkGrCJuttS+ZCMBG/1Ui3dz2psrwA1ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 403/614] firmware: stratix10-svc: fix make htmldocs warning for stratix10_svc
Date: Tue, 16 Dec 2025 12:12:50 +0100
Message-ID: <20251216111415.977381638@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 377441d53a2df61b105e823b335010cd4f1a6e56 ]

Fix this warning that was generated from "make htmldocs":

WARNING: drivers/firmware/stratix10-svc.c:58 struct member 'intel_svc_fcs'
not described in 'stratix10_svc'

Fixes: e6281c26674e ("firmware: stratix10-svc: Add support for FCS")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20251106145941.37920e97@canb.auug.org.au/
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://patch.msgid.link/20251114185815.358423-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 00f58e27f6de5..deee0e7be34bd 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -52,6 +52,7 @@ struct stratix10_svc_chan;
 /**
  * struct stratix10_svc - svc private data
  * @stratix10_svc_rsu: pointer to stratix10 RSU device
+ * @intel_svc_fcs: pointer to the FCS device
  */
 struct stratix10_svc {
 	struct platform_device *stratix10_svc_rsu;
-- 
2.51.0



