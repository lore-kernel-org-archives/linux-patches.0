Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038623;
	b=34FWpwb5e+xZszzDqYUvPrHJv446FmH6phs9b2C26x+ulzMfD7ZDYYC3FvJ7xV01vBmV
	 1V6QwM9bCOSM8cXL84YZic10nHRzH2XXTAYGhLdNBVGbXCtl6Degoym3LuIUgzTHo+pFH
	 PD/Cbr44dNpaJo9OndFdGYSeN3UftAYhwUZMltH+eW07PwlrfvqpqFaatTPcj/Q2bGxe4
	 BWLFi4mNWVGEPh/sWJjfSKImrlttXce99hiiBjJ9sqUbRQHnxl7KUlNOmXwmPA5sPkZOU
	 cO6Q4rUWviaQluJ3r2x9b73Bi4IvOgnLsm2UwIfhLYsd6h25texpEcI80UbKfAHfOAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J2O0799H39hOyrWIqVWKzDk75UqB95u/E6wfpYpOdWg=;
	b=MsX1VxsSC1HZKRiylEcoFj6UBaj9/r/e3gw4bvsuh1EyGDQ8Bv6PPNXojChNrQKeXJP8
	 5bATRue7hBwwb/T4hTfAxUwNotN4bfhE9beRGJIdg255dT7Xfw5SmGFjHO+kWTtMD8xuK
	 9/T2DuAg+Qn+2HK/zb5sxMAqTdG7yWD5sT/XDTguWt6uT/DiHHGVnEnd6b6SxlR2Tqar8
	 9VkVJ9eV1ABb7niNTva2YrKlhFwzG/QCRfqam3Eh889+FHwJzTpJbotBw/RmaoaWJRd9f
	 uakLVwUh3lsHsirL0hmZJ1aXzJWHJtbPO9yLiXSSHsr+SjjXuCxpWsT23huCnVELyaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eFIV7V8D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9D3606A325;
	Wed, 18 Nov 2026 21:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eFIV7V8D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7EB1F000C4;
	Wed, 18 Nov 2026 21:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038623;
	bh=J2O0799H39hOyrWIqVWKzDk75UqB95u/E6wfpYpOdWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFIV7V8DMdW6d4BwidW9GINtRCoOyeGMiiAhfhVwrxwhqwCGrWW9fxCdBT+91l5y0
	 v4fwkDkga3Y15/zPvwF0m92gYJiumgIddxKKkXwSMo+dbKZ7Bzafet+s8LYFG/lYls
	 iJXFhZKaj04qrX8GOErsPsBj2Z02uSpboV3JHGQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1809/3318] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
Date: Wed, 18 Nov 2026 15:40:31 +0100
Message-ID: <20261118150416.123825024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit 9b036546a02c6c9a5133f9c1e93503896595c6ba ]

When dax_range_compare_iter() returns a negative error code (e.g. -EIO),
dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds the
positive return value from iomap_iter() indicating more iterations remain.
This positive value leaks to the caller, where vfs_dedupe_file_range()
interprets it as success (bytes_deduped = len), causing userspace to
incorrectly believe deduplication completed.

Return 'status' instead to propagate the actual error code.

Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://patch.msgid.link/20261015143426.17620-1-jianyungao89@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
[ sashal: adapted status references to the existing compared variable and processed iterator fields ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 94d552a2e6097..bcb93c105bb44 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2067,7 +2067,7 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		compared = dax_range_compare_iter(&src_iter, &dst_iter,
 				min(src_iter.len, dst_iter.len), same);
 		if (compared < 0)
-			return ret;
+			return compared;
 		src_iter.processed = dst_iter.processed = compared;
 	}
 	return ret;
-- 
2.53.0



