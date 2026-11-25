Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618514;
	b=GSx24HXpOYABjk9uuZv/8h5OIhGEI5jz0nFpXoi3/BjqkIP67bFoi8lcYLI/BTTe6I8Q
	 tJNUTwbvnpevzN+GABU6LuqEYhNy2Q9hmU9BV2vz2zdVlmUT3pAMF4Jdo9ubrW0ua7CcD
	 nkLiFsZv+VoEphuwmDwArz8woE+TcbpPRQeES1u+C0ZFSyVZvSh5O+h4aYzVBe9kwBPoy
	 M/xudSh4hD9wAdKZzcfL9hyZlBoc6+Qd0jrKf2By86J1Xl1QXPPjfWTQIN6bNx8C/SVXW
	 Z97QgJaQhtA7pF91m0pNohNW/EQwdW2hSIHhJXywxHQphxwxSK3h6mcfDH8gKR/IISA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EVsnu0haqg7crwCG46sfAJxdsKPeuNmjomOLKMAwHLs=;
	b=dn7E6U41MCQw4RCGDsnPW8Q50JrXkkWCPIVzxz+KgeRvElOzBn7qNjzIYlLMHhw/ZQVQ
	 iFcPh+glUnbmfxWjzmA2FHvw6ZC+5VLuF95O5nev5XPpWL+m/MdjaQGzWvPK8FL7Q3aHn
	 quO3pKJqcG0wIrSRBiuGnxLeVq4PSGVXzLisRfLzmBForlmqTcHUlyFoSRI9RK91Wctq2
	 pCk75XL3DDf0YU4KJSkCWe3gYCKNLhC54Y+SETSTsWJnOvxcUlokpNv5bu7nQmf3ht2gy
	 rpByrN6JT976YBxGsADmjXXlfxwZisdkhxdsclGZfJUJYUc3+thr0R11CDduPOwAwlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=La0TV5gR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F394A606A330;
	Wed, 25 Nov 2026 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=La0TV5gR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52B71F000CF;
	Wed, 25 Nov 2026 14:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618513;
	bh=EVsnu0haqg7crwCG46sfAJxdsKPeuNmjomOLKMAwHLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=La0TV5gRLtyotFwSuhwftDAbAvTc1q+XgH/lckkhRaNoynODTkxc1jgcIrioJDWpJ
	 aOa17mFEDQQHHaCAHEisFeCperb5+IcerKXAEu0ZR306rh81BxiB45S2Icqqrkk/NE
	 fL9NvQzkheA6Upks+Aaqu+/qrpQuS8oB5KLo5io8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal.kopec@3mdeb.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0302/1005] ALSA: hda/core: Stop capability walk on empty capability header
Date: Wed, 25 Nov 2026 15:27:20 +0100
Message-ID: <20261125143828.810380838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Kopeć <michal.kopec@3mdeb.com>

[ Upstream commit f65c917397c77daeb7e6d0893ebe89107ddd5692 ]

snd_hdac_bus_parse_capabilities() walks the controller's linked
capability list starting at LLCH. On some platforms one of the entries
reads back as all zeros. Such a header does not describe a capability,
but the walk still treats it as one: it falls into the default case and
reports an error, printing the raw register value instead of the
capability ID:

  snd_hda_intel 0000:00:1f.3: Unknown capability 0

The walk then stops anyway, because the next pointer of a zero header
is 0, so the message is only noise.

Treat an all-zero header as the end of the list, the same way a failed
read (-1) is already handled, and log it at debug level only. Also
print the capability ID in hex for a genuinely unknown capability,
instead of the full header value.

Fixes: 0b00a5615dc4 ("ALSA: hdac_ext: add hdac extended controller")
Signed-off-by: Michał Kopeć <michal.kopec@3mdeb.com>
Link: https://patch.msgid.link/20261102114939.2182131-1-michal.kopec@3mdeb.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/core/controller.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/hda/core/controller.c b/sound/hda/core/controller.c
index d1d85511a9dba..b37ae60621581 100644
--- a/sound/hda/core/controller.c
+++ b/sound/hda/core/controller.c
@@ -426,6 +426,13 @@ int snd_hdac_bus_parse_capabilities(struct hdac_bus *bus)
 			break;
 		}
 
+		/* An all-zero header means no capability is present here */
+		if (!cur_cap) {
+			dev_dbg(bus->dev, "Empty capability header at offset 0x%x\n",
+				offset);
+			break;
+		}
+
 		switch ((cur_cap & AZX_CAP_HDR_ID_MASK) >> AZX_CAP_HDR_ID_OFF) {
 		case AZX_ML_CAP_ID:
 			dev_dbg(bus->dev, "Found ML capability\n");
@@ -456,7 +463,8 @@ int snd_hdac_bus_parse_capabilities(struct hdac_bus *bus)
 			break;
 
 		default:
-			dev_err(bus->dev, "Unknown capability %d\n", cur_cap);
+			dev_err(bus->dev, "Unknown capability ID 0x%x\n",
+				(cur_cap & AZX_CAP_HDR_ID_MASK) >> AZX_CAP_HDR_ID_OFF);
 			cur_cap = 0;
 			break;
 		}
-- 
2.53.0



