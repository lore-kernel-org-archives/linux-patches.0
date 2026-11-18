Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021146;
	b=RWFAwQ4jQIQyEHFS4ZVnsOApZ08xeGHa4fVkA3iiA6Y5FTFMTkFqGx+umz3HkuB90BCT
	 AJh/p/9MmINdJmypyGz3I0KCFgmn/S6lWKYSJGfK54jVCiAT/s32RZeVnXHM2HIs3p+FE
	 bJ0NxEj/xSrrQTPOordUq2sqWrCzJj54Vn3s9R2m0ncF3ezf7l42HvCX6PY4N4ajhuWXt
	 3PULuP1eZfzjLCBPOVHhK/fwtMP2bYfVJcwoTTMEjffs3Zt9COwuSXdV7g4gsVwTdtUfP
	 7JSKlsdwLcGIJbsd8u7uaxTvLIdIvLo+zF7pNugS6XHYbsTnPnDthVPY8euUU6WT5KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rd+YS4P+IrxuVvtocKR3O+vQAG33KiI8qfyToVcx7u4=;
	b=Kj0jZXYluzP+FlJEhL4O/CENwlABhhz0DGdcuzRiJzoOrjKwDQmzUpuJohgiBh+N+DlR
	 PvnRyQOjrh54Bh4CXmWJosQI/jLKT1sPg9kJXojhyuyeyXjLFtAyqgYysMJ/mLel2WEKh
	 nEkRRyA7fGYBHLLGKl73Po+XdoIvX2hPYTG/+zgH4uVp+o+vTGjvR5NJkcwheYsP6u6P5
	 XIYL72Im4e6tYKb8boyHo4jiJO2rVVP8qocg53CnZ0BXpFakA0dzpHAZXWMBPhzkAHZ1e
	 LShvVOh86iAv1LAptTWglgiNRVo3uiBph4cL/Xp8UMp6q7B/YQdfFB0HiM349Trcmrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywmmXSMp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50677606A31C;
	Wed, 18 Nov 2026 16:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywmmXSMp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC25C1F000C4;
	Wed, 18 Nov 2026 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021146;
	bh=rd+YS4P+IrxuVvtocKR3O+vQAG33KiI8qfyToVcx7u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywmmXSMpaRlLFz2mqjbrNZAekiiuidBrweQDO09Ev0fRYJu5A4VMWlgPQKawJSVd4
	 IB+BgEzBiILoVoNpEQmTozAaj2ituygV/GeMVUDhC22bWDcB1g4dXj36BdcbVTOrUc
	 RWXQ9O6fXyQUD/Iz/DRS69ium5YCMx8H37stSnMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2203/2651] ntfs: preserve the 64-bit FITRIM minimum length
Date: Wed, 18 Nov 2026 15:57:23 +0100
Message-ID: <20261118150405.000279084@linuxfoundation.org>
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

From: Xuewen Wang <wangxuewen@kylinos.cn>

[ Upstream commit 406747e46dc8eb73b0976b1e459830927d6022b9 ]

The minlen member of struct fstrim_range is a 64-bit byte count, but
ntfs_ioctl_fitrim() uses max_t(u32, ...) to compare it with the device's
discard granularity. This truncates the requested minimum length before
passing it to ntfs_trim_fs().

For example, a minimum length of 4 GiB is reduced to the discard
granularity, allowing smaller free extents to be discarded. The truncated
minimum length is also copied back to userspace.

Use max_t(u64, ...) to preserve the requested minimum length. The bitmap
scan already compares the aligned extent length against range->minlen
using 64-bit values.

Fixes: 9c87959601e8 ("ntfs: update file operations")
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index f8f4418cbcda8..bb8b5613c7a5f 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -888,7 +888,7 @@ static int ntfs_ioctl_fitrim(struct ntfs_volume *vol, unsigned long arg)
 	if (range.len < vol->cluster_size)
 		return -EINVAL;
 
-	range.minlen = max_t(u32, range.minlen, bdev_discard_granularity(dev));
+	range.minlen = max_t(u64, range.minlen, bdev_discard_granularity(dev));
 
 	err = ntfs_trim_fs(vol, &range);
 	if (err < 0)
-- 
2.53.0



