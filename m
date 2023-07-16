Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D425E8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575B1C433C7;
	Sun, 16 Jul 2023 20:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538875;
	bh=qpaxR4VC4lJxEIuDUdVGtOHl8qxXvZdNl/a4jFajblc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVs4qkY5nvzUhbo0QvPswLDfZHQcTBPeUatHkWqLKKnesrAUxGLXJ3wQW4/L7Oa3R
	 5W+Pgx2Ro7SAApXolT9j1IcanUoWt1WHEnE8Cx+LJ+lILPVUtJHw8Dd/3rDyeSTHQX
	 nC0NJfWzsKEKTI/sqZTyUHw6BFy77fG00P/+t1Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 608/800] media: atomisp: gmin_platform: fix out_len in gmin_get_config_dsm_var()
Date: Sun, 16 Jul 2023 21:47:41 +0200
Message-ID: <20230716195003.229220624@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1657f2934daf89e8d9fa4b2697008909eb22c73e ]

Ideally, strlen(cur->string.pointer) and strlen(out) would be the same.
But this code is using strscpy() to avoid a potential buffer overflow.
So in the same way we should take the strlen() of the smaller string to
avoid a buffer overflow in the caller, gmin_get_var_int().

Link: https://lore.kernel.org/r/26124bcd-8132-4483-9d67-225c87d424e8@kili.mountain

Fixes: 387041cda44e ("media: atomisp: improve sensor detection code to use _DSM table")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
index c718a74ea70a3..88d4499233b98 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_gmin_platform.c
@@ -1357,7 +1357,7 @@ static int gmin_get_config_dsm_var(struct device *dev,
 	dev_info(dev, "found _DSM entry for '%s': %s\n", var,
 		 cur->string.pointer);
 	strscpy(out, cur->string.pointer, *out_len);
-	*out_len = strlen(cur->string.pointer);
+	*out_len = strlen(out);
 
 	ACPI_FREE(obj);
 	return 0;
-- 
2.39.2



