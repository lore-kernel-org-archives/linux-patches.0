Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBFE1D4154;
	Tue, 15 Oct 2024 11:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992922; cv=none; b=VeA0ppH1JLGYiKrSQUF05u83Oe4/Y1A00dOnbLdq7oBNQbBibgYHkCBJupYOYuqRySXmLAvYY2j4+qsWO4TBtIPKeED5MlvigIRSVVWI0rEma0HhXXxj/JZnZBA855mvbHHxgY0dM8Gyvp688Q9/TpjHXtXCWwzYeblFATv0n3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992922; c=relaxed/simple;
	bh=04UqINanThXH1FFXyHnze9rtqu0xW4tUSBZ9vZwLCXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyPHim114n2JdE1g/rvw7iiVrDPgDskByLY69NRYTJMeFmcOszBjVRB9I7VW5lXn2xp+vQco+sjCBM2j8/gpY+Qqz1YgEXm+8TcQywV00rT4LMMFOdK5tmPyAfKP1Ce2jRDGNQxpoIAeQP9d9Igf81tQWe4PVatlBj0xBaBaabE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jl7zf/fY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jl7zf/fY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15C6C4CEC6;
	Tue, 15 Oct 2024 11:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992922;
	bh=04UqINanThXH1FFXyHnze9rtqu0xW4tUSBZ9vZwLCXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jl7zf/fYLoojd/Je5rJ5vM3feEf9DeWwUheGNY4gnDNZFH7zozFfXnvvlPmNTqEdn
	 ZDPlLydE0h3rib5Rie+G+8+40vH2t9jbQVseK0oxfysuL0PWxYtsWwCWKUWsG7Jldp
	 YC5O3oRNy+i+IN5JFluuTe7FizuHfiyZwkzogeVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Hawking <maxahawking@sonnenkinder.org>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 259/691] ntb_perf: Fix printk format
Date: Tue, 15 Oct 2024 13:23:27 +0200
Message-ID: <20241015112450.629215195@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Hawking <maxahawking@sonnenkinder.org>

[ Upstream commit 1501ae7479c8d0f66efdbfdc9ae8d6136cefbd37 ]

The correct printk format is %pa or %pap, but not %pa[p].

Fixes: 99a06056124d ("NTB: ntb_perf: Fix address err in perf_copy_chunk")
Signed-off-by: Max Hawking <maxahawking@sonnenkinder.org>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index 65e1e5cf1b29a..5a7a02408166e 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -1227,7 +1227,7 @@ static ssize_t perf_dbgfs_read_info(struct file *filep, char __user *ubuf,
 			"\tOut buffer addr 0x%pK\n", peer->outbuf);
 
 		pos += scnprintf(buf + pos, buf_size - pos,
-			"\tOut buff phys addr %pa[p]\n", &peer->out_phys_addr);
+			"\tOut buff phys addr %pap\n", &peer->out_phys_addr);
 
 		pos += scnprintf(buf + pos, buf_size - pos,
 			"\tOut buffer size %pa\n", &peer->outbuf_size);
-- 
2.43.0



