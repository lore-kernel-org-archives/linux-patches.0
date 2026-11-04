Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829535;
	b=WZayWcV/6PU+VK3T9zQTqXVsZhvQ73kwoxRUAO5C+TnJkmIQ7DWvcGjUxE31tEW69h+P
	 KmCKy6zfG1957d+YYHkKPl47wuCX35is/Jm5zFtknEz/3LotAnU/J4xNZVBas+lVndwTY
	 J+YvE0JZPfQanKhuGSL0giO0HvyD3Q/WIbAZGfePZpFRuT96Wk6h/GzmGUFcCxt0KGH1L
	 LqQ2U4iKG52vrtb7brKY5uq3EO8m2kYvK08pyNfV94A7/VkoOjEqZdkwh0Iej3pgKjCJg
	 z9RtKYjo5Cx3f1XeQxuMxiUZuBH6EP3N4DIjxiIOQVH8cI3jZzIkiKlQMHImXp0RHbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EXp9cNueZ99PjMaxUY7d9npQjQTQWJXjboc51Xj3V7k=;
	b=kEriS5lv4xIHerEYoljp2wvyJwE16GnELllt4QxmtlPlux7yiNCHFUOhFh8QYIc8Ymjk
	 FDKai2sgZqbA1g9/VI2mCmO1FHXIhZ3925hjVNoAcre3a0zlaN64hxwpCxixhBKBFcO1v
	 d6oEJngBI1G5m1TABC2YGIz1PZwdtF9E/zLn7cZAgaUINd2UHVTnP3pCvqXB66U3+4sOB
	 159QDEDFFCokwpaK/gnlJtaO6ccXfETEEStYaaO4wYFqGhyXCf7Qb6U/UKwN7O+9B01LK
	 7Em+SwTORDvxvYnp9sX1zx78s7e/Fm20eaU5yyVdSZMyIJ19K4H4q/uE0RXffKYFHyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDzrD3Cc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612B46074FA7;
	Wed,  4 Nov 2026 21:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDzrD3Cc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E998E1F00919;
	Wed,  4 Nov 2026 21:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829535;
	bh=EXp9cNueZ99PjMaxUY7d9npQjQTQWJXjboc51Xj3V7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDzrD3Cc5fpdaJXUIK6IP1YmnZn4ojNHXGf3pIhmAb4CLRX7y6gKsZV4Wq5qJS10S
	 /oMzj7jfjVb9Rsmv4RbQi1qjmMXd86+FbkP3IU7nSt1Faoa31g9zMYq4twLUwtcKsb
	 ljVZLUEHtnzTXINm4xltCfTCeFCMxj1uDh+TF+P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0188/1005] misc: genwqe: handle a first DMA address of zero
Date: Wed,  4 Nov 2026 15:58:41 -0500
Message-ID: <20261104211049.054476244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



