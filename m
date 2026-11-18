Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016222;
	b=SHfXo24B5jRUCnMsqfQnwJhEdr2ZGU0w26l7ILOpKIRevG7hfZW8Rrc1cml8vDpTcbo5
	 QR90HNB/btXkkH1p/qHmE6WeJ2lgPWlvZrDWPWbTc7vXqkGBgtKt9OYxAS4zLnRiL5DSu
	 xOnp2vsCTC+f6Mf0tD5AEXa4n3ciunbYZtK/88qnXSztF/+QrqxdGjbRKDu4KifRotp5S
	 +hrpQEjAeek1ae3i/wqHBypD4ZhLVANieyo9PS4L38v6Ji2ljnHLJK+8Imc0LsulzzB0S
	 sNi3hXWPQD/6jXS4uqUJ/Gvjc7rv7PUzD5kQFbgMGAmwtoIQHlGPsiV84iQyHFGlogw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oZBWTJYiA/NRmQ8Js/aw9TKEAnDFWHigykRfCfSMoe4=;
	b=Gwy66V2wVKVG/nnerGStFpIHLVj4d1OSGAT6RLY1p/YIuI1XXBjpW0Mh/H4PW0iNRTSG
	 vH6QlSfJbzaD5A0n0kN3rySguKSLrFfpzRcvdubzityB8TlHPZY7/WZ86uYSB4ZCPTFVF
	 YECtxd5MSQdjT85jEPTyhpdodeOPbK/qxsiqQYADbmC8JW4HZt//yxTE3NgoAZrcbWZAh
	 RzeBrC1QxOZUpqgx/qcShSuh1rDxiFqLZL1nPMO6RZZjojWDiC9eZxe4XktEG1GJNHR0c
	 OGbmWp/s1GJX0MBImB1kW3UeLkMN8RF0xHLvb34JH/RmldFzCM8v6/QpimmUW143Qnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxLUSIjC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9596606A325;
	Wed, 18 Nov 2026 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxLUSIjC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048011F000C4;
	Wed, 18 Nov 2026 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016222;
	bh=oZBWTJYiA/NRmQ8Js/aw9TKEAnDFWHigykRfCfSMoe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxLUSIjCDW0D+DBXHJvti5ZCvJxO5H0QvfAYclnR//vlZGKnH728dIZtYqbD+d7b2
	 1J19qPHYKfdUUzmYLSemBHtG4bjzZEnXAmTnV+vWYXofdmuQ0jE18KbpJHuE5vSOxJ
	 zOs/rbZyv3hKuMfR69P3cc8QX5Q6/9Kn3Fg4b4jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0452/2651] fs/ntfs3: zero frame pages on read error
Date: Wed, 18 Nov 2026 15:28:12 +0100
Message-ID: <20261118150304.083282739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 36bdb1983fef2..4651dd8f6464c 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2524,6 +2524,8 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
+		if (err)
+			clear_highpage(pg);
 		SetPageUptodate(pg);
 	}
 
-- 
2.53.0



