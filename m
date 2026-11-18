Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034557;
	b=YMZ+svjwkr8v1kL169G+QtaO6rd7FspPiUCRD0KXNxzD8mqWXZM08seBG9ta0XwxrBIg
	 VUJeNBVQxfqi/CuJoEpTy2TqRccQlcZw7QvZpqy58CH9mNMEN5XzPaZra7JvUl2779PEf
	 AXWrG+CjPittLOTP5S1NUNgTLeQfYO4wW2590ax43LsGKcg3oQ6W33hNTppbNwhc82k30
	 gW4Skm8VNW5ZF0wQpafcYdULawz585/ArEW1vw9GvGmCCxNv4LY6Lt8sESCBU38seQdeV
	 MJ55eJqMM8OtF8Eeuoy4UQy5/n8kFsWW5OsCvMrJX+DNqDXc2ntkZgzhVVxroqCUOFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o4IOj+zh+w8aJxGgsY22GdNQ7VCb56rOwo7lJNZWB8E=;
	b=adam6TJDSIMCWdaqls3fqICCCxZk6Gsds2+N5Ekd5wOcYhYdLlw4fRAL0NYscrDeK2M9
	 R9dKeouGqsgr7oXtw35gCYVLT9gbPLI9r5fuHlr5RG+1xrEKXm/oiNmdNSgJLkfxw72mj
	 Fc2LMONVzn4TAzgiWt9gV44ZRrbgKHjHpuvd9V2NkD4JdriWYpAooAwoNg/zpx8aUnNJG
	 c1iYJ7sR8iYm5y73J0iNRfuZFLyeDLlhb2LM6eJlMRjnKheoJzC4VAFTKfCBT+oFKp659
	 FSYbXqMuGDSCMz4ezIdA5kZgJ5IuNLGNtkBbuKG1DVnXYNgiBch3IvjGXzJ5gwgBHiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z1tv5/s6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BD1606A31C;
	Wed, 18 Nov 2026 20:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1tv5/s6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B6B1F000C4;
	Wed, 18 Nov 2026 20:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034556;
	bh=o4IOj+zh+w8aJxGgsY22GdNQ7VCb56rOwo7lJNZWB8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1tv5/s6UyXU2kbND0VsXLCQd18Tu4s0Sv/I77gKzjVgs8tHWb/gU1SeJntQfS5oL
	 uwCdNKAHTC6kM/ku57rpftDXLNtofk61VpVnX0zv0fuXwxCnc8xwK+PI7ilr8rP5M5
	 ffW719aT264+t33TuBQJL6q5OiueqKU9NbB6FbC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0411/3318] ALSA: hda/ext: preserve PPLCCTL bits when clearing reset
Date: Wed, 18 Nov 2026 15:17:13 +0100
Message-ID: <20261118150328.816748668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 36aa66de481d29edd63cbad9b5c4dc18c340fdf6 ]

snd_hdac_ext_stream_reset() polls PPLCCTL for STRST by masking the
register value with AZX_PPLCCTL_STRST:

	val = readl(...) & AZX_PPLCCTL_STRST;

The same masked value is then used when clearing STRST. Since val
contains no bits other than STRST, clearing STRST from it always
produces zero. The subsequent writel() therefore writes zero to the
entire PPLCCTL register instead of clearing only the reset bit.

PPLCCTL contains other stream control fields, including the stream tag
in AZX_PPLCCTL_STRM_MASK. Those fields must not be modified as a side
effect of clearing stream reset.

Use snd_hdac_updatel() to clear STRST, matching the existing set-reset
path and preserving all unrelated PPLCCTL bits.

Fixes: df203a4e46f4 ("ALSA: hdac_ext: add extended stream capabilities")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/43BB7930B0F07C09+20260813065524.1955696-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/ext/hdac_ext_stream.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/hda/ext/hdac_ext_stream.c b/sound/hda/ext/hdac_ext_stream.c
index 11b7119cc47e6..75b56fdfb216a 100644
--- a/sound/hda/ext/hdac_ext_stream.c
+++ b/sound/hda/ext/hdac_ext_stream.c
@@ -169,8 +169,8 @@ void snd_hdac_ext_stream_reset(struct hdac_ext_stream *hext_stream)
 			break;
 		udelay(3);
 	} while (--timeout);
-	val &= ~AZX_PPLCCTL_STRST;
-	writel(val, hext_stream->pplc_addr + AZX_REG_PPLCCTL);
+	snd_hdac_updatel(hext_stream->pplc_addr, AZX_REG_PPLCCTL,
+			 AZX_PPLCCTL_STRST, 0);
 	udelay(3);
 
 	timeout = 50;
-- 
2.53.0



