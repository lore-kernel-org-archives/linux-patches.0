Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F24318DF68;
	Mon, 28 Oct 2024 06:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097604; cv=none; b=eqCax5Ol8uFgTbmqQ/Lxbnc2ubbU/cYozm/5GCnHzo8emSaId7nVtSjk07WZ2qni+7Atv5av4STYfzJ3tVESoa0ApUHW437XdVWWil7wNRVVRiyzl2JO88/+BQqc3pQw+RKWfonA1RF0wdfRHg+9k6Q6vooVpgREwkoVsbBtPdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097604; c=relaxed/simple;
	bh=yE4mg2BrzJlY/xYUY9Ci360gTt/bfjlgQfVuU/b3ugs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RICuEusK+TlClDnr1yd2xVxBX6fzmGmkNGlfKzpxV/bYKJSV0d+BhaHwNrp+moskOykzppDyKIq42qjn6kZoHrqVRUk1iv5CdhV704jo2RiH9lIsHcwMjOKHja+uE9+K7wkr/Ytb6zYpkcsCl8zgLxbwJwgjNJlAAkNuCU2Qd3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6tYjI/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6tYjI/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8A5C4CEC3;
	Mon, 28 Oct 2024 06:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097604;
	bh=yE4mg2BrzJlY/xYUY9Ci360gTt/bfjlgQfVuU/b3ugs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6tYjI/j7xR2BvfT9fjo33PCscGbVUMgIAbdg+dUMdNlZCoKI7UWd54xQAo98G+/I
	 kakHuKVZa0giIqBS9ZwWO+I3zHZ2cm1Wh/knp7HbxeZpnNAEFSMKb/eoRuqt9z1C/V
	 22KFK1oDG/YJyFmVOQz+BKpss4g4PSkbUfDY99HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Zubkov <green@qrator.net>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/208] RDMA/irdma: Fix misspelling of "accept*"
Date: Mon, 28 Oct 2024 07:23:30 +0100
Message-ID: <20241028062307.400913318@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Alexander Zubkov <green@qrator.net>

[ Upstream commit 8cddfa535c931b8d8110c73bfed7354a94cbf891 ]

There is "accept*" misspelled as "accpet*" in the comments.  Fix the
spelling.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Link: https://patch.msgid.link/r/20241008161913.19965-1-green@qrator.net
Signed-off-by: Alexander Zubkov <green@qrator.net>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 42d1e97710669..1916daa8c3323 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3630,7 +3630,7 @@ void irdma_free_lsmm_rsrc(struct irdma_qp *iwqp)
 /**
  * irdma_accept - registered call for connection to be accepted
  * @cm_id: cm information for passive connection
- * @conn_param: accpet parameters
+ * @conn_param: accept parameters
  */
 int irdma_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 {
-- 
2.43.0



