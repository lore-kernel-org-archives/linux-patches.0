Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590657;
	b=RqWcIwIh/FlvyW1Z0LPBlmrshudXP89pZMpfmf3VFKpkMSB7uG/kHYGLIBrD/sI3QdUj
	 CVMXfG7CkcFKvvvY8GYC+l/4mDH1S6JVyGB4ZRAr6X1FKMCMZwymijhVt7ILtB8eIwi1C
	 OqY1lVWO9wGOVpqgzu45Jao1c6E3GDYUhDPC0QteYCfriWTjCWmvnvpNFDI0FQPkT/46k
	 Xl4cTMKECsGT5q6gjc2TN637Tla9Jbl9LxNiozNiMMNcap8VHFrggtbufO2H3FwkvUZ3c
	 LNJ37ZSz80pxHjFHDMAJfjXZNF9emjZOtklIerMUBobZiVMjT8HlS9TALkhfWM+78mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YHv1g3TxFB3aKAFqLHF38Hr7HvRboeT/3A87oC55r1U=;
	b=TwmDpsrKm5gE2ofqSCrT9Nnn/Q9TSXlsBNgC3TDi4QxImJNU12Uo88uGkIveT3kpvgYB
	 qRhRlXOVbqj5ak63/yTX49hw5ALI9lvPc7AIZIbjW5CvD5SCFovMn9ozltTJB9VyGqw4D
	 mIQbHX5SlaKc3uOqSc134BXeWczWhGPPt8T0WKXwwIwINVcdxZZpSO3SsUD7MASIMVCwC
	 YJ/C03pWTW9cNk7RjgqG/b8th0snOql8wfw16QJKYu4LqqerxeNZbFwCtIX0tmqP3a8t3
	 XiAlAYj7d/pcYWgXMVNcFgK7Nmp9eD7oy8mTnZRzfU4aKnr6W+ZNGcKjMx+lmjs/aSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qg4TbUVb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2FD606B215;
	Fri, 13 Nov 2026 17:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qg4TbUVb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2E01F000C5;
	Fri, 13 Nov 2026 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590656;
	bh=YHv1g3TxFB3aKAFqLHF38Hr7HvRboeT/3A87oC55r1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qg4TbUVbPT7kmfOABQ3iAEKtU1X9siX1aFwSgL8vOwJnE7aNitK7RFp2MjqyP8dGd
	 ir/eNl/p3K64P4RVkM3aZ435NK5zzr4QyPOTW/3wUyYg8lusX2JLHWTn70Q6w6e4cf
	 WUU1v7fI7W9DtuPEKnfA8e2BMw1C0lOuiLj6uJUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	patches@opensource.cirrus.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 575/686] ALSA: hda: cs35l41: Use auto-cleanup for put_device()
Date: Fri, 13 Nov 2026 10:51:48 -0500
Message-ID: <20261113153841.145819822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c437a83cc69645edab8e0bfc450a3b706abe759e ]

A temporary refcount management of a struct device can be done
gracefully with __clean(put_device) for avoiding potential leaks.

No functional change but just a code cleanup.

Cc: patches@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260803140100.919071-3-tiwai@suse.de
Stable-dep-of: 8d70e364e866 ("ALSA: hda: cs35l41: Fix ACPI device reference leak on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l41_hda.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l41_hda.c b/sound/hda/codecs/side-codecs/cs35l41_hda.c
index de2fd6471f059..a7fc4ba35e3a1 100644
--- a/sound/hda/codecs/side-codecs/cs35l41_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda.c
@@ -1929,7 +1929,6 @@ int cs35l41_hda_parse_acpi(struct cs35l41_hda *cs35l41, struct device *physdev,
 static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, int id)
 {
 	struct acpi_device *adev;
-	struct device *physdev;
 	struct spi_device *spi;
 	const char *sub;
 	int ret;
@@ -1941,7 +1940,8 @@ static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, i
 	}
 
 	cs35l41->dacpi = adev;
-	physdev = get_device(acpi_get_first_physical_node(adev));
+	struct device *physdev __free(put_device) =
+		get_device(acpi_get_first_physical_node(adev));
 	if (!physdev) {
 		acpi_dev_put(adev);
 		return -ENODEV;
@@ -1959,13 +1959,9 @@ static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, i
 	}
 
 	ret = cs35l41_hda_parse_acpi(cs35l41, physdev, id);
-	if (ret) {
-		put_device(physdev);
+	if (ret)
 		return ret;
-	}
 out:
-	put_device(physdev);
-
 	cs35l41->bypass_fw = false;
 	if (cs35l41->control_bus == SPI) {
 		spi = to_spi_device(cs35l41->dev);
-- 
2.53.0



