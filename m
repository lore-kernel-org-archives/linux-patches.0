Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050940;
	b=QP8a3/X2/xVbtcOJ1LjsefSZ6WyM1LgafYlFFzGxuOnbRhGKTkdwkpfqLGe3lVe5GUgI
	 rRGUzj8VfXlrFDHQCNUsP9B8aBk3FSqxvc1zNl3Gx7TAQE0jpKUN8+m/IEzPJBernk6bm
	 Sqg1tFwbx5XOTdZbEmuIsnbobYrzGwl8ITWjdwECnhVCSPA5anN1PoCCkUtf1Ha8SplQZ
	 CFJuCNoJW2kxifx0Zi+J75lOAq/BZGx4yudbUAczEfshsTmD990Ncj/Mz/lmD0OtVkcqs
	 ZIWWid1kLgtAOyTLi6/alUPbrpAmQeZbAuXQUVKN+kERmBBxJLqjfLZntyPCAI6AmtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=utg/uw5x5gnvcwVgrEO/CUvxT+8D+CUHAAhoS00B5dk=;
	b=zsSKd2r8OiPWaWHbQRlFuS2HaglZOEGWiodTJ9+PTZHdevjw00xe2G2/Q2Qy9KYwvY+f
	 IBGu0c6m/k0l9rh5ZeZXXB1D8drRg03aQo0UoXY3k3JN//L6MTQbj8Z8mEGg9PFVfQnr2
	 vUFaaGbNgcKcw7plECTNbp3YJIfpU1syrikqFOkASs95V6gshC7/693x4iC+pdPafTZQN
	 id2SVaDEQVA2fDb9FbquPFpDtQy+ZwKkiL+D5qGkrkHpAaEpNmQ+6iZf3J6rr0DotOZon
	 usFG9pPMAHXWs5MYJRXJHScnJV77X8XeXleTGbXILQkjgh5Mx8Ru3UaR7N5gM2gH9Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBAMLgq4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E45606A32A;
	Thu, 19 Nov 2026 01:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBAMLgq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A261F000C4;
	Thu, 19 Nov 2026 01:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050940;
	bh=utg/uw5x5gnvcwVgrEO/CUvxT+8D+CUHAAhoS00B5dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBAMLgq4LotVxUug5CupPmi3Tk30xsgwB3eBVgoVtpbjsDbLS8n9hs6baDGw23Plu
	 cr3FaftmNOYBz/u173WRD500RcOsRN4E0FkRWKuzuYLsru2ZpnaI3L+PK+IN6iDq0c
	 Aydu+XP4QuWRaPMi51tbDy9y1v2k0bnSr/iprI0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Theesfeld <william@theesfeld.net>,
	Brian Masney <bmasney@redhat.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0032/2214] clk: zynq: handle kasprintf() failure in periph_clk registration
Date: Wed, 18 Nov 2026 15:28:28 +0100
Message-ID: <20261118150011.378356741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Theesfeld <william@theesfeld.net>

[ Upstream commit d4d0d335e8d37c6c7e1c5664c7664288eca5a09b ]

zynq_clk_register_periph_clk() ignores the return value of the two
kasprintf() calls used to build the mux and divider clock names, and
passes the resulting (possibly NULL) pointers straight into
clk_register_mux(), clk_register_divider() and clk_register_gate() as
the clock '"'name'"' argument.  On allocation failure that name later
gets dereferenced by the clock framework (e.g. in debugfs name
formatting), causing a NULL-pointer dereference.

Check both kasprintf() returns.  On failure unwind any allocated name
buffer and the spinlock, then fall through to the existing err label
which sets clks[] to ERR_PTR(-ENOMEM).  Freeing the spinlock on the
error path is correct here because no clk_register_*() call has had
a chance to take ownership of it; the success path intentionally
hands it off to the registered clocks.

The neighbouring zynq_clk_register_fclk() in the same file already
uses this per-allocation goto-label cleanup pattern; this change
brings periph_clk into line with it.

Signed-off-by: William Theesfeld <william@theesfeld.net>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynq/clkc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index c615664505a55..451126c24eda3 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -186,7 +186,11 @@ static void __init zynq_clk_register_periph_clk(enum zynq_clk clk0,
 	spin_lock_init(lock);
 
 	mux_name = kasprintf(GFP_KERNEL, "%s_mux", clk_name0);
+	if (!mux_name)
+		goto err_mux_name;
 	div_name = kasprintf(GFP_KERNEL, "%s_div", clk_name0);
+	if (!div_name)
+		goto err_div_name;
 
 	clk_register_mux(NULL, mux_name, parents, 4,
 			CLK_SET_RATE_NO_REPARENT, clk_ctrl, 4, 2, 0, lock);
@@ -205,6 +209,10 @@ static void __init zynq_clk_register_periph_clk(enum zynq_clk clk0,
 
 	return;
 
+err_div_name:
+	kfree(mux_name);
+err_mux_name:
+	kfree(lock);
 err:
 	clks[clk0] = ERR_PTR(-ENOMEM);
 	if (two_gates)
-- 
2.53.0



