Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029400;
	b=pJS4E6Mdwk3nPJ+F+VBTyxl5FoVR3aSVhOu+1YTvRR3q70ZhSc0HAYaeZXlPPKlAl1Ef
	 BNJLDBcxzcz6pnbBFih88uEz4srAJUJTgnTloIF+oi38mh2QZtu7B+4+kv8Gvd2DX+n9c
	 lCVfGGMuJxVdnsg78/x0MyOeMAB0kbSuFIuMgCADl2voWKPt6T/M5X2ekz799JbVTeVqg
	 fYvreDSHiH/U34PVqaEtvh9KM3gpaawje4v9pWbEeMpfMK4zzY1pYmxQ6yyeJ490znZY9
	 wkPNUZL/UOO9NwEQ7Os0zNKqaAEr8eFk9ntIYOOI9eVdXXzPadpW4Lk5+h2otre5Thg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=562rkKoPNnF7OCuNyBoTSADDIawlNE0wTSlRUOyDGrs=;
	b=gTMG1d/sHyiiGc8xmjmWoWYPSMjLdaBMJQ1TjNcOsipH/FizQGAqny8dAvtlqqqZatF3
	 BxSl5ki5GzeJYFAPHMtf5HLWy7moiWLYkXhZHDAsrpyo8kPT6/j7IwWPS9V3rejIzDfTq
	 QHuhBhejw99tfw/HG6w3kCItB/soDi9B3UAp7kp7i+KCgXc4WnFKwWJSUyMaKgqS+3n7L
	 50Lk0+XFBYK99PgTRIbAyVP6ALgHXjp2V/mBVC/MdzO1IGRzjh6VP0PUEfuvGhsvPItCr
	 zbudXXIWTIC6yjD1O3oMhQiHhhp9+0vcZPrejq/aJ8U9VL6XyeOV7ghxnC8hHR0KTDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDtYyyFx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3493B606A339;
	Wed, 18 Nov 2026 19:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDtYyyFx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C4B1F000C4;
	Wed, 18 Nov 2026 19:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029400;
	bh=562rkKoPNnF7OCuNyBoTSADDIawlNE0wTSlRUOyDGrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDtYyyFx3nO3o9e/zGwvBziextx51s5zdS6OnZTNim4pG70MEFWAgPbZ0HOmLDbPY
	 jokxkVIfzMHkm/GgpByxykJkBHdBdCkAOGeWT9palxu/jPH+gXnCTOdWplgAS35gMY
	 X5+IPyFmj0UNenQEDAa4L1KE/QXLtqme9SlTQ8sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0337/1756] usb: gadget: f_mass_storage: ignore class requests while inactive
Date: Wed, 18 Nov 2026 15:41:04 +0100
Message-ID: <20261118150021.665353895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Tsukuda <catnyaaan@outlook.com>

[ Upstream commit e84caed6e7f58d96ea2e4aaa0b947ab05faa451b ]

SET_CONFIGURATION is handled asynchronously by the mass-storage thread.
A class request can arrive after the composite core selects the function
but before the thread installs common->fsg, or while the function is being
disabled.

fsg_setup() already rejects this state with -EOPNOTSUPP, but checking it
through fsg_is_set() also emits a warning. Check the active function
directly so normal requests during a configuration transition are rejected
without hiding fsg_is_set() warnings from other internal paths.

Fixes: 8876f5e7d3b2 ("USB: gadget: f_mass_storage: added eject callback")
Reported-by: syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d31109047baed8f3b590
Signed-off-by: Keisuke Tsukuda <tkdkei@outlook.jp>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260908203348.95825-3-tkdkei@outlook.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 8b3deed447367..49e4501f57475 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -464,7 +464,12 @@ static int fsg_setup(struct usb_function *f,
 	u16			w_value = le16_to_cpu(ctrl->wValue);
 	u16			w_length = le16_to_cpu(ctrl->wLength);
 
-	if (!fsg_is_set(fsg->common))
+	/*
+	 * fsg_is_set() warns when common->fsg is NULL, but that can happen
+	 * normally while a configuration change installs or removes the active
+	 * function.
+	 */
+	if (!fsg->common->fsg)
 		return -EOPNOTSUPP;
 
 	++fsg->common->ep0_req_tag;	/* Record arrival of a new request */
-- 
2.53.0



