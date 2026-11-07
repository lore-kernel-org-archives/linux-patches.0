Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064488;
	b=qbc5neUaxZ67G91xDSdtdKlCikqUK8/FetixreNTfvVbgeIpf6hTbJNY87bVx0y6Cs/3
	 cXAmcKMQQOFM2ftIFDOBxLs2lKxgiDFoPgF6enbauhcGdHBjzWOaBps+txkqrAs9L1drb
	 cW1MR6YSz0I1JbCtyJs5zDEvkrVN5XPeheoitrDd39D6AUCB0sTxLGOIN/BmHvnOYZPtn
	 q2vtKy15fhUCEge4tBGjYxQJsCE3dQam7WnXjTyo24UPfAvwetTCqdnsF2ALouJfZi6zk
	 vChOxG1gRFfRLq5oVuTQJtQ7iK0Gld+g9JTcOr3JyIeQcfBW8molP58+39hpBteGRkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=28wqrs0w+f1Nw7Z8WPcti7aWS+wKg6ubG9fxeQsjbX0=;
	b=E98tE1Vjwxa5Xxh/XFq8xi5UnAYhRUkuIef3oZG4JMBlwxiBeiTxO/MOE1/G8YabNt4r
	 ZONVa3cr5H777s8PZDNIPzQMWTk/R/nQV0zS9qtmpyMzWPr3y4fCji0uapFtOOPlbhfXe
	 CjbH+mt6FGiGo76MB7xxwfAAlCkgHF/wsZQ39T06+FVKS6yLsplguuCuyyPq9IAPHxdk6
	 1YcLq7RpHAOyXeHiMaGr5qeWmzYDPqD7NtBDFP0uu9x35CGBRd1y7Ar3pfxmxwMa52sLm
	 llKr18e+ET8qVkbiaguNh/NM+75ux1rAjGnjk6lYdxePT2DiGg7oo9Im7aWl7f5LJSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LD9sB6d6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3626606A9EE;
	Sat,  7 Nov 2026 15:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LD9sB6d6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AF21F008A3;
	Sat,  7 Nov 2026 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064487;
	bh=28wqrs0w+f1Nw7Z8WPcti7aWS+wKg6ubG9fxeQsjbX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LD9sB6d684Z8RuzgC+VEIEp+sJxxydCI4H1GXe22+bj/MdegjD+XwipcPXxLwrgmG
	 X3SlrNqkElQ6IlPwIrSFcOomSYcgcF4b6Zugn6SCMRqRDWT4eXp0Kb9XLMSopmCcpv
	 QyOilTrZhABZCvrEbW/SlHJV+Yc6ZBJTFwwj/Lek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Moulding <dmoulding@me.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0524/1257] init: fix early boot crash with bare hostname parameter
Date: Sat,  7 Nov 2026 08:47:00 -0500
Message-ID: <20261107134953.893763572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit b6bec5b63a5b812145e53aaad1e63661c7214f93 ]

When a bare hostname parameter is specified on the kernel command line
without the '=' separator, early parameter parsing passes NULL to
early_hostname(), which dereferences it in strscpy() and can crash the
system during early boot.

Reject NULL values in early_hostname() and return -EINVAL instead.

Link: https://lore.kernel.org/20260826100904.296151-2-blum@kernel.org
Fixes: 5a704629f2c1 ("init: add "hostname" kernel parameter")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Moulding <dmoulding@me.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/version.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/version.c b/init/version.c
index 94c96f6fbfe6a..0bd5c45aabc46 100644
--- a/init/version.c
+++ b/init/version.c
@@ -23,6 +23,9 @@ static int __init early_hostname(char *arg)
 	size_t maxlen  = bufsize - 1;
 	ssize_t arglen;
 
+	if (!arg)
+		return -EINVAL;
+
 	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
 	if (arglen < 0) {
 		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
-- 
2.53.0



