Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182FE2FA64A;
	Tue, 17 Jun 2025 16:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178738; cv=none; b=Oc2f+LaV+3OIdrYa4tIG7KsrsoLGsBHxqUsAdB/NQWggavgUEmLTlgeaQ9JfCT736cXvoahLDX4XChNjqHWNpaI6mgsdyzDZ/WtYfb2GIPiQhTaKOHKjvgo9sFP6RnykMBzFuzVosdt9c5yLMuyTmNiuHqVDczxVskHI0CipmVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178738; c=relaxed/simple;
	bh=Vx817+w18z8PtfnLyaBODbfH42HEP0f4KyrvJVRWCuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGLsYUzIYJuY+bqHvb2O+sUgPh5EhtSW8vQ9ugcWkl4+VtME3FC0JqU1aHx334H707tYKhhrbb3K/SvB3qtiFyCY+RziVM7u1+kT82FCzVf6I5qgInsW6MTXWoUAtP0QVNJv7zNB4Bj/PNxEbhOWLXLvM0w5aB/VaNof+PGWn3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8Pd6xk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8Pd6xk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBD6C4CEE3;
	Tue, 17 Jun 2025 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178738;
	bh=Vx817+w18z8PtfnLyaBODbfH42HEP0f4KyrvJVRWCuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8Pd6xk4V3s9/7/RBQfC20lqqxE5Y5H2KaTzz1DBNg4jdnWP2lQjQtBl0eu+su8/b
	 TdveBo0ymV5gaIao1u6BY4YQJgMkpnoUHTKAOav65Yni3Y6hdEvDjbK95/Venut8AH
	 EIBTNzFIMLNnxcycJDWFhB8IpXaQYDzkzx5s7X80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 537/780] vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()
Date: Tue, 17 Jun 2025 17:24:05 +0200
Message-ID: <20250617152513.374987154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



