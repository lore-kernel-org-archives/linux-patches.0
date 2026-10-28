Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212781;
	b=uICMLKxgvMRYHV1HvTJl4v9w8hllJ3fH8kybkicxCJFPZXO6geHD04+Mq4x+0HAi+6fG
	 34NRJiIIJ4zhJJ529RffF+t3KhambgKVZjOdgNsNdC3WoDmthqDnfQ8VPodpIg3iJ0KwJ
	 eApzrsjdjkJ7Hi+c0OGjiPkxzC5AtR4qvcXZcV4gu/lQhOxSm+kxjBQUJsytGtWWLOTMB
	 c45v7UYpepM06I1hj2dz0J/BVPJjNXnKCv/BmiYHjNfBwJUqW2itp2qbJahSLlRcdjJOk
	 iGLuaxoxhKD3jILPSyB7YGmcRoHtoheFC9jPiKP0Baj6o6E1P1yAakNsl46fY1Duirw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Njri7g8tGozYZgIdMq6uR5OHkAPM9uhElIVHuYNtcs=;
	b=Z8kSxn7TxxS+iRX9ygNZqWQVPQvM66Rz3+epMJY8L2EYy7mXBe++tWn6mGVKrULASoAr
	 9TR5l0sZURaRimGy9l8DjA6WwbaO2rYkvXEyMNwR5AFXJFYrntVv73w7dVYIFYc/VnU49
	 SLM8DrLveMR5KHgmxhPlnFLOec/YMBeQFk74TpZa/QMGtiVcmkjWXLSWGoGpomfKvL345
	 rcXwrHeD4rKvRpRDobMSVD3yhsXCsLlXlrsQFJuiCiZt5V83k5IuHeWOxvjqLaxtwn3PQ
	 5I1Ar7m5SyXGFSa+uh6NhuxNMHlE5+m65n18GA8FfvbpYqhrRx8EZxDOLIsXia2vn/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LW17JNKg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB54606A31A;
	Wed, 28 Oct 2026 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LW17JNKg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0941F01825;
	Wed, 28 Oct 2026 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212780;
	bh=6Njri7g8tGozYZgIdMq6uR5OHkAPM9uhElIVHuYNtcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LW17JNKgzZ4KD7edjgygpZ341HV9NgYsZW6MDRxEPERtMvU9AAyC4VAKoxaPcvq+3
	 ISuP83dfvzE8LTLv9NmcBP8MUQ1Jft5hr8I1Hj2Aq4tZIyqFSxF1EdZ7Pl6nPrOdHB
	 bwKDPoq9JfSynDoA8G74xHZq4V7f488+5TB+yKzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 0274/1887] usb: ohci-st: disable controller wakeup on removal
Date: Wed, 28 Oct 2026 17:39:30 +0100
Message-ID: <20261028170505.465083971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
@@ -241,6 +241,7 @@ static int st_ohci_platform_remove(struc
 	int clk;
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 
 	if (pdata->power_off)
 		pdata->power_off(dev);


