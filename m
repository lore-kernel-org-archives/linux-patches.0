Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1FE41760;
	Wed, 20 May 2026 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295401; cv=none; b=IyU4THjIZGc3uLfl7lqOpuDD4nbzs+9R7CSkC2ndZ+koahk0rZ4ExoiqW7s8wF3qQBs6uIDNaXGTOVykEWDsu97l70lw1ewvODuvz5iXRYm6/F4gyXwycNrwliBZvV50jCl6/cbMrNWhld4zmH6KOcPjnFYY5/swCW6ejhfTwtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295401; c=relaxed/simple;
	bh=sO17c7hwLRcaDrYO6nMeb5aGjBjBEXNb5vruJqXNr3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQR3FtXZn5Z4mbjuNwpanjcVL6aWDOBMwKP3IptM/uM3zodqLZgAfC3ku4iY/oZYphRrXA9kLJsAC2nWa3N8yVHbfWQ+TP6kKfXYF0yYEfDMgDdAXI8oJ58VGWHKQeEmn4ITfD89rq5yPwZF1aAC3JMwKONIoxH2pxHxAI13Los=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcg1P2LO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcg1P2LO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA541F000E9;
	Wed, 20 May 2026 16:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295400;
	bh=wMI95erzmEOzwdkfyz/87GzPcOGOHashwYu1a5KHVBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qcg1P2LOr345uKrGBHWj7S30lYoe80o1euQOSVZqcgPsMpXotH7UDrQBrTH7JWIa4
	 5ugiIuJqp7lW2eqVeB8fRH8lkrSgi91bIpUuvCWRhmattu9NpwaIz9nOpqRFoJSAVj
	 Ju6BYHYaG/W6eYVfGbs7AmaiQ45BBS6+3NoK8y88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0405/1146] gpu: nova-core: fix missing colon in SEC2 boot debug message
Date: Wed, 20 May 2026 18:10:55 +0200
Message-ID: <20260520162157.365079679@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit a7a080bb4236ebe577b6776d940d1717912ff6dd ]

The SEC2 mailbox debug output formats MBOX1 without a colon separator,
producing "MBOX10xdead" instead of "MBOX1: 0xdead". The GSP debug
message a few lines above uses the correct format.

Fixes: 5949d419c193 ("gpu: nova-core: gsp: Boot GSP")
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260331103744.605683-1-devnexen@gmail.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/gsp/boot.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/nova-core/gsp/boot.rs b/drivers/gpu/nova-core/gsp/boot.rs
index a13255c464bc3..99e7a0b7e3107 100644
--- a/drivers/gpu/nova-core/gsp/boot.rs
+++ b/drivers/gpu/nova-core/gsp/boot.rs
@@ -185,7 +185,7 @@ impl super::Gsp {
             Some(wpr_handle as u32),
             Some((wpr_handle >> 32) as u32),
         )?;
-        dev_dbg!(pdev, "SEC2 MBOX0: {:#x}, MBOX1{:#x}\n", mbox0, mbox1);
+        dev_dbg!(pdev, "SEC2 MBOX0: {:#x}, MBOX1: {:#x}\n", mbox0, mbox1);
 
         if mbox0 != 0 {
             dev_err!(pdev, "Booter-load failed with error {:#x}\n", mbox0);
-- 
2.53.0



