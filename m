Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7412367B0;
	Mon, 23 Jun 2025 13:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685036; cv=none; b=XxkqGhJ1jI5f1mN2c5m0NorR1kk/qgstAXHLzGBD+bgSYtm5ENaBBULahg09lLJttsau19VmnERBHNlWcx4auYPX85BHi/tYwOiROMP24Z9vH3IspSqGTdLu1YUecWucZf/n8Vl7GZSYzXEf8VYKalNQ+MACsI8lalYVJujs0bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685036; c=relaxed/simple;
	bh=O/M9asMh+dRd9tFt6dz9uqk8ftC7yuHtrGvZ8yhOp+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHE3+t8N6PW0snH+NccnEQrU/pWMXRWFBA8f9HAfTs2uvEGd1+XDI44LFwkIVpUFd0N2QQSoS3cy2L5Gm2LyPvrsvHkLqUY9tu7bZZLN1WHaNDYVUPxJxFUSdeieS67GW3reU1IF7USClMLK8oKQ1jDyZnXDhY3RKPfHCM7VLGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlJwdWwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlJwdWwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A444C4CEEA;
	Mon, 23 Jun 2025 13:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685036;
	bh=O/M9asMh+dRd9tFt6dz9uqk8ftC7yuHtrGvZ8yhOp+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlJwdWwiZmmMR099Rad0lT1DSuP+QYIPQbppbcWZiuoDDk8WzDwEwt9v+IuYxyFiw
	 Kkt9mf4M2iUNh3At+iNK68mtQyUKAgEDceqVhMXaq8P0x5/1hW31jVVmn/8S4Umtnq
	 NJNUUSpPw+g2u/1bdLOGmOEqx3m1l/TPiPs04sKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/222] vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()
Date: Mon, 23 Jun 2025 15:06:41 +0200
Message-ID: <20250623130614.092763806@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f623b3859e980..0d51353d1e0d1 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1106,8 +1106,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 	case VT_WAITACTIVE:
 	case VT_RELDISP:
 	case VT_DISALLOCATE:
-	case VT_RESIZE:
-	case VT_RESIZEX:
 		return vt_ioctl(tty, cmd, arg);
 
 	/*
-- 
2.39.5



