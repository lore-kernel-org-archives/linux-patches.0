Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F751F8909;
	Tue,  3 Dec 2024 15:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240682; cv=none; b=qhESrbpVUt9Ro5oI9vNDwiFCbxhHKIBF3sCrntG4svr4VmaNbvi5LX1B+D1yR+Pha6nzCpSYdPJD+BYr2X1PdrTMr/vJ1vo5qnYrDgZJ78/47UMclCu2GPaXzE4t1KEfn9nqbNYIdNAqaeqjNweXqqigQeDWSy8NU8NpKliRMpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240682; c=relaxed/simple;
	bh=4W2gjRzGaFSljtG7fUD11lFy0wHbc3YZBbi3jWBHY2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkerPs+6NGtFtkn/1sltLuExK5+Q6SC+P5RQK3gGcxIIF4yirBHO/HekT4pKZ2tC+hi1qc8ca4QY5QMQ9MI5dS6JiGX2not1lQlo93xgjtAqhQlbFTdSWGEybO8Vhv5j5kMLPaBssgGwY3lnwaL540R2PF1tmIf0aa/4LxdIqdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPGOTVEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPGOTVEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4639C4CECF;
	Tue,  3 Dec 2024 15:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240682;
	bh=4W2gjRzGaFSljtG7fUD11lFy0wHbc3YZBbi3jWBHY2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPGOTVEprRaxV5wds3tr7KKybrNZNdorOgoF3aVH8IUu5MfFbzAup9hc5xz1PnSJj
	 LjRfO0nNnGWM3SDq3Z6mOgA/k7GHlZrUPfDrL05PKpvDYkoe6GB/Ek+y2FhdXZxoNk
	 6BoE3RWI9S0Lzh1IMzvcFgTz+6A34tGhUEDmlgpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/826] media: atomisp: Add check for rgby_data memory allocation failure
Date: Tue,  3 Dec 2024 15:38:21 +0100
Message-ID: <20241203144750.525344108@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit ed61c59139509f76d3592683c90dc3fdc6e23cd6 ]

In ia_css_3a_statistics_allocate(), there is no check on the allocation
result of the rgby_data memory. If rgby_data is not successfully
allocated, it may trigger the assert(host_stats->rgby_data) assertion in
ia_css_s3a_hmem_decode(). Adding a check to fix this potential issue.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241104145051.3088231-1-lihuafei1@huawei.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css_params.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/sh_css_params.c b/drivers/staging/media/atomisp/pci/sh_css_params.c
index 232744973ab88..b1feb6f6ebe89 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -4181,6 +4181,8 @@ ia_css_3a_statistics_allocate(const struct ia_css_3a_grid_info *grid)
 		goto err;
 	/* No weighted histogram, no structure, treat the histogram data as a byte dump in a byte array */
 	me->rgby_data = kvmalloc(sizeof_hmem(HMEM0_ID), GFP_KERNEL);
+	if (!me->rgby_data)
+		goto err;
 
 	IA_CSS_LEAVE("return=%p", me);
 	return me;
-- 
2.43.0



