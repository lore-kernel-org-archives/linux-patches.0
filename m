Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048113;
	b=EGTn2LugukMm7A95BdHASPQ34ZGcVsods753+zr1ls5qoUIJsKlZs3apURxjpW9ZNKf0
	 5Q5E2QyPNPDrj+7BcymZozUmLrfJzwPEWa8ZM71/wIyE4837qH32GCvULbRccqWfFuVK9
	 DK+sFqVGl152b/hiSmdj6/I57bXu06t2ptDdAMZh/sXVxQfRs4IDKYWrklXBJgnNGP+yB
	 0kjlmMULcmueH8IKvjo67668jZcKsfgvXXF5njxWlIrETsPXDq/lITeMMqtG+lzQxcJCf
	 Y1R8v3Yy6yOo3Swx0CbE+83GB9CfTniwnAyPyntDZ6BGlra1lURvZ2XBOrbGUv1iJaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iiEhZHahN/4/POR0ZvdKq1l5JozlzeTjq9sZsdq2tzM=;
	b=VtAKdvq7lK1+hkxfG0cMvFVFd4rn7O4qw8Y6gnlDnXsifOqxRxM89VzlqaicBH+M/3MJ
	 ZqN3U00lK+UVtl/ClsLDJ+MDI8Jhg+XIdk6jeFfSI4lVfrYFZ/JGtNXbriq9lpOZAyftM
	 4v+sRlR//lqtsF7ci6qL0twdd0CX2EDnwlIH5F4huLQcAqt8YCazytBO5me3QIDGxOVcT
	 0u/sP9f8CWH1Lu/HT6Q0d6eUNF82bFaCfttCYUgGUG6X2uycjV5opaYt7gW9NcpQataRy
	 NaqD5LCjn6ZRK0ONZfq5xFkLd7ei6ZlJWFfZKK/lcjdt6/hyLZccJXnxRpCoWTCPpow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8KFkIBY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4001606A31C;
	Thu, 19 Nov 2026 00:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8KFkIBY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496441F000C4;
	Thu, 19 Nov 2026 00:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048112;
	bh=iiEhZHahN/4/POR0ZvdKq1l5JozlzeTjq9sZsdq2tzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8KFkIBY7vlTaWNe2h7Ukt9yzooQFRNYV77yVl0Q/w5JlxRgI66u0hwgPCc5WeO/C
	 szWfLYBCxnwxKBVazHVmmlcwwJP4iE9R+N7m1g+k8ORQF5LMtWYLOwteO2r+8kQ2lW
	 NqOm+dseyF+Hw7IPZA+36fMgXNBuJSSG8DmnFhpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1879/2857] usb: gadget: f_mass_storage: ignore class requests while inactive
Date: Wed, 18 Nov 2026 15:48:33 +0100
Message-ID: <20261118150308.886259529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5618ca904f5d0..d4f43eee7b889 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -463,7 +463,12 @@ static int fsg_setup(struct usb_function *f,
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



