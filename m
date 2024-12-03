Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C412B23CE;
	Tue,  3 Dec 2024 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241646; cv=none; b=aLDP+H2owrx+bzxAmrfF+Yya6/AEkCuAPBjiDYn9R3wWWPOyXDd9p/483Lh/GIHNH1eyLe+bOn43+u/Ds4lufvDRR02Ru1m3Bs25oXH+x8AW+/318D3OWPjReolffcg5rGn6yxC0pNMoMacWrg/zXvHhubU27ZSrlmEIojznj0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241646; c=relaxed/simple;
	bh=AKCiCPIiUjyxVEGge9QE52s2sA+/mm9zWJ49cMpS7Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ChI7Mc5ZlcxDuv+4G243Mm++JO0kCkbUheHWK7iCSm47Mj/2jRZCLuh0QXTdd6woleKUgmmWl7dm/q4jImSk9WQ+9RsF2QEyt5THMSjCuHcY+eICgRERbT8RvGwnvLQrCojcT2SUj+RyWyDEd8LkrP26Vb0V298iT8QUWp4vMA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvdZYP30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvdZYP30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F68C4CECF;
	Tue,  3 Dec 2024 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241646;
	bh=AKCiCPIiUjyxVEGge9QE52s2sA+/mm9zWJ49cMpS7Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvdZYP308vVWy4zieRTVXtZ0DRVa3rf1UxW/crdK92jGIVy2k9Osv7qTqJK3268zJ
	 NplHW7PWK+/YHyvyJzNIONvTdajo/l8fdMydfczqbd10DYwJxJljl3QFtEm6rV7QJ4
	 myjcksAxbKhIPNeWaGIPdUqY0V+nXmz8K2iwjPv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 447/826] clk: clk-apple-nco: Add NULL check in applnco_probe
Date: Tue,  3 Dec 2024 15:42:54 +0100
Message-ID: <20241203144801.196823752@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



