Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C953128ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46966C433D2;
	Mon, 12 Dec 2022 13:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852605;
	bh=47MdCbnNyTWsRRKRgeLfoJxE6lQCtha12xlbpYXm9sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JiS7gnjgZGzCunD+LLeGXgvTRHQaJQ4zqhSy4O8eT0hE6PyL9UZ8/F6Odux4f2hC
	 mXC05+tLY6GkYfMxmEiKEq//irS+s98+cfG3dd6mFgFlbKX3U7Y6DwIA5dAo0Sfu2H
	 imW8vlOwtaj+8MscDonWFPqRev0sBtHm4wkU2VRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 114/157] selftests: rtnetlink: correct xfrm policy rule in kci_test_ipsec_offload
Date: Mon, 12 Dec 2022 14:17:42 +0100
Message-Id: <20221212130939.430915768@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 85a0506c073332a3057f5a9635fa0d4db5a8e03b ]

When testing in kci_test_ipsec_offload, srcip is configured as $dstip,
it should add xfrm policy rule in instead of out.
The test result of this patch is as follows:
PASS: ipsec_offload

Fixes: 2766a11161cc ("selftests: rtnetlink: add ipsec offload API test")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20221201082246.14131-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/rtnetlink.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 0900c5438fbb..275491be3da2 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -782,7 +782,7 @@ kci_test_ipsec_offload()
 	    tmpl proto esp src $srcip dst $dstip spi 9 \
 	    mode transport reqid 42
 	check_err $?
-	ip x p add dir out src $dstip/24 dst $srcip/24 \
+	ip x p add dir in src $dstip/24 dst $srcip/24 \
 	    tmpl proto esp src $dstip dst $srcip spi 9 \
 	    mode transport reqid 42
 	check_err $?
-- 
2.35.1



