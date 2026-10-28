Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210948;
	b=QwyB6K5/GSVAhYIbL2xOQ72ubC5214H2pfVl2auJ5suh9Pe400Ewh3IA1mePeU/3f9Z8
	 qzVwAPB6pEXmi/jcX1FO6I7yAYatEUsZxTe/XfPboLNLlyq0PMZletaNhckeGaNxjsROw
	 A5dY7oxJ9v2V2UnscwgadEY3RrMlr3k7ovv86MhOPh09QOfb2nW6V+cdMdYPjfqtASx94
	 l3s7F1vTi+3ctYXB+/ndDC96iGYJHdP8PtVOSVd0Q0OBwiUZOSHYIibAxxxlubXZ+5CSB
	 rOvbQR8nNbFbQwte7RjadcuqmSDxxQz7xSXEb0lKjB/1Tv2qkVvYIm3Jed1VUnynp8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tF+skbpm/AJgdXha2BeieRK57d5HqbOWSFbGtuZn7nY=;
	b=DZ5ffGS8WVIyUbeWxB3AgL6wbxYNL/NAzbYHYXUVFTWK9A77pOkA3ehS3pG4DNmhDqIs
	 PTpvX71B2ckmus5J5tnHVJCOPzDfnQJk6VHjpbgkHVWfQjahATsJh3kTNljmeY7nm0eN2
	 /cYLfIxHHguaGgTgiFm1dsuluniFOAHSGU7dwvUsnAgCZRclG1N89u9oi0+d9M0eHbw0k
	 ha76G6n6BXRyHM7jXU1AI9FTXB9QLm5vk2BjtEr3yHtFgoyNz7hhICHrFr/2ULBZKyOIj
	 6coTnc8MeFiN+TRgpHLwNJThBtjGe0wjPeTbhucxLz2JUHHzy4QhWuBHHggIUeToUag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bXdzqvps;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE12606A31C;
	Wed, 28 Oct 2026 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bXdzqvps
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0AD1F01825;
	Wed, 28 Oct 2026 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210947;
	bh=tF+skbpm/AJgdXha2BeieRK57d5HqbOWSFbGtuZn7nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXdzqvpsEYx9WkatANpc8ZBocAW0gV1CDpY2o2gtBIqz8iDjloVKISRFpYj8oH++7
	 ghy2CtIODqrmZaZNETcerS62bG5WfDBJV5+iODE2HrcR+3w1Q+wbY5qwJUckNjfew6
	 L7onesVmSPrAM68GCEZhipPEZv5sf1+NocTSzC9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 204/571] usb: ohci-st: disable controller wakeup on removal
Date: Wed, 28 Oct 2026 17:55:51 +0100
Message-ID: <20261028170012.846781976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 08b2ccd7eb7e41f77a04a09112ca3edcc588e3f0 upstream.

Probe enables controller wakeup after the OHCI core marks controllers with
RemoteWakeupConnected as wakeup-capable. Removal does not undo this, so the
wakeup source can remain attached after driver unbind.

Disable controller wakeup after removing the HCD.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: d115837259ad ("usb: host: ohci-st: Add OHCI driver support for ST STB devices")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-5-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-st.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-st.c
+++ b/drivers/usb/host/ohci-st.c
@@ -243,6 +243,7 @@ static int st_ohci_platform_remove(struc
 	int clk;
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 
 	if (pdata->power_off)
 		pdata->power_off(dev);


