Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C83121E136;
	Tue, 12 Nov 2024 10:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407820; cv=none; b=SJ6oOvknir1PxKHq1jIhbiuVfJQOi3ihCnnhpAoUSzXG+jcwwwP6rs8qNze4IY1czooP5QDkNSK+DdxcVwTY6a7vR3NIxxzGC6fzfigthpAEJI+ZucuAowZvqge+WeFAUmEQSZPcY9v8mvQuY0hOOw1W2w8OQUOiGjFiRbGx9ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407820; c=relaxed/simple;
	bh=esDhLuO5tV5bygxrAtbzVJEc18CwzrglJBYm6Tv7Vfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ksrTDo6ftCyifkB1Wfi4p2rlK0qJtAWHIIsQiUbtEn1bxcrlyIk071HpUwCLbUlMSzPXiQyYb4pXa27ij7GHzMI1V6Fp6djBFNt0ZKp/xkjmus76rvPlzmh7NQbj2qCpZvjkpWFnESTDjm3MwvwNQdGqW+O7W+y9q75y9MdbnAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuUZwMZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuUZwMZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3F3C4CED4;
	Tue, 12 Nov 2024 10:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407819;
	bh=esDhLuO5tV5bygxrAtbzVJEc18CwzrglJBYm6Tv7Vfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuUZwMZJkeejJzcpLD7lJnyInQfaIMdJCWkjtbx4qOrpow4gJyT58rStCkGg64xO2
	 WMoLtDuzQfN48tiWPxjAICygUJrqspzzWiIejmEZw4DPcacoFEKFBo/RakB6Fl7R6v
	 Q8wYFPyCSXGRGO/a0jIHDHR+rXsjLIe+/Fa6/bg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 091/119] net: wwan: t7xx: Fix off-by-one error in t7xx_dpmaif_rx_buf_alloc()
Date: Tue, 12 Nov 2024 11:21:39 +0100
Message-ID: <20241112101852.193013939@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 3b557be89fc688dbd9ccf704a70f7600a094f13a upstream.

The error path in t7xx_dpmaif_rx_buf_alloc(), free and unmap the already
allocated and mapped skb in a loop, but the loop condition terminates when
the index reaches zero, which fails to free the first allocated skb at
index zero.

Check with i-- so that skb at index 0 is freed as well.

Cc: stable@vger.kernel.org
Fixes: d642b012df70 ("net: wwan: t7xx: Add data path interface")
Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20241101025316.3234023-1-ruanjinjie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -226,7 +226,7 @@ int t7xx_dpmaif_rx_buf_alloc(struct dpma
 	return 0;
 
 err_unmap_skbs:
-	while (--i > 0)
+	while (i--)
 		t7xx_unmap_bat_skb(dpmaif_ctrl->dev, bat_req->bat_skb, i);
 
 	return ret;


