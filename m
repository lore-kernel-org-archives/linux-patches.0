Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC77E23EA9F;
	Thu, 12 Dec 2024 15:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019124; cv=none; b=pTfAhWrkVWI41WA27l1EZwf5T1tzyPulPT/fp1hcJso2vLc4p1I1SHMqQqwVtVGsoHn27CZkcuzbyWoVcWvEkTOJZ42cCZZBP/9A84Rs8qSd6bJ41YQHsI57f+LQyRsv3IBF0LN6tMf9DvwSd9wUDwqWf2oHLjZ5mADCHjRzA6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019124; c=relaxed/simple;
	bh=33LF8wwrzjuwh7lGnjsOWuBTwW5YDkbI2k5Z475Ealw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIGee7Uu8V959sTeyaYduTiy1MosZd8nlTBmmlTNhqcvOthHsj1E1LzKe3gYNBSXyluba5hT1giNuyUBXmWoSDzMt1uyRikSWT8BJ+PDN6xXFNMGu7WHJkb7kgKQ40mAGCiOI6j1TgU8f7kyFBDF0oW1NAkq4fSS46yS4UtMeR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r51Oz3VU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r51Oz3VU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B3BC4CEDF;
	Thu, 12 Dec 2024 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019124;
	bh=33LF8wwrzjuwh7lGnjsOWuBTwW5YDkbI2k5Z475Ealw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r51Oz3VUjW8b0gCH/iE5yb7Cvl3omyQqojaStKt3KdQ+a3ww7KMkI2Uz61rfYvU0O
	 1RvZKyjorrHCkP1Akp4KUjU7iM4S6E5j9VRthofX9tE53a1venKK5YDdFCkebogMwm
	 OFHU1r9QznXApMQIBjQNeHunEMxGFWybYWQYaVaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/772] media: atomisp: Add check for rgby_data memory allocation failure
Date: Thu, 12 Dec 2024 15:51:08 +0100
Message-ID: <20241212144355.006929733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 67915d76a87f2..34113bea31d58 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -4137,6 +4137,8 @@ ia_css_3a_statistics_allocate(const struct ia_css_3a_grid_info *grid)
 		goto err;
 	/* No weighted histogram, no structure, treat the histogram data as a byte dump in a byte array */
 	me->rgby_data = kvmalloc(sizeof_hmem(HMEM0_ID), GFP_KERNEL);
+	if (!me->rgby_data)
+		goto err;
 
 	IA_CSS_LEAVE("return=%p", me);
 	return me;
-- 
2.43.0



