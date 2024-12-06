Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2C853A7;
	Fri,  6 Dec 2024 15:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497564; cv=none; b=KDT2lj16dqtPVN1nsHpldoVKzujdODdCOgpBset1VFpD7HgB8/vKicTvbJHOJao6IjWoVYjsRU/ORI+W/Q59HuS3BPTuGsja/PgxRSO1Prq0Vg7/n3HMyC6Vtz030HQK1LqsxOp6SI7v2oyZHeH1Bw4VoPHBz1d6W8D8xvy1qow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497564; c=relaxed/simple;
	bh=AS5JvqHl3eQmmWimL18+PkSbUjddr5WCgtedkMnNung=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ei8CrzFVJehtI/WWkiHk4bg0SysIbNw5T2O6V+zHmIkmbxFGUhTL+QjGE1m7rNa9fudvvxbuoWb7LCQZlHLXqEZZ5extw7wD/bzwkRBnvlhNMfTXhzrYOf4XBra2WUSkktE8BH3US9OFf6Envm/MPPuYx/bGSTKjFQumfiKncjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mx2sQdmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mx2sQdmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FF6C4CED1;
	Fri,  6 Dec 2024 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497563;
	bh=AS5JvqHl3eQmmWimL18+PkSbUjddr5WCgtedkMnNung=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mx2sQdmqF4bs814KvVImFZ+sZU6ArYzr4Q13no+wrv3V9cRd0xJdYbS9zP6YAjroL
	 4T3g5lADoDOTKhU23IfBENFnPpDOJ/XJuVAfzlTa7MO7RBQ3bWF2a/lcA+BoOGRlRs
	 YsQ3N/wj5cXwLsS2zo4IP/lOVxoD1mrmms/rRLk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 326/676] clk: clk-apple-nco: Add NULL check in applnco_probe
Date: Fri,  6 Dec 2024 15:32:25 +0100
Message-ID: <20241206143706.079679614@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 969c765e2b508cca9099d246c010a1e48dcfd089 ]

Add NULL check in applnco_probe, to handle kernel NULL pointer
dereference error.

Fixes: 6641057d5dba ("clk: clk-apple-nco: Add driver for Apple NCO")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20241114072820.3071-1-hanchunchao@inspur.com
Reviewed-by: Martin Povišer <povik+lin@cutebit.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-apple-nco.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/clk-apple-nco.c b/drivers/clk/clk-apple-nco.c
index 39472a51530a3..457a48d489412 100644
--- a/drivers/clk/clk-apple-nco.c
+++ b/drivers/clk/clk-apple-nco.c
@@ -297,6 +297,9 @@ static int applnco_probe(struct platform_device *pdev)
 		memset(&init, 0, sizeof(init));
 		init.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 						"%s-%d", np->name, i);
+		if (!init.name)
+			return -ENOMEM;
+
 		init.ops = &applnco_ops;
 		init.parent_data = &pdata;
 		init.num_parents = 1;
-- 
2.43.0



