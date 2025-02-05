Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8350F151988;
	Wed,  5 Feb 2025 14:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766217; cv=none; b=tuANso+/HhAqX9kGVnWzspdU6o1jtoChfZw6QAVYDW2896KfD2u8rE4DjUPvStIqXtMr1LU/ae0vr3u0FvgaRFRyrV7qH6cTD6K5UOIP1dXHxxhgxShgr7W/QtSc3tKIHVfwCuSYhQFMLjpkJA16yr3dqJAoJVJTYmd+iwOjhRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766217; c=relaxed/simple;
	bh=WXWJjc0tQ2hw4QsvZaHD2uPbPEeTdGRvEy0TK65MfAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZzHtAkczj7h68eZlM2iqmAAF0ZmOMG0WEI2p/ef7kckJ+wEmf5kpABIYqubmkTzJVTrH3tslImnubhTcfsU8mLvlrzQzenN26FxvD28aAeIJZk9GOOYclLFGZpWJgI7e9s4nQ3rgE8qmkpvUpeYQW6H+4MOTAGhftQPz5dtPGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXqNayId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXqNayId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27E9C4CEDD;
	Wed,  5 Feb 2025 14:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766217;
	bh=WXWJjc0tQ2hw4QsvZaHD2uPbPEeTdGRvEy0TK65MfAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXqNayIdxKQdlgY9oKGOsHFws4rOycNOR/LSjLrYQm/eHmDUNjmVTcKe4+XcljWOS
	 xO/QS6a/QspY+0B1vkWqRDH2lU1vikktgrLZxM33gPV/ypsV7mQ3aJ3J5YOhHOiL9S
	 sAQ5m8LEYEqvYKHhX6daXBnMyFKA2OiQjiItSan4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 253/623] ASoC: wcd937x: Use *-y for Makefile
Date: Wed,  5 Feb 2025 14:39:55 +0100
Message-ID: <20250205134505.910622713@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 582057d2233a5a38e1aec3f4a6d66b362b42076c ]

We should use *-y instead of *-objs in Makefile for the module
objects.  *-objs is used rather for host programs.

Fixes: 313e978df7fc ("ASoC: codecs: wcd937x: add audio routing and Kconfig")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241203141823.22393-6-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 5a83ee9639661..d7ad795603c17 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -334,8 +334,8 @@ snd-soc-wcd-classh-y := wcd-clsh-v2.o
 snd-soc-wcd-mbhc-y := wcd-mbhc-v2.o
 snd-soc-wcd9335-y := wcd9335.o
 snd-soc-wcd934x-y := wcd934x.o
-snd-soc-wcd937x-objs := wcd937x.o
-snd-soc-wcd937x-sdw-objs := wcd937x-sdw.o
+snd-soc-wcd937x-y := wcd937x.o
+snd-soc-wcd937x-sdw-y := wcd937x-sdw.o
 snd-soc-wcd938x-y := wcd938x.o
 snd-soc-wcd938x-sdw-y := wcd938x-sdw.o
 snd-soc-wcd939x-y := wcd939x.o
-- 
2.39.5



