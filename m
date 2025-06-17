Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51739285041;
	Tue, 17 Jun 2025 16:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177389; cv=none; b=D/JimIenksVFzmimHrYg1Sl4x8HazTCLgWMUfQs8Oa7dZoJ1W2prVsE9/z+Orw7sZTMdigr0EYzul9qJRunxf6Fj5lV8giXyLlFIp5k0hAdM+hwmwN7EKG1/jiXRJxirVwHYSAU3fko4LxlOPF+zWu2I+EDZb+KpI3mr3qMWOnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177389; c=relaxed/simple;
	bh=6drdaAWgpk6xpIeUEoeEXgWmcAxC7bKb8cck2r570yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oy+2lWMKNPQSA0amjGH1K4H/nvOYTmwMQm5zDb5ujPIu/COszMqakd/Bg0gQhQ0HwQev+n1BnTS8nHWnEpB9sihotqCiTr2YovkgS12tG9cZX4JzSywTKi1JBkIYsaaqUjK5erZOPXnNqHNY+mtpzDxMgPzg4U6zvH6VRA3xbMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3IIGxq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3IIGxq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE11C4CEE3;
	Tue, 17 Jun 2025 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177389;
	bh=6drdaAWgpk6xpIeUEoeEXgWmcAxC7bKb8cck2r570yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3IIGxq8u56zlbZTndPAQ3XTwKTXSWwBSZjYb8U5VRBga8Wl2d3NskjjGfv6+7f7b
	 GZYxwRpp5l8WS4xGQTqD00JI3+PIe24DSS7R0nYSR10M/p1pSn9sTrV5FZJnuqTwYo
	 7AcTTVYFz/qPK5RyAtXUlUDiyVzBjK/UJU7ClHaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/512] vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()
Date: Tue, 17 Jun 2025 17:25:02 +0200
Message-ID: <20250617152433.228234132@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4b91072f3a4e9..1f2bdd2e1cc59 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1103,8 +1103,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 	case VT_WAITACTIVE:
 	case VT_RELDISP:
 	case VT_DISALLOCATE:
-	case VT_RESIZE:
-	case VT_RESIZEX:
 		return vt_ioctl(tty, cmd, arg);
 
 	/*
-- 
2.39.5



