Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4A8C2E0;
	Mon, 23 Jun 2025 21:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714338; cv=none; b=Lhz+0lupAnuHbulcf1J2AdIP7H6jRpNIcqc0tjNVls3YYsuR8DZwT7SA2uahvw+7nmiu0YG17Ze1n633Xhy70jSeet3OmTZVY57A8UkE1kI0Pl8bV56+0WPObrobROXaI5NqKt/u6NMAQ8dI9g7ta5aSaLvjv6qfYsgti37xCcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714338; c=relaxed/simple;
	bh=ZdkJzSekAIwsdMskx72ypowJfLEUQdljTvJItGm2ct0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONxSv9mV2wz3fqukrU1+tcbcTl4wSxv/5/3HAsrGIAP3/T3h72P9d3H9xzUGMYD85mjpIToc27AwDRcNiXzkD5EsTR9lur3fTIHvmcgXF95Zj5nRemuYpXX3lTl48KzkECRCyyp7Xiq3Qn+J415Fmg1UqkCgeFJpYQ0TNkt09DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DS5w8Z2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DS5w8Z2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0619FC4CEEA;
	Mon, 23 Jun 2025 21:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714338;
	bh=ZdkJzSekAIwsdMskx72ypowJfLEUQdljTvJItGm2ct0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DS5w8Z2De7fP+RGcoIQcEUTA0nk0INkYSIjaP/d1lLjv8MHXvYwsgc912mcmnKOnO
	 WVBHnxMpeg1cSjl0oA2tl0mT1jI2+pPq2+mpsJ90GHdPp9Nlj1xFfUKMQb+SRSCDWW
	 a/iIIYQr+uYe3jZ7HHlA+3O3V03qy9UyY413uVUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <npitre@baylibre.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/508] vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()
Date: Mon, 23 Jun 2025 15:03:31 +0200
Message-ID: <20250623130649.359077561@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c685b5014044..5b21b60547da1 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -1105,8 +1105,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 	case VT_WAITACTIVE:
 	case VT_RELDISP:
 	case VT_DISALLOCATE:
-	case VT_RESIZE:
-	case VT_RESIZEX:
 		return vt_ioctl(tty, cmd, arg);
 
 	/*
-- 
2.39.5



