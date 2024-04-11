Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F4E145B28;
	Thu, 11 Apr 2024 10:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830614; cv=none; b=aZuOb6zfhNBdsr6bRk0vHW5Usm1CuZkP/clhDOBSPWXmbNw+b7JRrh7rfMSqMKT2OVkIJaRYG4azeEOkebsTXxufq3NWjVbUjQNDS+7cdQL1/TWhkty3ArzuI9eL/NWDR1PfuT6o3KGL0bJSRjigqq2zLh/brr/GgjXBtLByc/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830614; c=relaxed/simple;
	bh=AkmcYSZtnE5Nmo7ak5E6Rt5v4CISmp35ll9RglOLjRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmq0hIVyU7WSi2noe1hx0yJzpOTcAhb9cnZIM42ECff5j5+YKBPige6VR3ekYoGibb892h9MkLZM/rB9UvmlC0hDCjdp0+0UBfiAGq8u7EbMBz04gWMMsKldZvqijeSYjGbmUj/zXrbBBLXsvOuRFSZ8DjuDXlktH2n3oNFHeRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euWAB7+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euWAB7+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD7DC433F1;
	Thu, 11 Apr 2024 10:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830614;
	bh=AkmcYSZtnE5Nmo7ak5E6Rt5v4CISmp35ll9RglOLjRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euWAB7+N2Qd4w/PAjHs5bBY1ROk4dLRUw9dhAa7zYhdInb7vn7b7pKgtvte7b0syH
	 Y7JVX8OWLCzwGMdW3WGy1cZ9bUcx1iNz4eaRsK9a0Zc+jgvJZ3QyAgI8LrPRQlCcx6
	 Ombxt6DGSn/jlvjf9Csmp1rORpt+84oxsg7q7vT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/215] slimbus: core: Remove usage of the deprecated ida_simple_xx() API
Date: Thu, 11 Apr 2024 11:54:27 +0200
Message-ID: <20240411095426.640944471@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 89ffa4cccec54467446f141a79b9e36893079fb8 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range() is inclusive. So change this change allows one more
device. Previously address 0xFE was never used.

Fixes: 46a2bb5a7f7e ("slimbus: core: Add slim controllers support")
Cc: Stable@vger.kernel.org
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240224114137.85781-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/core.c b/drivers/slimbus/core.c
index 130c798921b5d..e3f3ce6dc7e74 100644
--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -439,8 +439,8 @@ static int slim_device_alloc_laddr(struct slim_device *sbdev,
 		if (ret < 0)
 			goto err;
 	} else if (report_present) {
-		ret = ida_simple_get(&ctrl->laddr_ida,
-				     0, SLIM_LA_MANAGER - 1, GFP_KERNEL);
+		ret = ida_alloc_max(&ctrl->laddr_ida,
+				    SLIM_LA_MANAGER - 1, GFP_KERNEL);
 		if (ret < 0)
 			goto err;
 
-- 
2.43.0



