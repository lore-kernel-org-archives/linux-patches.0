Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062221;
	b=25Rz+XVP9NvbLJu0RTSms82t4sXipILCGHy9EH6822dNN/+vBGW42pWpeOlcBd/GrXqQ
	 6s2Zwc/aXUkIq8p/fr84EV0y86kByepGS2U6aefn8U5fBdEEpCdqhhLz24JZcnW7BMKFl
	 dZzYhZxLdzap2zci2qUsRI6+0iTgDk+GPcf6qp9dYW0rh0MfLs2dMjM0YZ418EcFDdwJu
	 IB2sXEO3+M5pbqj+HVEyrpZPfabyDB/LrGzXakdJfZDFc0aFy3oPgvdnrGJ3Baf6orP7b
	 vWzdkE+ncpMKevfNJf595yzieUZS0/xT9fSLBpPhzoOKDZEav9b6FIlNYLls/eEemcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aCbpgIry8QyE0saEPCQW553cSOkA9kBW2E6XbK+7ADs=;
	b=PWd6sZcJd0qYNdCbH9xl8nJJ8/IclWyF+pvGANiNd5R5ZqZcdl3VvPgQszn8xKdvbiSK
	 Xo+X5ADWoELh7gLWYCHsHjFTdCBgWw327uOWvmODbBFJlZ1BrEoXoZNvygopjnppQJCmp
	 F4Grgh9CCbKr29RvN2yiRBw/gVP4M1SrGrcBBs+/RsYx2SPgj03VzrN/OXOE7Z7Iqj9Ri
	 /VrAq9HdNFm91pFKBZD4Dft/M/BxpLd/v7Uk6ZUbd/fxe5FFh7Z3JfTuHXy05wWNT7wf3
	 yYn3PHfsMr6PDLFOOxQwHvzXWX7hji4sR4P+3lMi+lDkt+nX2B1U/JpzCEFMeUgHm6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5Ly7q5W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DFE606D83C;
	Sat,  7 Nov 2026 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5Ly7q5W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F611F0089F;
	Sat,  7 Nov 2026 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062220;
	bh=aCbpgIry8QyE0saEPCQW553cSOkA9kBW2E6XbK+7ADs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5Ly7q5W4nqH2kdieRAXyhWlkoKVaexKLjjAzOtbryUe4+rf/Co5O3b3ab3h9Zx77
	 k/MBiRVbbMlHZltxtOUq0bb0nSO4J+S89UuWaIr/DYJ7Ss4FsmOerYDCnmw0ZoWNgj
	 s48I1FoD5Pk398hrmR0+/0m6bNtDh+bPeZi0ruRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Moulding <dmoulding@me.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1173/1536] init: fix early boot crash with bare hostname parameter
Date: Sat,  7 Nov 2026 08:53:09 -0500
Message-ID: <20261107135030.682726160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



