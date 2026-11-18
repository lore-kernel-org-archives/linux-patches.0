Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023426;
	b=KsyBv9F0WBVeGyTw7iGo4B3e559fDUyVNXev92wgnFwucI5InWOAPzClj7qj17M0vbpR
	 ErCZE47UnUPvrL2GzOaZ3PgoTDLxvg/FnrwQuFNLf0CVdyCdGHLcGkevo8LMpjcBNmaId
	 Xg+xjfx4x3Ce/YxvaZbH1piuqHqA8UU7lFMJxbDUKFY3YLtnoQsst5RbXZNreVLR1mhF6
	 1Q7axn9pmGtcqx0yPIMp/KE69YNxpajvYHrdSVnPigR5owOLTXdnq/pDG/eVsmbiJaNbP
	 4IcTa/dMJIuiQLXYvJgf+n36BwVcZRJ6hGav4zY9C6Mky9WRBvuB+e8u1Ce7N0xLPqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HZO0V7VQC54wZX0TAzH9YF3xPy3Yvc74s2Xxv1zQZek=;
	b=zcIlW+un/WsY8mWUDGxIaLG1KJ0z2Jsi6krM/+LHvKgTRlKUPWwkzD0h3rxTAurXPqEk
	 7ZNsu1QVUSUg9r3iJuN5eI7bsbB6lcf0jUc1mzQcWpr3x+aq7bod2HJ1YqAvcsJayoi0y
	 vaRnshzUNvhDYNdwvqF4tPO2/N1jQVAH2dYNz5hDd9syisQoyEusAfPZkjd+hN0Bu2fA6
	 2vsOH0Fhj9cCnaq8YkeZvkUCEo89g0aLc5JH5R5+HrnSrc8IZCHw2qzaTOSuE6OpV4QCc
	 TLgVN50qrvzzSXL7UPteiktLEtaH0ZiOZ6qL49n0K/TtQyLonjqXuxHZt/3Eo/Kq+HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBNxeCRp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186D1606A325;
	Wed, 18 Nov 2026 17:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBNxeCRp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C271F000C5;
	Wed, 18 Nov 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023425;
	bh=HZO0V7VQC54wZX0TAzH9YF3xPy3Yvc74s2Xxv1zQZek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBNxeCRpyKYr4oOSxERci3mv8HcfUE4Yhgyh6pty4yx+Tt/80tQDSKZM9L1Da57Jg
	 U2FskpKFTB9ufPP3WULcG+SSwIEVZFmqtOaTw/h3buEJ6GcIQUhVEUYfQqeVoktZWh
	 mC9WBg9g/i38gxUQ5RNZ//Mg1hP1UWV0B/Bncnjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0365/2151] usb: gadget: f_mass_storage: ignore class requests while inactive
Date: Wed, 18 Nov 2026 15:35:00 +0100
Message-ID: <20261118150135.385296605@linuxfoundation.org>
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
index 6970d0fa806b0..584e7ba31603b 100644
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



