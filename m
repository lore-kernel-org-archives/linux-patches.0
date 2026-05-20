Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C493DE451;
	Wed, 20 May 2026 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296374; cv=none; b=ZHWR8V0T16z+/Cdoq4IKIAViowgsE08ertFRSUfCNeq5474cXxTPeZtDdPc18M6Zudl9gnkefAfg2X7/833ST/ldq6F/UrG3CUNkCiihK0JGKR34OHllVfi60fO4wEWgWbfunQY+4QPI9QUcz6AZvWHE/AXmNK1uTBA5CvTGs74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296374; c=relaxed/simple;
	bh=GkmhKlt8UzOYdIRndopWU6EC4BnMimNDE5pLgXwOKn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IpRtf9ZBj17g0VNRQOe9gTSFta2M8Yjm7rHFPi+TeqsqZgXbbsBW5NKvjui0ckF6ffGCvl7kxnQZQJZeKV+vFJsdA+nVhYyeLSrOg9E0Y0tfxcH6vgfg2Cy9otOHlmNzplpk5KnmfevJBZ7lDvfxhcpYvyWz6xmdhinUNEsDmvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHyZPmdK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHyZPmdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F501F000E9;
	Wed, 20 May 2026 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296371;
	bh=9XCbJ/6LUzLo1ndm/FC+ba0+fAD1qr+KaD76eTLBcck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHyZPmdKgyuJNSUCUP0bEZy4GAN7Nx49L4ZMlWKimlocGHNXZapivM0m/t5JhWo3W
	 pFM/21+uNPGD/74flG9AeQLfebKiS7vQma6HV35HRIEKq7DkUDU+L5UE5sOTBd2Msc
	 9teVvYf4X9CTn9JGdgK1LHz+XpBhhIt8e/gX/Veg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0737/1146] clk: visconti: pll: initialize clk_init_data to zero
Date: Wed, 20 May 2026 18:16:27 +0200
Message-ID: <20260520162204.885814051@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 1603cbb64173a0e9fa7500f2a686f4aa011c58b9 ]

Sashiko reported the following:

> The struct clk_init_data init is declared on the stack without being
> fully zero-initialized. While fields like name, flags, parent_names,
> num_parents, and ops are explicitly assigned, the parent_data and
> parent_hws fields are left containing stack garbage.

clk_core_populate_parent_map() currently prefers the parent names over
the parent data and hws, so this isn't a problem at the moment. If that
ordering ever changed in the future, then this could lead to some
unexpected crashes. Let's just go ahead and make sure that the struct
clk_init_data is initialized to zero as a good practice.

Fixes: b4cbe606dc367 ("clk: visconti: Add support common clock driver and reset driver")
Link: https://sashiko.dev/#/patchset/20260326042317.122536-1-rosenp%40gmail.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Benoît Monin <benoit.monin@bootlin.com>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/visconti/pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/visconti/pll.c b/drivers/clk/visconti/pll.c
index 6fd02c4b641ed..805b954812817 100644
--- a/drivers/clk/visconti/pll.c
+++ b/drivers/clk/visconti/pll.c
@@ -249,7 +249,7 @@ static struct clk_hw *visconti_register_pll(struct visconti_pll_provider *ctx,
 					    const struct visconti_pll_rate_table *rate_table,
 					    spinlock_t *lock)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct visconti_pll *pll;
 	struct clk_hw *pll_hw_clk;
 	size_t len;
-- 
2.53.0



