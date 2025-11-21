Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5949190477;
	Fri, 21 Nov 2025 13:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731744; cv=none; b=ccsP3dnrPYo/uFbrYtz8jdwNEEoo1d8Mp5veKnOaVtuR8oh4X5yGtKr/ZSHOdDrgGIhDppnEj0gr9d0c9d5aIevN5bfC4vs6TyWu+pBLZIW55Y/3HTySacMSnhJQptKgze6b1diqtZw7rdinjkkjAZ2zO3PMjYBY9loX5zUE7Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731744; c=relaxed/simple;
	bh=fLOcMbXhM8aoj2JLJbGMpaXCIwVNSPDBEvrg8LmC09c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KamtsM13+p1itpgEjp7bcX0dPywvyAZ3iS2CUng9j5t3xnFrvQPQptohCzXfmeUFd5ev50IAjFQlzVK7Rc+fac9XQq+DDrlPtnNn0iNic6fgTixq5aYQHjl3dksZ/AqDX5uBiwZQuZYY6E0yi96BIzFlyMCRatQQijKCfwQLWWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saP00pQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saP00pQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729BFC4CEF1;
	Fri, 21 Nov 2025 13:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731743;
	bh=fLOcMbXhM8aoj2JLJbGMpaXCIwVNSPDBEvrg8LmC09c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saP00pQQZZsqcUt7dKttIGSEWyWeQ0XqBxuFGlwPwXFm1s4lwaLgSHv4TeHmSbTGQ
	 P6ILy6ugUVyYMGPwdBovaf2Hr2ehW/R1ZKMmup8LOjGIpM4IRyMNhy2NsT0wPuupWB
	 Em+0lf8105CQidjYM3P4EZEcfcz8N20JTdXGlq1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/185] Bluetooth: L2CAP: export l2cap_chan_hold for modules
Date: Fri, 21 Nov 2025 14:11:33 +0100
Message-ID: <20251121130146.258562140@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e060088db0bdf7932e0e3c2d24b7371c4c5b867c ]

l2cap_chan_put() is exported, so export also l2cap_chan_hold() for
modules.

l2cap_chan_hold() has use case in net/bluetooth/6lowpan.c

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 7dafc3e0a15aa..41197f9fdf980 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -497,6 +497,7 @@ void l2cap_chan_hold(struct l2cap_chan *c)
 
 	kref_get(&c->kref);
 }
+EXPORT_SYMBOL_GPL(l2cap_chan_hold);
 
 struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
 {
-- 
2.51.0



