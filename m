Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060740;
	b=xj4G2pGJaFJ6dwd9oX1oMdOXoCFIkvKuYCwtDeavQMk+YGj5AMmWTol4nFDEpv7QQbiB
	 nXqfEc2u8aC3foPoejROX9otlnTNvqlZX2DzF2gi7QZ5sNznnM4cD54wcgy3za90GeJXb
	 muoe3IWqudZheh+w3671aasSLCnjM9zja1xwDLSMFE6u+7v7jpcoeO14OTgy/Fcwt0vee
	 zhfaFllfAqTuPFhalEeL3bErW35VbXdZUNI9jNZGFuYSYHLHDl4zMKxNzzzXmnsl1W3MA
	 urEJUbS5QoPMFoIiEev/EjkmcpuUyR8dAwWFBav8r78pr6YBKk86xQi0NWT8iVq//YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9/NeLg/vglHpBL4kftUcU6tFXjUrvj1OLIeEgeNA5Ao=;
	b=VEaIDvTbAI5+DBjE14sqynq4uzwTDezhLkthSSmR0gF97BHwcsXtDlXBoNJrQPLvXYde
	 xx3rALHDDsrqsMqsmUVHHcW/cGUQGVWmSoxig9QwVTO/ita104dENbcNVB+lw3FgXoFFd
	 V2ZPLpPZjH9+UuWmXqgiLGyw9kWmi3op5JZWU72ccByEmG9Jg9gNpzSiZL4VMBVMsuUAp
	 mkE+X3QUZrnHQhy8AjtA86Ksjkxwk7mFi1IVHXB18OnNR/XZrlcffuXZ3YoS+Orboc7ww
	 EO27j7F3TW4Agd+RK/3qlKzYx/erm/OY3haIbIvCVvSv4Q5sDMlBEh4VxPJi1tvkCzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rfkI0lR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A701606A326;
	Sat,  7 Nov 2026 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rfkI0lR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF581F0089F;
	Sat,  7 Nov 2026 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060740;
	bh=9/NeLg/vglHpBL4kftUcU6tFXjUrvj1OLIeEgeNA5Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rfkI0lRHnwcVYpfTBB7awLAp9xWPaDO2RFFmHujU7zXkXp9AcjEXB48ktsFJxYs8
	 Ad57dcdVJB6jxJdZ5itJwoJkNjPg8f1v1R/i2D6orRUuZ5ic07/JlhlhruxEnBAJSG
	 luahSE4702f9GbP8Mi4/2FPLtsoKgsv0kDpmNa1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0156/1536] misc: genwqe: handle a first DMA address of zero
Date: Sat,  7 Nov 2026 08:36:12 -0500
Message-ID: <20261107135002.060716519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit d401772a9e18e837631450844f835229354528a4 ]

genwqe_setup_sgl() uses zero as the initial previous DMA address. DMA
address zero is valid, so a first entry at that address enters the
merge path before last_s has been assigned and dereferences NULL.

Only merge adjacent mappings after an SGL data entry has been created.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260630104923.53827-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index a2c4a9b4f871c..e3b5fb337182e 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -413,7 +413,7 @@ int genwqe_setup_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
 			size -= size_to_map;
 			map_offs = 0;
 
-			if (prev_daddr == daddr) {
+			if (last_s && prev_daddr == daddr) {
 				u32 prev_len = be32_to_cpu(last_s->len);
 
 				/* pr_info("daddr combining: "
-- 
2.53.0



