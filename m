Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BA1BA45;
	Fri,  9 Oct 2026 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556645; cv=none; b=ZAsD2TcIKuWZ5ctJVwFBG3WkksxRbzMtsqxi/BOjQAJVnpRe9pmVA4o8ywIi7htJHw3eLydGKXQxkNZLFOPPfAEe8x0VxoW3tGjSuhxztXOOAQbUdFSUu653UzKYSVPuopDH9WY+ZiDWffD2rexPOAlib/OQtFp7dNV7uSSEKT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556645; c=relaxed/simple;
	bh=UFuBEZqG1lufxhmj/J3dH6oqbEtDdd7kQSU4BcLWeHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2AHyXn7z5iyZJ5hvTt3JcPsQA4a1yrVtld6XLQJMOuC9JBpVt2v7BPINNKUp1WzWP8RfHnTghDft76RZTWnT8gEDMJXx9v14dqHYAn714xlhFV+eTeQphQ1WWpeQVKaSat4eV9HHsJu9FCsAzsEygvYE6+ARsb1l+lPBflQh3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fz0MRqHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fz0MRqHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D981F000FF;
	Fri,  9 Oct 2026 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556644;
	bh=Sj3zSYhvtJFMNg52y3w76TR+JbZGk4V7ZC0eQ+FZWso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fz0MRqHK7C7aqq2UCGrbPAwh/Ry7QUJIprArfbOTuYE+nQSmOZwJ6f9oQOMvXZdkM
	 r3uG30ccLMtRzgnIudnNGzaT5zgXhKLXSJI+lxCdmdFPF7gvI1WAb2ppNTfIaG/ZkV
	 1k6Zpsj0Ol/UK+d8RiLbOg895/aEPvZtTs+GfHEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.2 214/428] usb: ohci-st: disable controller wakeup on removal
Date: Fri,  9 Oct 2026 16:09:11 +0200
Message-ID: <20261009140950.826036199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -235,6 +235,7 @@ static void st_ohci_platform_remove(stru
 	int clk;
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 
 	if (pdata->power_off)
 		pdata->power_off(dev);


