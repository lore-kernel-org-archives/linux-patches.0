Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025122;
	b=D5nBoM3ibZkO30Nj7gQeiROSn+mzJr8U5WrCMJVg/y0EmwxrYkdwTQWewtAGSdNSIgJk
	 UtEqp8Oc07n/rZ1SEI6B2KX4g75Zo1btInizBBDxIdUKfDM/ekRtX851GOZshCFCbJ3s8
	 YhVOC8CBNeWaxiQ512U7fp86lwy7sYurhPPh0YRMp13MaFZ4IdVIc40bewIouEPEkhz6d
	 Xk+81ENmkU5QBl6VPDLcv9XTe58JPl8o2w6Yb7JD1YOu60lZPkIR5SCzE0fpB95t6ccY9
	 keRH2JYqRfIBWuUKiiXDTYc0hq2CdwPIYCC5RhpHyWWfrkfckth5RmHxKl5HaahX9vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lrnk8AKN+i/XLLGLaoGrOHDJE7wV3GwloMkmbsBsBFU=;
	b=uf8G86RDDgviptULzn7mQX1ZETZu+oKEDIXttryCOrb5bdSpfSWVEjcxy5Ukq4Fl7qyn
	 I6U3Fc2mkbPX5DaWOMRPcM4SigvZmI0JscRjl4MrG2zqid6YtarALWCXr+WnLmEQ+YTnv
	 mN++ss5w+tqH+dRKIwgCWDBWRckKX93/vFcjYOSYQ3tkcNW2Mfow3KhLG3siLk4vamzla
	 GyamgkCfsTj9eQ2e3EgRRLKEuP8mRCVGBhZ+jMYR8+Wbsoae1jmvlhhSrR8WxygyjKKOP
	 AQ8Of6lyGONIIh0GxvY2T/0kx2EZhDhpBwEv066Zp0sQJ/OXmCszXmdh3x8WkC2yERA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KIq6Zza/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C1D606A336;
	Wed, 18 Nov 2026 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KIq6Zza/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267D31F000C4;
	Wed, 18 Nov 2026 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025121;
	bh=Lrnk8AKN+i/XLLGLaoGrOHDJE7wV3GwloMkmbsBsBFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIq6Zza/WnFGsf1leK4U9WMA6ZYPX2ByXOtZdLNIkB7ZfMGitB5fTCkagjf3aS1Ng
	 ojCDHyAz9RlITr96Fgyh4Pil8dr+ft0wIkuFVU4nROTHYYDjCpTLym9vLo4saTnWz4
	 8g1vM3sbivZKZzy6ojHf2GwtZSxCGZ5uyDsppaXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0966/2151] ALSA: ump: Avoid dereference with max_src_size=0
Date: Wed, 18 Nov 2026 15:45:01 +0100
Message-ID: <20261118150157.699182548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit b61a2369085fd995c8ad44245d3fbd45b1216f71 ]

safe_copy_string() refers the source pointer for a NUL terminator
before verifying the source size.  When max_src_size=0, it may
dereference wrongly.  Fix the verification order.

Only hypothetical hardening, and we see no actual issue in the current
code, as they are all valid sources.

Fixes: e3f035edadcc ("ALSA: ump: Copy FB name string more safely")
Link: https://patch.msgid.link/20261002081823.680131-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 0e6a7d438d75d..2534c1b143ffd 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -66,7 +66,7 @@ static void safe_copy_string(void *dst, size_t max_dst_size,
 
 	if (!max_dst_size--)
 		return;
-	for (s = src; max_dst_size && *s && max_src_size--; s++) {
+	for (s = src; max_dst_size && max_src_size-- && *s; s++) {
 		if (!isascii(*s) || !isprint(*s))
 			continue;
 		*d++ = *s;
-- 
2.53.0



