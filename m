Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045680;
	b=nrjSBOycWJ+WezU3cEB1gjgYbH/AuDk36sKZJ2wB08nKMsx1iWJw9NNAl0rAdkKjNS9V
	 +B7ofQ4wRWErJ2Ntm9ifhey6URBptcrk0Qhjk5tVlWawa+MzjeYjgrYnI4Aw/BqEpNj7Z
	 TOJqCXW6W4aTLtlp/6TKoW14H7q1X5NInRG1lphlmYxIaNg5fB51xW4DO7YxtnjNTEhV7
	 ri9WVn0RzPNe0VmpkfzDiyD+cpL2KcFa8SntvNa4kQlHXZXAmwd6fviNNE3sNU/BYFTHq
	 1wFUsMvpFrgdjnRZ3c7FiI4iBJ1eozw0czSZuvIdOT/D2trpWYzY+G0RCi6SRu35XIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JrOfu2Tb2ZmglPJUvfyHvPKavZTmEA1/gV+sB4pCkq8=;
	b=0bX8a1mlm6BYJo7b60k7MAox9KkHiTWDt4lLcAzEqiYCW9cwMKA2uuHF+brkuY1iL0qU
	 jnjDuxd/OI+UIRqMD8tWvygQVZiR2eCo/58ssyRXphfPIg4zsIUX3CQnos6zSWse7I/tq
	 s4n3OzMLTj4B0zQr6L1cl4F+8HYguSWGqh3INynhmwNjnWNfzuK7a9TbIPG/YsozqDfFq
	 rbK6GnI/YvAUfSuLq4l2I2om6i41bPPK4BuhO3oJULveQTt2HIMZfYDA6DOZUPvSb2jjW
	 45XFYPO5zIrcDvr8TqX2VbCnHl+exQI4uwjyDwXhdpe6PdtuYoaPXIBMZ7EgHsXqJqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZmE24wE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7496606A325;
	Wed, 18 Nov 2026 23:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZmE24wE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4BE1F000C4;
	Wed, 18 Nov 2026 23:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045680;
	bh=JrOfu2Tb2ZmglPJUvfyHvPKavZTmEA1/gV+sB4pCkq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZmE24wEUZyHNQwT7z46AmM6/E5FW8Dk7NHSSD9yytWYHYJFTOBGc6RoqvSHwlYfx
	 r03ifcnWTR6oEt2RSo1m/rypdtUGkUuWHWDBftFXrnqC5cfhfN6UM4B1sbjUAaqH5x
	 6o/gHffYcYkSMs9n4BuNjeg//bvyaC+ghnWjVxWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1010/2857] net: unix: reject negative max_dgram_qlen values
Date: Wed, 18 Nov 2026 15:34:04 +0100
Message-ID: <20261118150237.960704333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingjie Wang <1075151112@qq.com>

[ Upstream commit 1a4e7bc6e3457ad95515a9d2c042452c3161bb2c ]

net.unix.max_dgram_qlen is parsed as a signed int and copied to the u32
sock::sk_max_ack_backlog when an AF_UNIX socket is created.  Consequently,
a negative value such as -1 is accepted and converted to UINT_MAX.  Since
the receive queue length is also u32, its fullness check cannot become true
for that limit.

max_dgram_qlen has no documented negative sentinel.  Its existing signed
interface represents nonnegative values only through INT_MAX; negative bit
patterns are not a supported encoding for the upper half of the u32
consumer range.

Switch to proc_dointvec_minmax and make the established 0..INT_MAX input
range explicit.  This rejects negative values without adding new accepted
values or changing the default and zero-value behavior.  Very large valid
values can still make the queue limit impractical to reach; this change
corrects the input domain rather than imposing a new resource ceiling.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/tencent_A643419B56079E9A448D97922763FF069F08@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 3 ++-
 net/unix/sysctl_net_unix.c             | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 3fd6e0f0d3c96..95252c2d02db5 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3071,5 +3071,6 @@ ecn_enable - BOOLEAN
 max_dgram_qlen - INTEGER
 	The maximum length of dgram socket receive queue
 
-	Default: 10
+	Possible values: 0 - INT_MAX
 
+	Default: 10
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 500129aa710c7..589452009f322 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -17,7 +17,9 @@ static struct ctl_table unix_table[] = {
 		.data		= &init_net.unx.sysctl_max_dgram_qlen,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{ }
 };
-- 
2.53.0



