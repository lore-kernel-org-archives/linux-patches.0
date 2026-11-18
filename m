Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016600;
	b=mxhLHnjaAmT01ct1PjwKqgTh0xPwm1SVJ4FieURJcVOlLs2fqnlDBzgZU0rn3zJaHSY1
	 +WKXPuIjQKbQfxxe8ITtn+Mi973NYVRr8ZkFCeLeB426M4QX0GAU+F0vohq/w4ud0Hwx0
	 B/Y4fGIL3homaaE9wWgmdVfjVXKwccBkYfn0atUTMNmHVMzst0SXugsUYucaLE43yIe9I
	 ptn1H3OxzJ5YnCgMAcVQBvSM0lFxmhmg/7RkIqueAKtX9AMybL3SaAyQfrHGf4a5WP+MS
	 CTbxl8iClCrvbOuVtRfizYKOtz8wUXITPX1VMwBBHbvhwXw8x+2LraBx/WBtrTzciCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tsojaBcznlsmEDTqNzybss0co30liQ7OAmfxZPmVNtw=;
	b=Kd1fwexVUXzn0vTHqDneH067/ke5vHjfwqL0was8UEkDYhoHbAa+718zby+U4lqACybh
	 fQYeUo7A//ptpIO1/+gdQHx5bAKoDI0f2lYVkNltHIJuDN9S4fV86/iNGqQfRUQW7wkwx
	 MNMNiccssRPLZGYZDmGmykW1oOYAkSOwowyvMguU9nGyD7B/y6wQQq8QVYZ5Lls+RjAW2
	 c0X1zVu8pZaBurKFVuansBTtGs/JG/cikniA7ftnazyWmDMMbnjwmaz88i/lRKdgg8gm0
	 lWF3DeSuCKxlQ3U/FQlGqHQq3xOAHwxX4JgT9PiTifU34yhibXm57Hmp7fDv15nyB0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEaGYGbv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6414606A31C;
	Wed, 18 Nov 2026 15:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IEaGYGbv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395451F000C9;
	Wed, 18 Nov 2026 15:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016600;
	bh=tsojaBcznlsmEDTqNzybss0co30liQ7OAmfxZPmVNtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IEaGYGbvag+brVSCigMAe+cEP5O+QuDfv/eeIZO80k9EUBOieBHArKniOeuka6K6o
	 TCqJKthCq99mFx7bcUtT2jwCAxFyiKZ3Im9wRnghEDdfAm/1pmjEWv7nFwhDasP9uO
	 8IDJ+VHlw5XlcqFY2BFmbouITFQ6QAhSE3LzYvzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Li Ming <ming.li@zohomail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0586/2651] cxl/core: Skip einj_inject creation when devm_add_action_or_reset() fails
Date: Wed, 18 Nov 2026 15:30:26 +0100
Message-ID: <20261118150308.819664058@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit b25af6afd2f26b455108bab03dfeba52378e8dd2 ]

cxl_debugfs_create_dport_dir() ignores the devm_add_action_or_reset()
result and creates the einj_inject file below @dir unconditionally.

When the devres allocation fails, remove_debugfs() has already run
before devm_add_action_or_reset() returns, i.e. debugfs_remove() has
released @dir. The subsequent debugfs_create_file() would then use
that dentry as its parent although its final reference was dropped in
the removal and its memory is subject to call_rcu() delayed freeing.

Skip the file creation in that case, consistent with how the rest of
the helper tolerates debugfs failures.

Fixes: 9185b1a3043c ("cxl/core: Fix dport use-after-free via the einj_inject debugfs file")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915060138.2007974-1-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 2ebf24655cda0..7fdf23b9d24de 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -846,7 +846,8 @@ static void cxl_debugfs_create_dport_dir(struct cxl_dport *dport)
 
 	dir = cxl_debugfs_create_dir(dev_name(dport->dport_dev));
 
-	devm_add_action_or_reset(dport_to_host(dport), remove_debugfs, dir);
+	if (devm_add_action_or_reset(dport_to_host(dport), remove_debugfs, dir))
+		return;
 
 	debugfs_create_file("einj_inject", 0200, dir, dport,
 			    &cxl_einj_inject_fops);
-- 
2.53.0



