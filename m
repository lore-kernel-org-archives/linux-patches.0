Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019945;
	b=PgNYzAfMWUdz5eAw8lqDNSxuqTJNRu7xBTJ9yyZ3kpRG0NvCLhIXzsCaxQnu6qTGIDd6
	 M3+4O1UzOMXvz0X1ljZ4TYqCY5dJ3wju73hoFw9OB0fMaFGw6JAYujU9repABDSDdbsat
	 4CKdPsC9HdjkgArE16esA4XmY+AUmg3lpi8ekkjg+mJk93dfIiOMgpgU69ieEYJ/4Zn7T
	 6fZZenq352W8yyjBegsahqoxzYeyyJsw59ssOpka6iW8SKlYMlz12wN185gySWi5Jwc7m
	 gxH4Hbd4FmG0bDD+A9+sFR9JWbpLwqyqGOCBkFlsXv/bD1STsSBhSTR+KW1dk3DZXMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pKhsI+bAtl3dtHn4JP5+h3XbqhO7FSrWom5B9hp/lug=;
	b=ityXlNxTlgwityXVukunNH1nL5wb5f1Ccpi5Zvvaixv8RcgcjQEIDN6iR1RJSHID0qZa
	 aHTLNQg1XwRylDOCDyVOABugc8Hl1HVAb3b+xvxUN05rRSDIRZR3DH9hE0jC3LfS7KGLc
	 jou681u64tIQnlG1dlsIXM38M4502a7eH8J4KzLx44dfyP3e1s4uhIn1zBUMflCIw+WQc
	 idksttyDGVtVB6OpeEDDrWwXGwWZMLHSc85MLTvNwfOa3iJyBdJm7xi+kUdmarqG9NTG9
	 XutsUKNmRo8RLcTLC6XwnBipTHk2ZdmtSHzH6t8NBpVbW+BYgJ7Ww0wUfwP+04kYUsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbqYcTtu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C390606A31C;
	Wed, 18 Nov 2026 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbqYcTtu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D351F000C4;
	Wed, 18 Nov 2026 16:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019945;
	bh=pKhsI+bAtl3dtHn4JP5+h3XbqhO7FSrWom5B9hp/lug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbqYcTtuWWCJJQM6wOjBMwXdo1NhSiHZ+LGVS+3IpoNFo46B57yD7FaZyYc/72gpA
	 0bAXB8xVYgzzR1C2JFUBAvLAYY5CMi1zOFvRFFJTbc71hPF94HhuY1yAJcDem7wQ7+
	 z92nh5V+i40AYX7Z0+Hb3EeAg2ecKj5JLCOOLUo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yao Sang <sangyao@kylinos.cn>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1775/2651] nvme: pass partition flags to passthrough checks
Date: Wed, 18 Nov 2026 15:50:15 +0100
Message-ID: <20261118150351.289306332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Sang <sangyao@kylinos.cn>

[ Upstream commit 6908a702955929b0876baac9fdc57070780a76f0 ]

nvme_user_cmd() handles NVME_IOCTL_IO_CMD on namespace block devices,
including partitions. It receives flags identifying a partition, but
passes 0 to nvme_cmd_allowed(), bypassing the partition guard and
allowing unprivileged passthrough commands to access sectors outside
the partition.

Pass flags to the permission check, rejecting unprivileged commands on
partitions.

Fixes: 313c08c72ee7 ("nvme: don't allow unprivileged passthrough on partitions")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yao Sang <sangyao@kylinos.cn>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 6539d47500986..f2904c7fe0abc 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -343,7 +343,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
 	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
 
-	if (!nvme_cmd_allowed(ctrl, ns, &c, 0, open_for_write))
+	if (!nvme_cmd_allowed(ctrl, ns, &c, flags, open_for_write))
 		return -EACCES;
 
 	if (cmd.timeout_ms)
-- 
2.53.0



