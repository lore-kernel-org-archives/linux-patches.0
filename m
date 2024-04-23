Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA72320B3E;
	Tue, 23 Apr 2024 21:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908483; cv=none; b=XtCLjEdOYoTY8bNETevUJVe+Kwe1a9uiCQkgVqt5wdDdDAL3kNzyQXx124TepCBo/jrV5B0xuF84Lf5r2yzHsR6all4YT2wSpuKc2neTeUsgznmIeUI4g4MlRvFR1vvwjpB09ZY0OL2wSIaf5zPPo3U5ERD9LMFaHymgGvRjbD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908483; c=relaxed/simple;
	bh=Q6pwuAY4Ly0u6EBvNW0Sxtk3ppkIEga11vFMnBbXGN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dapnt2I1bqQu0MoP9yZydje2uyltQBJhD5KP9GUG72iQHZjfKgYraRFfpAi9vRJix9CU8qQU6EJKrI9XscnIMFP0ntXSoryuyYmuB3oDo/DAL1n0fvuECJ39/kyRVNRpRe84Xrsp+OnkVUsKCo1wt1PLHCQ8eDkqWiXsLqxpWfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liO/1QJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liO/1QJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95563C32783;
	Tue, 23 Apr 2024 21:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908483;
	bh=Q6pwuAY4Ly0u6EBvNW0Sxtk3ppkIEga11vFMnBbXGN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liO/1QJztm/ZXB2LF5cy/P2bTvjNaEsWtf8nFxmMK2LfBH/ZKcnfrJQC4ZEEYi89J
	 d/iYbPZZC8KDlDr8PZJ1pGqvKCTpxslLBEOl/hbj4CfDo+NkCTjGe0tmjIxVXP1hz5
	 zv98ezi6UOGD7fDNXw1b/ndkimh58FuAXtYNlCKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 031/158] selftests/tcp_ao: Zero-init tcp_ao_info_opt
Date: Tue, 23 Apr 2024 14:37:33 -0700
Message-ID: <20240423213856.901801643@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <0x7f454c46@gmail.com>

[ Upstream commit b089b3bead532419cdcbd8e4e0a3e23c49d11573 ]

The structure is on the stack and has to be zero-initialized as
the kernel checks for:
>	if (in.reserved != 0 || in.reserved2 != 0)
>		return -EINVAL;

Fixes: b26660531cf6 ("selftests/net: Add test for TCP-AO add setsockopt() command")
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tcp_ao/setsockopt-closed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tcp_ao/setsockopt-closed.c b/tools/testing/selftests/net/tcp_ao/setsockopt-closed.c
index 452de131fa3a9..517930f9721bd 100644
--- a/tools/testing/selftests/net/tcp_ao/setsockopt-closed.c
+++ b/tools/testing/selftests/net/tcp_ao/setsockopt-closed.c
@@ -21,7 +21,7 @@ static void make_listen(int sk)
 static void test_vefify_ao_info(int sk, struct tcp_ao_info_opt *info,
 				const char *tst)
 {
-	struct tcp_ao_info_opt tmp;
+	struct tcp_ao_info_opt tmp = {};
 	socklen_t len = sizeof(tmp);
 
 	if (getsockopt(sk, IPPROTO_TCP, TCP_AO_INFO, &tmp, &len))
-- 
2.43.0



