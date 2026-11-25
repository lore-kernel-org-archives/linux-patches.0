Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620631;
	b=R7yjhzjG/VaeCsIoEJ2guIS/8ugm8pAcJMXjfG3GQ3aNf1KAj8x/ZYcd6O+90A0ManTO
	 QoJt5jfqMGTa57VArl935xz+suWf4NlH8dt1DVzXDUeE1oIvuVhqhLZ4eDdKvHw2nk9ut
	 GUWBUdpOMKvIbNH5/IlTKzrk0owuLV+5HH+5NlhmoCNMD22fYwbMEzdk+jL3kO4MCk7tW
	 1YqzHOhfm+HjW4Ny0Twjaq5xP1n8BPDYudeWXUJPgbVcurc9/F70FOjlTMpFPXECL4/f9
	 wQ5rp0olljiZI39dGQ8nJVE4L2gIXZmX2DVjt73rcSLtNjY0TOJObNdKzQMtjwKFy5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VyXT5gQfEkyHenhPz5l6L9BJEL7nqZS27+zuXKnVN1g=;
	b=i0yfj48mPGcPnXv+dwBcLs7JD1CmWF10jwPhKrEZK9cnSuy8jHso0f7M/dSVosDg+Cor
	 9euAEr4sZSkgxktvIpMReIb6yHpQarQ0nwiWiRQtt9oFD9KHTpI41zsF9FAbBnH4aFnm8
	 iXY6RgaTIz7NrdXKirRjqSs1A8ob7PowSltFJRmP8QRWJNipjEBRB4z6Vi/VKUA51RU1v
	 t+NiIPSsar8ax5Bx2TW/LPjUhHkmAKSvvyFEIraY2Ze3+zRs/XR6wIS48DkiEBTtYJ0FH
	 xZOc298Zq6GNAElRMkfqCqKX43St2z9D0Xu2za7Hll9OLuV1vFQ9XfqDsRSViX+ErGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hb84Nd3z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EAB606A326;
	Wed, 25 Nov 2026 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hb84Nd3z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A402C1F000C4;
	Wed, 25 Nov 2026 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620631;
	bh=VyXT5gQfEkyHenhPz5l6L9BJEL7nqZS27+zuXKnVN1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hb84Nd3zbsXXJSWSR6pgaS/3Jaux8OjdNXQhOcBAYsIw+Msm29Uxr2OiRVxfYt0Ky
	 y+KuZRVtUy2nc+8ENVAGxa11HxZSAjsECjteyzMd8wMIAVcg1g9rZOVo8xlMb1viIx
	 cFbnH81tzy7ivGzSDcXi37fVs0vjSR9CCrhCeVDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.3 0937/1005] usb: dwc3: gadget: Reset endpoint flags on controller start
Date: Wed, 25 Nov 2026 15:37:55 +0100
Message-ID: <20261125143843.632890925@linuxfoundation.org>
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

commit 7c9bc134e5b3315e0456cda9e8e59c752309ea78 upstream.

The flags of a disabled endpoint may be preserved while its End
Transfer command is pending. If the command never completes, the stale
flags persist across a soft disconnect or an error recovery, and the
endpoint can't be used again.

Reset the flags of all non-control endpoints when starting the
controller.

Fixes: 76bff31c7fba ("usb: dwc3: gadget: Do not clear ep delayed stop flag during ep disable")
Cc: stable <stable@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/21cd189962b9d32a4f9df381df4947d35341d5a9.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2958,6 +2958,7 @@ static int __dwc3_gadget_start(struct dw
 {
 	struct dwc3_ep		*dep;
 	int			ret = 0;
+	u32			epnum;
 	u32			reg;
 
 	/*
@@ -3015,6 +3016,15 @@ static int __dwc3_gadget_start(struct dw
 		return ret;
 	}
 
+	for (epnum = 2; epnum < dwc->num_eps; epnum++) {
+		dep = dwc->eps[epnum];
+		if (!dep)
+			continue;
+
+		dep->flags &= (DWC3_EP_TXFIFO_RESIZED |
+			       DWC3_EP_RESOURCE_ALLOCATED);
+	}
+
 	dep = dwc->eps[0];
 	dep->flags = 0;
 	ret = __dwc3_gadget_ep_enable(dep, DWC3_DEPCFG_ACTION_INIT);


