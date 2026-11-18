Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033811;
	b=RRvdU3ir/R/JbFRRBQwKM2CMot97x4o3dvSgrdS0t7JSQF9b6tL36Oj/Qqys//CUh0vt
	 IqLn/UzqvwszwZ7ncNBzyBDf+F7smXvmJ+6lgTolglzKLbTvR+51vELi42xT6ZrJuxrzq
	 LmHTuQrqQczo5Q+tkQ8x5sFttbelbkFc2BlSZncEuZXmwf17gEMuHiVyMgKBErY2M90ql
	 Q0pHc9M0nlfcTK9LutczcWNeylkoQIkmO/LHJ+fQ0M1C9Jpi7lamNn9ITqRDLyIdrBBSS
	 92Tps9ZLVgQlz2gRIFsqFICfSESM++L47zzNSkZU0h1ftEYYjhKDap0Cp/OcelSTj3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=v7+qJ2CJC/xtthtfd98h8lg5iQnPG3fc1GKV1mQxR6M=;
	b=MGTVIGZXA2E0xN7PDT22ghza3o6Hec0LYPHVaA47P2caAvTlbWQfJ/qlgfEBASHLLPqo
	 EG9d7J30V9S68BhChDiDqqtvK3UxxnHsCA1h7A0YGqwMM5qAr23C4RX0PzvnILusWKS/C
	 7A86MZfezfMq+gH/Ef2U242xQJWkCwo5f+B10goGeeujFIqGYo1rspvWL2gnSlFyA0lUg
	 A7iD3nU34qb0Mo/MB4laT6npWfKBJ9ripCu7P2dJLKwvL2vDxrWiGx6IMGW4tACcIR7rs
	 792gd++ExoKaYHC3lzhPvfR3Wi/L1VdUV2IGmib8YSQqBSY6/fW7QwXBA2MwRMWP+gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJTJCN3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439FD606A320;
	Wed, 18 Nov 2026 20:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJTJCN3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989351F000C4;
	Wed, 18 Nov 2026 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033811;
	bh=v7+qJ2CJC/xtthtfd98h8lg5iQnPG3fc1GKV1mQxR6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJTJCN3DOGpEN4LPklk+mw1lGJCfiHKBd2EaaRlINVSe7xNS14i8L2Lfr2M0If0yl
	 gtGGvujdZWWksFkqR5jZMmhaldG+F66aO+uvO7Hy/gO1Qj/ZXZocgTojIoQjSBVJ2/
	 l+nH3iZD8ycs2u4xn5CDZojNvERiCrvvR4Zl4TtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0146/3318] platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3
Date: Wed, 18 Nov 2026 15:12:48 +0100
Message-ID: <20261118150318.869744630@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>

[ Upstream commit 6303451189a6d8f304221065c44ccd597e0acbe5 ]

The dedicated "ProArt" key on the ASUS ProArt PX13 (HN7306) emits ASUS
WMI event code 0x8b. This code is absent from the asus-nb-wmi sparse
keymap, so pressing the key only produces a "Unknown key code 0x8b"
message and does nothing in userspace.

On this model the key is exposed solely through the WMI interface and has
no HID scancode, so it can only be handled inside asus-nb-wmi. Map 0x8b
to KEY_PROG3 so the key emits a bindable event, consistent with the
existing KEY_PROG3 mapping used for the ASUS programmable/Armoury key.

Signed-off-by: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260719090843.66777-1-nizar.m.kabbani@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index cba515ce3444d..2fd4ff8ff0f52 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -565,6 +565,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x86, { KEY_PROG1 } }, /* MyASUS Key */
 	{ KE_KEY, 0x88, { KEY_RFKILL  } }, /* Radio Toggle Key */
 	{ KE_KEY, 0x8A, { KEY_PROG1 } }, /* Color enhancement mode */
+	{ KE_KEY, 0x8B, { KEY_PROG3 } }, /* ProArt key (PX13/HN7306) */
 	{ KE_KEY, 0x8C, { KEY_SWITCHVIDEOMODE } }, /* SDSP DVI only */
 	{ KE_KEY, 0x8D, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + DVI */
 	{ KE_KEY, 0x8E, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + DVI */
-- 
2.53.0



