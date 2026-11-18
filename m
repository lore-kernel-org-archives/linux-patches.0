Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059102;
	b=3ZS0mgAnkX4KCTdkk5ciD326nZ5DxSlUPzy3wzc2rsp7BEO0g6jWqJ8s/t1daHET/3nS
	 GCRDefVhQ+crSuszXQufKyq6e1nWrgBkkXIqKUqoQSzLL1gjqQJW1z12yrVi/muVv3FGj
	 E42E+NAPT/eTiEiq3xMMn9rxsg0boUpxHj/Q21GbfBHsXYH93Kg95gpZT2n2himqgp/0o
	 hHRoCoFxYRm9GAiBAECwDxVY+1LpRdQU6FMwF+m+Wh5seecKvsHRxlNNLT9Hez07rYm9Z
	 4JHjayEOllEjbStKzNoGCnsFq64m5DbIdrLI7Rep4R5c30xF6K9JAO0dKPdErvP+GHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DcOdGImLnpUpV8Qjq9OJfDyLt0OVnzrUfW2UhKMyQYY=;
	b=snWIiYhA/r1FN4p+ORGDClmI5mvtyvD0lWtI/wk1H/088T6/BGQB3LytTJSWB2v53H3I
	 SbTv/3fcUg5QP9HpQTP643UcaRutB4sP7ABFhnHwkAIara8n15LTGZJwyebOR1elX9Pkx
	 x2rgMUNQT7fD8BcUckrQwmjNx2C+SE9RSVSjH9uqQ79go2iwWX8a9vwrOwd45XjsidhAc
	 fvadMVY8CZsFvyd4oMAH+SGSBSwZ0qrOGtnNz6pULIU0LXIm6IIOvMUzhb6riQOLUfSFa
	 D5+puibP6QRfP6dRIpqSVSmJEEkMx5FtDHJ8MwXJimfFVk7wV8bUsjcYAF8xzAqrY4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i93xtcpL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DF6606A325;
	Thu, 19 Nov 2026 03:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i93xtcpL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437FD1F000C4;
	Thu, 19 Nov 2026 03:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059101;
	bh=DcOdGImLnpUpV8Qjq9OJfDyLt0OVnzrUfW2UhKMyQYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i93xtcpLK/9ZF7oCy6DhDyXNk5mxIEJ38ZVqyrERW8XT3Ghl0990lDnoapsrmTpC8
	 AuOY2Q4iN9rKFKUpFT0YcKvrv1bGG5UYnewfe1WaobvlA5yIHwVAQZ2Tuco/1iHNyW
	 D2s5VAOMFe101yE+TGsdO4iuNP7IT3PxEGDZcHrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0723/1848] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
Date: Wed, 18 Nov 2026 15:46:01 +0100
Message-ID: <20261118145946.287377711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit d8c2bc88460f89e543ab3af622fc8f34c7011d71 ]

xfs_fs_commit_blocks() adds the client's length to the offset before it
clamps the end to the file size. A large length wraps the sum and
reaches xfs_iomap_write_unwritten() unclamped. With the previous two
patches the LAYOUTCOMMIT then fails with -EIO and converts nothing.

Clamp the length first.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 053b99929f835..8b82249b48110 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -250,9 +250,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
-- 
2.53.0



