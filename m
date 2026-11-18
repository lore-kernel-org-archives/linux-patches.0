Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059099;
	b=z3udN6znEb158JgcZtuHo/RX55/hxGTqWFsq763ZusaWf2TBlprsVsKaLYxfveojYErM
	 NpYC7LbOmwq7zlJ/QbrWh02nzt+AVh0gcHg236nhSIhd19FQKzyrb7ZLZdnPX8J6iYCJH
	 azCV9z2ZP05miCACNvwpnzayd9pB2D/YMU1aZ3aWWIZ6w8nypusx1D1D9uAB7llTdrb8O
	 SA1TZ9STKDq7EzG0E6OZrSwFeR6DB94vFu9Ub9Gmd5IRmvQO3EqdoCBURtYvwlAVOX1WY
	 D0lyRX8I+gFR4L0ry5Cen6G/sHW2F+A/+6XLV2G5gO7Ng8TBfcp/j3EH4p3ikaxJxlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HWdDykqRUeeNED11skysv73biK7ccmKKRzibMs8ELww=;
	b=NbYTywkdbNIGrxfcb18RFnlvGr2pEiDikFFzvVkVJNo355MSa54AZbkddZdzU3TEjNhp
	 mzG0aOxWo9AzzTFh3hSwV16YQ+9igJWM9pK9AZaJnVcfxwYKRv85OZTmaicY8oaG7y+d7
	 ZjvhBQ4mTLwitmXpR9BIyizWpb57IOwwirYs+BJNN4qg3GGZnZTIqX7TXflYxRnXVA5V9
	 hF2H5fJsMXDecMZx2+cYrBvtSH+ZwUthrUfaBjE3Y6MUCjXA9MQC3/znura4/mg7hggfx
	 Uo7ZcnbOu62tdKq9JaNyMN2plOkPHNI95cUjQsEP5CHsDiuDoWEQ23WdnXBUdalpFXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vo6nLgky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7AE606A31C;
	Thu, 19 Nov 2026 03:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vo6nLgky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC081F000C4;
	Thu, 19 Nov 2026 03:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059099;
	bh=HWdDykqRUeeNED11skysv73biK7ccmKKRzibMs8ELww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vo6nLgkyIqHDAaQ88X3egQZ7eopEISwQGRXKjSwi11yP0lzeBzPcxbTJQ9e8Ok0dj
	 vwWMVW90+o/6IZ7g/gRMftcM/OxwZYDjy7Fi1iefcQpj3KxMQv6S0JXnOSbE9wwmpo
	 9VRYIu73lisP/4bN9S57Z7qeegSHLQlKf/+mfYfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reid Downing <skibletz@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0722/1848] xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()
Date: Wed, 18 Nov 2026 15:46:00 +0100
Message-ID: <20261118145946.090711705@linuxfoundation.org>
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

From: Reid Downing <skibletz@gmail.com>

[ Upstream commit b7eb276a39b14e685c2fe578f8ac22fc48ff9e6c ]

bs_blocks and bs_xflags were both read from bstat32->bs_size.
Read each one from its own field instead.

Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
Cc: stable@vger.kernel.org # v2.6.29
Signed-off-by: Reid Downing <skibletz@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_ioctl32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c1771e7281177..62d62c2a9fc07 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -136,8 +136,8 @@ xfs_ioctl32_bstat_copyin(
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_atime, &bstat32->bs_atime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
 	    xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
-	    get_user(bstat->bs_blocks,	&bstat32->bs_size)	||
-	    get_user(bstat->bs_xflags,	&bstat32->bs_size)	||
+	    get_user(bstat->bs_blocks,	&bstat32->bs_blocks)	||
+	    get_user(bstat->bs_xflags,	&bstat32->bs_xflags)	||
 	    get_user(bstat->bs_extsize,	&bstat32->bs_extsize)	||
 	    get_user(bstat->bs_extents,	&bstat32->bs_extents)	||
 	    get_user(bstat->bs_gen,	&bstat32->bs_gen)	||
-- 
2.53.0



