Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CF8340A51;
	Sat, 28 Feb 2026 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301272; cv=none; b=Sa6YEb4ib5nzTFquOrDt9Zdjllq8vYEBHJr60X3T67jEuYcA1B9cqUeE8XWYbRn05PQ8leVO19L/Ugru2OTfxwEy9c1INMOM5/9HAP4D+aVJKF4z+WSLrq5C6hMyfWOLzqlUZNnp+JrPKki7aKMAsgm0DqhAKq4VRAxO2hAn+tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301272; c=relaxed/simple;
	bh=VZCFNxIBTZj2W+VfE2RTxe5USXztP8jkX6mcesjAPPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAesBzCl4Cg9BepfrU0gkr6WevJDiE2I5xnuXvwoFocGNeadgCBOWZiEu5MONaeIloVzjxJKZj/N7BdYcyy8jsugU9aUXyJMUJ36/rOlWHrgz3p1FKA9jtDjh1y+N/pYKvmnvFf2zFAA4v0Sr8ctLNCd3ylu7VgQcLs93Vxrg1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxwZe0pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxwZe0pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C27FC19423;
	Sat, 28 Feb 2026 17:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301272;
	bh=VZCFNxIBTZj2W+VfE2RTxe5USXztP8jkX6mcesjAPPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxwZe0pdDDHFJNbvFx1QNH4Cc+8KfV+yXgbuAXvhSaFBuspRVNpFQo19C8jthVhv+
	 L/cSo11SDe5XNCqmK5WNNV4y1n3GWmwuRWoAq2gdMjrYUb9K+Z72Y6HCShU0hG0UmX
	 ZW5JWP2+bOrZMu802B5rtAqR2KRFAGZDF5qwikL6uZE02hVPN9eAKKTt5J46nbnsns
	 JcdUr2NQ7ZmtWSw9guEkuo4fII0Ci7Tf2IlXDjJzNemm5al8UgOv9Vclik63uCGqob
	 DXtXn1yiLZVsBwiCm/LUOxyNe9kd1KOb86xdIzf/BoKPWgwrsPN1N4E6GVxa7mq+VM
	 yNEHP4cirNPlw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chris Brandt <chris.brandt@renesas.com>,
	stable@vger.kernel.org,
	Hugo Villeneuve <hugo@hugovil.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 456/752] clk: renesas: rzg2l: Fix intin variable size
Date: Sat, 28 Feb 2026 12:42:47 -0500
Message-ID: <20260228174750.1542406-456-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chris Brandt <chris.brandt@renesas.com>

[ Upstream commit a00655d98cd885472c311f01dff3e668d1288d0a ]

INTIN is a 12-bit register value, so u8 is too small.

Fixes: 1561380ee72f ("clk: renesas: rzg2l: Add FOUTPOSTDIV clk support")
Cc: stable@vger.kernel.org
Reported-by: Hugo Villeneuve <hugo@hugovil.com>
Closes: https://lore.kernel.org/20251107113058.f334957151d1a8dd94dd740b@hugovil.com
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251114193711.3277912-1-chris.brandt@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index db85b1b43737b..9efedc62feed6 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -122,8 +122,8 @@ struct div_hw_data {
 
 struct rzg2l_pll5_param {
 	u32 pl5_fracin;
+	u16 pl5_intin;
 	u8 pl5_refdiv;
-	u8 pl5_intin;
 	u8 pl5_postdiv1;
 	u8 pl5_postdiv2;
 	u8 pl5_spread;
-- 
2.51.0

