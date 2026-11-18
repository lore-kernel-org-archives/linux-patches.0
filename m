Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023737;
	b=2XvkJu4+BArekKfn20Rl9nE9lVIX9dQbKCdLEcUZmFJN/LL7MIZLhqOUQUWGNKrboGjY
	 yxOfcqHMRGqZBfuENGQgaZ+UQ3O2lCpDN9ygzpaXUPEabXbi0QuPbwVo6UcYTBP2D9wT0
	 Lhixt9vk1/9DqSUCeHJmljHHLhNIPTzqF5TWTJkY31au1E1ymfbArV0SKUpTeiY8V1ASB
	 qGAbNF97DnkaBc7SRzWaCPqWcuLMdyeW3S3qK6sBe9EdMLSF4UCillppFeh9uVtcQ4Ysf
	 SzI8sCp15wRXWSqPlhizu5DTv4BLpRUUT+Kcb/SBUGknThrHhuEIAQtiO0jLhMkmuCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bR66snseKV1gWvoWDrhj7aDIMCMDR9ysVkk9VHJZkuM=;
	b=L6Cfqw5nzw3HE21wOmZY8hpYztbYBaNEOg5UoFdAhs2kqrRGSL1kRhj3EATSEFj8sfHg
	 la/G3FZJVPf+Z9gzvk2i36b+OXSi85wkI83fT4XTpQk5y1gEbgJWeek0HlvlMo4Wentv0
	 1T8yxWm4Th3EuMbKmji+x+nMFm2kC+gTJdND6KwWdktGzvCnBJTUDJ6n+9pGPp1MUQdcJ
	 g9DDNPkOxmAESDsV4yzNMaV5DcrtWqaVYYoQYe+gEBEyu7eXxWgCMQqSbrY4vnmRWJme7
	 Lnx/9tii2hiDIihuOgNGeh0L/LxOJ5UUGScBrgOpqt1CGl7JMsq8mad1uEgM4RZeVYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a6dbEi/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB278606A325;
	Wed, 18 Nov 2026 17:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a6dbEi/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE881F000C4;
	Wed, 18 Nov 2026 17:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023737;
	bh=bR66snseKV1gWvoWDrhj7aDIMCMDR9ysVkk9VHJZkuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6dbEi/8WtL18aNBPpYtOfiV0PXtO6Q+NLtcjXjth+gcDDOGtpkzznGQBQm4oQPt5
	 9boS4Fkp3SkNyk3I1Lp8i3A7msSXfpZxs+3LU0EZojI/0v63n8VKZOlrHgo+EVV6NQ
	 8Q30wmiOQyiPeg5JHRu59o5A//zthbBMlDyNdbJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0435/2151] fs/ntfs3: zero frame pages on read error
Date: Wed, 18 Nov 2026 15:36:10 +0100
Message-ID: <20261118150137.884166070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit a32e893a077a4b0d3b04c86cb7f69e354a187995 ]

ni_read_frame() marks every frame page uptodate at the 'out:' label
regardless of the return value. The pages come from ntfs_lock_new_page()
and are not zeroed, and several error paths reach 'out:' before anything
is written to them (e.g. a failed decompress_lznt()/decompress_lzx_xpress()
on a corrupted chunk, or an allocation failure).

A page marked uptodate is served directly from the page cache, so a later
read() of the file returns the uninitialized page contents to userspace.
On a crafted compressed image this leaks kernel memory, including pointers.

Zero each page on the error path before marking it uptodate. The success
path is unchanged.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 8269664ce2065..81b536a268633 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2703,6 +2703,8 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
+		if (err)
+			clear_highpage(pg);
 		SetPageUptodate(pg);
 	}
 
-- 
2.53.0



