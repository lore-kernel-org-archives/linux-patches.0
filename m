Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620634;
	b=MsQvmZH29YEuLv8mgU7HFBtpG5+PA3Byq5H1r8WMS8VobEPvqtIy4bfg08uQ7zTRYyKI
	 XSBGwTHXLJIDP0U2EP+91s5+qNsnubVsBBPMVrfR5gFABDErWUnXHGyhnsK9qINoUcoMK
	 Y/wx449SMMC/p19c87dDPyiVQW9/aEGOvnJYu2wI5MBoVR9s0JEjp5+ep7EYHc2bKhEZ8
	 4+5+57WWuQ9dved10a5+K2Sb2Je/Y17TZ/rYxXSMZeo/a7/6117qbUFVh+XlRtvJtrYwv
	 gFo5CntWv8ObH74f3SjzeHgWZFdh7C/NxLQzJvBCgxOZ9fC+OMMOKW/vA9w3Pac8pEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DtoKYwKl+FfqMD4baDpnaEWMrNSOqKwI73ogyG1stts=;
	b=xE8oVoyahyKQJpHVW2pwBeBBEfgpA7da75dfS8nosMUTi0pwEApB4VwMIX+53n/79otj
	 ul4SyDxAhWXexWmnhb5TTKA8irTPSRjQXPlKpGAEjKJ2vY/nOqmbJM7t1KD2ZlTWY5K5Q
	 efNxSCVf1j00iPiuJibAOv3ZryNTSmjrpd9i6pIp83h+x6qkEAofWANK6JT579kFOyWV0
	 7Wpms8j4rIfZrLvifYsi2AEA65ZxBxY7gtWLkkLFNCkZUseDWrMkezZaU+ei0Z3Kvtb3r
	 FFzWJYBrCj6qoanUM0S093Yj7ye7gWxuLAy0NxYtuaExYGwoxRZ+gO+p4lyR/GLrs1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=saNMy4wd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55380606A31E;
	Wed, 25 Nov 2026 15:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=saNMy4wd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EF21F000C4;
	Wed, 25 Nov 2026 15:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620634;
	bh=DtoKYwKl+FfqMD4baDpnaEWMrNSOqKwI73ogyG1stts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saNMy4wd9KXO81QZd5LwEyDCVXUxwKT/flew6iskUAcqEBDNvOAWuy2fpFElg1ERV
	 SEbKoC3uamoh9wPZwSUb5yLwtHepar1ligwS39S3kbeEl2vzLmIphDmzuvqoMoMaPG
	 zycUo52yMk+T1BoUXeJA0ahaUtjmgxmcsMC6cRdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.3 0938/1005] usb: dwc3: gadget: Track a timed out End Transfer
Date: Wed, 25 Nov 2026 15:37:56 +0100
Message-ID: <20261125143843.655354389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit af91c6322e633504aa45de278f5d520f39d127be upstream.

If an End Transfer command with CMDIOC times out, the driver clears the
resource index but keeps DWC3_EP_TRANSFER_STARTED without setting
DWC3_EP_END_TRANSFER_PENDING. The command is still outstanding, but a
later stop issues another End Transfer with resource index 0, and the
next Start Transfer fails with "No Resource".

Mark the timed out End Transfer as pending so that no other command is
issued to the endpoint until it completes. For any other failure, there
is no outstanding command, so clear DWC3_EP_TRANSFER_STARTED.

Fixes: e192cc7b5239 ("usb: dwc3: gadget: move cmd_endtransfer to extra function")
Cc: stable <stable@kernel.org>
Reported-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Closes: https://lore.kernel.org/linux-usb/3fdda532-8181-48e9-b58d-cad7289408e7@samsung.com/
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/5815c41a7e7923edb114741f29697cf0161f523c.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1806,9 +1806,9 @@ static int __dwc3_stop_active_transfer(s
 
 	dep->resource_index = 0;
 
-	if (!interrupt)
+	if (!interrupt || (ret && ret != -ETIMEDOUT))
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	else if (!ret)
+	else
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
 
 	dep->flags &= ~DWC3_EP_DELAY_STOP;


