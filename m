Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063552;
	b=dg1ZZrl17AFZd0/mr9lyQXA9qjVIPow3SF6A7PyA3s8BAv6PMRAdYI9Uyh+i8mIUHYsr
	 CUHP9pvYIsrerBt7mO5A2P+rD8qTko4Z2QOsXnvGuw+jLJ7zYP3ueKIe51sG3N0VVYRo5
	 iTVhy6tuSiSbqBqUjJhyxflrL9u0xfKp9U5agrHegYdRNT2yMXThaIQtOgyHjwCm79KL5
	 7La1LxnS83vMqYvNDVTOcbk32Tt3gPDrfXkB0pI7EHLXlbKVUoKhpT1F4eUSrVVMcAWs5
	 qoVtQNeJO8CHjbuSfH2u+H1ZjgQiAn9Lisul39qRGkL/7K9KuMv3pQqz3LFUsZFZ85A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qXA3HfLpiWQnlGVG4Z/AGeYodMCV/RDXwb0pJ8qJXgE=;
	b=Wr9cHfrbCzZDdbvtq05aEd2opDLMcfbQVPlR5gt9IBuYNetmc3oJdYEIyaDsXmuSEyuE
	 Wl2NOVVzH97OBWfbBCKC/S+iY0wl1k49pRRotEwn8VW/Sp5y3jrl8oKCuaYtSrHc7/iyU
	 c4qZkKjQvlwnbVuzO8TaMWv3MSmRyzeR/vV0nA1Xv6dLXRF1ikLNlSN0ftXm20BgThrF4
	 wp/HBLFWwDPH+bV8kb/1JYSp7IyRzsY5IBIlq6UcGduNL95xsdjT3hIzPKLaaEvbstHO3
	 TDc1NdPXHa6Qh23Nycc9LxFebrTpHAL2BSKJMza0t8vCtrblxjZUbVJpVzD2+ZsIjUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGD9x2fT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA793606D816;
	Sat,  7 Nov 2026 14:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGD9x2fT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFD01F008A6;
	Sat,  7 Nov 2026 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063551;
	bh=qXA3HfLpiWQnlGVG4Z/AGeYodMCV/RDXwb0pJ8qJXgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGD9x2fT1u7jkrpC4ld0sn4C+V/ODyXukaMeC7Gkk6Y0Tv9m3BSyuhMdkJ1EeLllz
	 Rrbpooig5aJhdxs0fUmTvIl6sM5Vyc3jdnJj/O+jAlhszk4CNRJu0g6SZ+ggOli99S
	 UEAjFPe4jBy22aKtGSj34bSYK3Z3xji1GhOSGkec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 648/869] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
Date: Sat,  7 Nov 2026 08:55:30 -0500
Message-ID: <20261107134914.965577938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 155f8024b30df..30d0c7e4b30cb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2235,7 +2235,7 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
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



