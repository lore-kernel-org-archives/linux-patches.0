Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039585;
	b=rvx/jxblXH+nKU4eZGdlkAOfc5wQruMjeXV380l5cWySsuXmKA0uXDbSxe7dP9QHQ1kT
	 Fe1raTNVuSelsrykLXwElsqCm3UWIJG9gBDF0PLVnJORIVLqCf5Jp4lSAnfkiy7GglGka
	 2mGMtkjwFqAF+AjcXGEwXdYG7XtpuGhJvXB1RLWmyYFncUvUQAwGgQo5EHnPysOalQ0Tu
	 QfVPBH3JrxVjdDN12w8ASeQEYEfRt63n6DsMLTWKKTNRkP/w/ASyRhiMHv2CwKUkEK46q
	 FAP3/WtoDJy+wjGV3MY4Pm/XYKMIyWmH9Ixn2JqC4aqS3FAPITmR8zohRrl5DLno8lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MlI6nRusGqnfytzRTm+1pLyU3yme+o8/Z5+XVH8QBuk=;
	b=prIi0pbDR87udlmYWiTD8VaWBcC1UmPXZtak5iO9xnR/Wv4RPVW0rmfiVI7r/uYnLmno
	 SZSMmMDY7wvJFTa5Ia0C2vmKj/4hJ3ppNQzDD9N3viFcWmZI2kWnPEfLsj6mRKorO8+by
	 b1MwDA7imPXsEJqtetCDPR6MDndm9oTeaLFDzLeUOJDw+nu6aUAMaos/O0kLRduj9ggHd
	 +3Fseui35BCi9HSKS85qzI8F4efF0aip7t5+blYzJFPTUhHuYDhPH5qxoZE8usmoN4Jmf
	 hPKOeANOypl1wIl/vA9WnbWZXsgLrQgHVUyBnUi7AlX77VzxU61Mn/SFGqSNmVGeGyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1SGCJ1F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBD1606A31C;
	Wed, 18 Nov 2026 22:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1SGCJ1F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6268A1F000C4;
	Wed, 18 Nov 2026 22:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039584;
	bh=MlI6nRusGqnfytzRTm+1pLyU3yme+o8/Z5+XVH8QBuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1SGCJ1FekHFstz9+9kV4+ap0o6MS6F/pUfF+D8Op0kNb8t140hHyBbDskpTLVWLC
	 J1NjD7/WRut6093W4N81NTvERFLM3uhE0hnzEPyA5KsPQt7VJdlsUExxiQwbPpTdrX
	 bZN7xaNslb6tTMel3Gb/YZc/EhE5BzD9TQvu5HF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2154/3318] usb: gadget: f_mass_storage: ignore class requests while inactive
Date: Wed, 18 Nov 2026 15:46:16 +0100
Message-ID: <20261118150426.650460218@linuxfoundation.org>
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
index 4a7de2ba91cb2..d0d5f0cf73247 100644
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



