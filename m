Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065026;
	b=XB5M/lU/DSmUIZtdAildqpn7xKjmGkn2v8H2TwrrHdBYrjlKtcWvHbWQS0r6FlfYGaCk
	 7/8N5GnsvKYuPW4lr43R2ymtXke3f+KItN2xBSNABnWVW+s+gKMn7a2IkE1Utyhv4ESEW
	 p6z5hNwRat2behY6/ZB/gZLVtgIWVqbbtblP+imbyoIaInBBtlGIoytx94udr4g6Jy6sz
	 GvMi7jMzquF/eJj9nsFyk9KFbcjFw/XyO2QV9PfKnsk5E05eAI8RuRIKAXKedsawSeXAh
	 K6AZPVsJYaJKgbo0LuvVNvJn8Rf8vMEKsk2CswVBpZ4NFiac882m7mAuUqQD9RbjQTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qINWl4FTVxmjBHVT0zGig37Jdk/yA+4o9B47PI/tx54=;
	b=dIzl5w6y1wPLom9xb/sxuwgPEE+SQLkqGzMcTzj7Sf03O2rroWIW4CwjBYPwPVuJmfv1
	 XUOeJSUu4lwOXFMtC9uuq4j6yg3T/erdDCWyk8bSJm/urOY+CRQI2P4LYKPp+u/aLEZC9
	 Hjs+WW/Q6IBMt5JTWKjBSCU3lVtbB+3ChbjvquvZYHuXX3dBS1Zc2rdTww810ofm6s5w+
	 R2EGxfA5BX8XcV+CO5ApbAYjvcBGaTUb2mCZaPT8TSP2oJMYIPGGDn/WgU7IisDF5z1Hg
	 lL3QIYDmm1v3+VsXpwKnxPUihM3IRP+caP6u97gRuF/oS+zbAEu0SfuJ/oR32qiwlQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDeT3r83;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD75606A336;
	Sat,  7 Nov 2026 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mDeT3r83
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA171F0089F;
	Sat,  7 Nov 2026 15:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065025;
	bh=qINWl4FTVxmjBHVT0zGig37Jdk/yA+4o9B47PI/tx54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDeT3r833SyVZNCN+fumadfpGJcu8n2sKhzsvV5JZQHH0NZMnQdkqEJreQsi3aB7f
	 NOCyazhgG9MkIMmYlnepOxx923awllwKRuqnUGQfvLK88K8nSSCskG+Vi1N/uKjqYW
	 wSszOYgSN8ypLNY12teg5lP9MxtDoFV/V1elykdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0885/1257] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
Date: Sat,  7 Nov 2026 08:53:01 -0500
Message-ID: <20261107135003.762206665@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index dbb58692efecf..61dce4601aaa5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2266,7 +2266,7 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		status = dax_range_compare_iter(&src_iter, &dst_iter,
 				min(src_iter.len, dst_iter.len), same);
 		if (status < 0)
-			return ret;
+			return status;
 		src_iter.status = dst_iter.status = status;
 	}
 	return ret;
-- 
2.53.0



