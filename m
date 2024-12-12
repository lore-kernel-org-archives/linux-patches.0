Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3274236926;
	Thu, 12 Dec 2024 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019779; cv=none; b=sLxQ97OlLpz+uwI+ykXsQbMDQyUJDfYyeKkjKTa4xjEWyXbdAHiK6w2Zfer1pamcx3bfLRbigvo+suQmtWoHjRkkf8uuaxS7HlwRnMntnk5Vy/gHZYy8zGSiIMdMZ0MbqmxHqyj0juoyF+DkVcJk75K73aol3Bbp0CId0KlMPac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019779; c=relaxed/simple;
	bh=Ts8Raz3E9xXSM7qNpW2/9mJlKbS4NO0joJHObbJiIy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWUzWeK3UCUK98fyFeLBjoD0J8bcvH3KLfVfmBBeM7bnvasJWbgTqDvJGFqb/naknA0rA4zN6LA8NlKhpmXpZVKoXW/G9VYM9txFn4CinDmwfb33O/NUkI5PeZfRE/LLQ71JagbYPP6E5i7JAALVquTNndIy5s6nzshV2RLZu/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPnlPS/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPnlPS/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23E9C4CECE;
	Thu, 12 Dec 2024 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019778;
	bh=Ts8Raz3E9xXSM7qNpW2/9mJlKbS4NO0joJHObbJiIy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPnlPS/l4g6lJMkTcJgF6YP7i4rO6n+iApOIo2l0jwpmb/v9zfbOc2KuSM1LvY5Zs
	 ez8/AafQ5/bqg0BFG4RHNG4IYJgasBsGMaxDfQEkNfHbiVKMepXa6QR8laM8Oijxbl
	 Dfix7UNJBqqJ98L1o2udOsIuVE2LBEbHI9fJ0F1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 255/772] clk: clk-apple-nco: Add NULL check in applnco_probe
Date: Thu, 12 Dec 2024 15:53:20 +0100
Message-ID: <20241212144400.454690485@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



