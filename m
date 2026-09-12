Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E696E382292;
	Sat, 12 Sep 2026 19:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242298; cv=none; b=eBCu404Zohrh0MTg96rvrJIzL0CLWg7cIM86Ka1xx4fIn8Gb/Jm+LRYF35AdAv5F9/6CpvmOK53rrCOc6CNRD+BTX+wMEM7Rk0goXxiCCpg0X21eovV+1J82Qe+K00XN//zVKfKOAio0htpEBr42BhAlaxXMcX/seZbow/92Wfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242298; c=relaxed/simple;
	bh=lKH6OrEb10/G0fZihRR6Z5NXkTDkrx7SH8RBqpPF490=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EA4f6jKxE4byjiarb4Rr/Bb9H64w4jdgbCAQLiSg94hDR3fJU+SFqhWBN5JGpIaFZ7l0hQrYkJghp4FQcGwJ7qsnlt+YZmBJx00A2VgrlS+g0suldRLY4j6NHKwyfAJNoPrMwuaq5a5CPPNZtXzYaMIcup1/8dRnk5sSPV6MQas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTd4k+IA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTd4k+IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAC91F000FF;
	Sat, 12 Sep 2026 19:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242296;
	bh=E6i9UIB0QS7ZybDbSdlbglz9Hhq/0x93ygr4UKYO4Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTd4k+IApHcOFk88WaJ1ZHkHpZjM19fZnPMzmInaeeHQudUkKP1XYdw0gerK2nCZr
	 LWl5qlx16BBG6WO7HXQYZTnCQq+54CabJiiyjtNByf7nb+GsG7NDW5wEhkq/w8Ol6i
	 n8GpdvrmfuLFj9xsKJAT1/qeF8iNjayjEBZaKVp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/798] media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define
Date: Sat, 12 Sep 2026 08:59:43 +0200
Message-ID: <20260912065525.297190922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 6e5deb2923b0d1b73c77a1a77c30b0da43d9e022 ]

Since commit af86ce79f020 ("[media] remove the old RC_MAP_HAUPPAUGE_NEW
RC map"), the RC_MAP_HAUPPAUGE_NEW define is no longer used.

Fixes: af86ce79f020 ("[media] remove the old RC_MAP_HAUPPAUGE_NEW RC map")
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/rc-map.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 3e01cb92feb5a..ac79f2cae1d14 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -259,7 +259,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_GENIUS_TVGO_A11MCE        "rc-genius-tvgo-a11mce"
 #define RC_MAP_GOTVIEW7135               "rc-gotview7135"
 #define RC_MAP_HAUPPAUGE                 "rc-hauppauge"
-#define RC_MAP_HAUPPAUGE_NEW             "rc-hauppauge"
 #define RC_MAP_HISI_POPLAR               "rc-hisi-poplar"
 #define RC_MAP_HISI_TV_DEMO              "rc-hisi-tv-demo"
 #define RC_MAP_IMON_MCE                  "rc-imon-mce"
-- 
2.53.0



