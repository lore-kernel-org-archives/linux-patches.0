Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE9F246BC9;
	Mon, 23 Jun 2025 13:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685789; cv=none; b=f4qUNRVXSo4vM5SXwF0qzY/kXXuh3Sjq+ZpNCIs+3J4gIdyr4mWqyxcnMvLoJOt5XJCVs010e98SkzOJpqEs3nbW5HV7mYACdQUCJWCBBClEQJebBTCZy5Gk6Lfxij7n920zZL/YTwn7jkysfrnMmb5onvS7822IxDr2cV7+cao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685789; c=relaxed/simple;
	bh=xxHoxiZP9rVV7MyeFf+lE0H882+l4ITr5DjzwNFV5i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW6sZYLe6gr/IQaFg2Nve3+Xeky6s1TCLJ2yEVc/Pu92thbuxvTAUBHISDk7jZ2ku4qRzMyndfYTcQCX1jNnO9FykSxOGhkCbxYSv18cVSVvHNE1nPYmia8R05m8ur4g8Z0gfp1SRUf9EabMoSCOA/INdnXH+htj5WzHfS1Yt/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kC/kZm3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kC/kZm3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F382C4CEEA;
	Mon, 23 Jun 2025 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685789;
	bh=xxHoxiZP9rVV7MyeFf+lE0H882+l4ITr5DjzwNFV5i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kC/kZm3MTuzgJI9bTf5M48cvh49DCz+tkmRqdjOwo7g0zirZWcF5K3Qu5CZTw5y4/
	 psoe5JeVfq2pVIYN33HhVHN95goNwz+MVfrHEe8oDTibBIIcf40qC6vfkc5WvI3PIl
	 d0zGlyVmjBxmvas+I/zPW8CQa26/fAmTua077a24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/355] vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()
Date: Mon, 23 Jun 2025 15:04:55 +0200
Message-ID: <20250623130629.620807117@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <npitre@baylibre.com>

[ Upstream commit c4c7ead7b86c1e7f11c64915b7e5bb6d2e242691 ]

They are listed amon those cmd values that "treat 'arg' as an integer"
which is wrong. They should instead fall into the default case. Probably
nobody ever relied on that code since 2009 but still.

Fixes: e92166517e3c ("tty: handle VT specific compat ioctls in vt driver")
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/pr214s15-36r8-6732-2pop-159nq85o48r7@syhkavp.arg
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt_ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index b10b86e2c17e9..b62ab122fb4af 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1104,8 +1104,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 	case VT_WAITACTIVE:
 	case VT_RELDISP:
 	case VT_DISALLOCATE:
-	case VT_RESIZE:
-	case VT_RESIZEX:
 		return vt_ioctl(tty, cmd, arg);
 
 	/*
-- 
2.39.5



