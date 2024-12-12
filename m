Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64CE4F218;
	Thu, 12 Dec 2024 17:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023830; cv=none; b=OIgt2Idv4E+Fnu3LMsW5EitXm6g+90DQLHBBlG8n8LMGMAYjo7qkQC3IDixbY7ibYe/LoIISAFqMipQb9ecNSEioRGctsYZAaWjO4Tdb+FiHzepaTBNLqDz8TrsbLAECYZIkHL4fHRKeRd0DhnLiUJXjYAg6iOdDtHMYylr23Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023830; c=relaxed/simple;
	bh=RaQguyFo6YI3SUnGLICwaqisYLoNugRDzzD8iHyckvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiJbztpfb2RI10ZdApc8jc7kaaC/AW1LyYWSH8yCtjHRU7E/i0jm7sPKAPCA1QcJ2s5QVb62MUWlHJZUDWFyL/zWJK94XavFAxeB+GrHDLNDYux39toGGGhJUQszS4pu4wFdDxAYHXUIQ5kWPwhEQ0cMEST+77fZuEy89FykR5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiL/YOTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiL/YOTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523A1C4CECE;
	Thu, 12 Dec 2024 17:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023830;
	bh=RaQguyFo6YI3SUnGLICwaqisYLoNugRDzzD8iHyckvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiL/YOTpu5YMVg9/ycEwsWtuiOhCUYEjJUCIBouRzG5sAkt/ErEpmJE9rWOCVTUIp
	 MGZroTKh76DDb5BdPRcPXUiwMU6SDyxUQQeyTa22UbPU7UE35mEVDaQWOHxJaujeb6
	 bmAgQ6u/YF+PB9IK9d0y5epAKxVCgnJ+LulpIREg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/459] media: atomisp: Add check for rgby_data memory allocation failure
Date: Thu, 12 Dec 2024 15:57:15 +0100
Message-ID: <20241212144257.344138028@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 90aa8fc999ef8..34d8ffb7742d3 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_params.c
@@ -4356,6 +4356,8 @@ ia_css_3a_statistics_allocate(const struct ia_css_3a_grid_info *grid)
 		goto err;
 	/* No weighted histogram, no structure, treat the histogram data as a byte dump in a byte array */
 	me->rgby_data = kvmalloc(sizeof_hmem(HMEM0_ID), GFP_KERNEL);
+	if (!me->rgby_data)
+		goto err;
 
 	IA_CSS_LEAVE("return=%p", me);
 	return me;
-- 
2.43.0



