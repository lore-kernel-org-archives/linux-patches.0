Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADF8149E0E;
	Fri,  6 Dec 2024 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496972; cv=none; b=PYxsKjDhoGzeZgeUWCQCuJiacixtYwep6a8MZr+zdKQzie3vy7FwFygJtLPFDy5XO8InXuJAQLPaCm92VuxS27NSKRoBzA1ijcTc7Oj8aKJ+947wz4Ee6oiDnEfwWpbx+4pMyPelXM0NZy6qWTqq970hhdl8pAQRihj67ObM+Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496972; c=relaxed/simple;
	bh=TN579QSpoqpMtJUApThMUShLIfQPCez6dd0SH2Hq7dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbyQ01BpePtUSmfYVxGq2YG3AYHSqR7rbKKpr0x4LS5VFW0RudKAEZq/7SsSxtvqTF9TBYu+p0nnf4cueYQZc4V0ngQFdJ5RqzEIRWz6dUjwgCEcz/Q8ZSse0n+6kpdaNYhqLYoCZwv7QJIYGK6Bo8BIqTz1CfYJiU4UbEJjyTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1pBUEUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1pBUEUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BEEC4CED1;
	Fri,  6 Dec 2024 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496972;
	bh=TN579QSpoqpMtJUApThMUShLIfQPCez6dd0SH2Hq7dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1pBUEUc15M6DCwJ59Sd7tv8sZmePqWP4r7C1v73kJ+fk0ZQ7fLXCsZ6KJ2bDmH7V
	 kvU0JLePgAnj9ePPyCmYkFKsKXKLyRKHb6Rt3DCYgO7azja7K/Klt180n198/JRpjL
	 8ffMS/dVh8djOZWwyj+GcI417KI4GUezIX3YwW84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/676] media: atomisp: Add check for rgby_data memory allocation failure
Date: Fri,  6 Dec 2024 15:29:39 +0100
Message-ID: <20241206143659.603240520@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 588f2adab058c..760fe9bef2119 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -4144,6 +4144,8 @@ ia_css_3a_statistics_allocate(const struct ia_css_3a_grid_info *grid)
 		goto err;
 	/* No weighted histogram, no structure, treat the histogram data as a byte dump in a byte array */
 	me->rgby_data = kvmalloc(sizeof_hmem(HMEM0_ID), GFP_KERNEL);
+	if (!me->rgby_data)
+		goto err;
 
 	IA_CSS_LEAVE("return=%p", me);
 	return me;
-- 
2.43.0



