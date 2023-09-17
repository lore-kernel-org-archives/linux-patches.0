Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF1D7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B65C433C7;
	Sun, 17 Sep 2023 19:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980739;
	bh=YrO9HJhduO8DQw+7lL19OCPG7qVa7OrwcE1G2jThcfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAfTN5MJnW5M/Srm0EuIrMNjbzDfhtkkxJxFakrSHBG3PHkwc8azS+1VUeR4Wh2z/
	 Ce1E9MLbfQK75aA0wz7zajBoiLb/HFyHItQDEH+KtU+k4RUBSaIH7p6FFl0W6dKpSD
	 gfwP2Q8ibyti73ftBkD9qXfwwEgMzdOh6LS4D6q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 279/285] selftest: tcp: Fix address length in bind_wildcard.c.
Date: Sun, 17 Sep 2023 21:14:39 +0200
Message-ID: <20230917191100.795634198@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 0071d15517b4a3d265abc00395beb1138e7236c7 ]

The selftest passes the IPv6 address length for an IPv4 address.
We should pass the correct length.

Note inet_bind_sk() does not check if the size is larger than
sizeof(struct sockaddr_in), so there is no real bug in this
selftest.

Fixes: 13715acf8ab5 ("selftest: Add test for bind() conflicts.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/bind_wildcard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/bind_wildcard.c b/tools/testing/selftests/net/bind_wildcard.c
index 58edfc15d28bd..e7ebe72e879d7 100644
--- a/tools/testing/selftests/net/bind_wildcard.c
+++ b/tools/testing/selftests/net/bind_wildcard.c
@@ -100,7 +100,7 @@ void bind_sockets(struct __test_metadata *_metadata,
 TEST_F(bind_wildcard, v4_v6)
 {
 	bind_sockets(_metadata, self,
-		     (struct sockaddr *)&self->addr4, sizeof(self->addr6),
+		     (struct sockaddr *)&self->addr4, sizeof(self->addr4),
 		     (struct sockaddr *)&self->addr6, sizeof(self->addr6));
 }
 
-- 
2.40.1



