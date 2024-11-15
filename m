Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFDA14EC77;
	Fri, 15 Nov 2024 06:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653648; cv=none; b=b5j2K8n4/OOQ+caVm0HbITEVTVPWrkci5rvh73cf56qEzAuYdA6jawoEWweCpej2LzcLVwClDS/2z4hvN57N+5rJcx35XrimeeYEI1SrXQmJBz0D1cdX9tfYvbIERNCoA99vNnW7ADivgUPsDUbs2IJ5TCtx/D2guPBlpFWUbCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653648; c=relaxed/simple;
	bh=595+sw3wV3aiAXI3Ro+1RgxaIVM8F4vT7Istjuch5nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iid+alE0t/+/MVPzxfSLzxDtwrxUU3XbRHxC4peEa7ZmKFCOTBm0w8FtOgntFYhqQlhy4QFL1IbvOvT9COEVk37mnLfx06Q2B5st33Eb3yQAyU/1pxe0mml8N9fx90EIwQiV2GhU1BTFyHMhA5OpIXVOG7JuF41wyLT/9t/SBVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=daMk3M93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="daMk3M93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E46AC4CECF;
	Fri, 15 Nov 2024 06:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653647;
	bh=595+sw3wV3aiAXI3Ro+1RgxaIVM8F4vT7Istjuch5nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daMk3M93x6HUDl5Y0LZUEyQzVgRTuaPyjonLMU/OXZYXqB64hMwta2AnvRhqV7NEz
	 K7mW2vcxcdSQNTU/A2Y3FJJPGYNfIaAk8NS4c7GwKn0TQXqwuFt+aWkgJTNTEAF7mt
	 cT9NV9N2P308uTrc4sDUzZhSNGm0f3DhGNKwjI4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jeremy=20Lain=C3=A9?= <jeremy.laine@m4x.org>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Mike <user.service2016@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/39] Revert "Bluetooth: fix use-after-free in accessing skb after sending it"
Date: Fri, 15 Nov 2024 07:38:11 +0100
Message-ID: <20241115063722.657868624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 715264ad09fd4004e347cdb79fa58a4f2344f13f which is
commit 947ec0d002dce8577b655793dcc6fc78d67b7cb6 upstream.

It is reported to cause regressions in the 6.1.y tree, so revert it for
now.

Link: https://lore.kernel.org/all/CADRbXaDqx6S+7tzdDPPEpRu9eDLrHQkqoWTTGfKJSRxY=hT5MQ@mail.gmail.com/
Reported-by: Jeremy Lainé <jeremy.laine@m4x.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: Mike <user.service2016@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Pauli Virtanen <pav@iki.fi>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4146,7 +4146,7 @@ static void hci_send_cmd_sync(struct hci
 	if (hci_req_status_pend(hdev) &&
 	    !hci_dev_test_and_set_flag(hdev, HCI_CMD_PENDING)) {
 		kfree_skb(hdev->req_skb);
-		hdev->req_skb = skb_clone(hdev->sent_cmd, GFP_KERNEL);
+		hdev->req_skb = skb_clone(skb, GFP_KERNEL);
 	}
 
 	atomic_dec(&hdev->cmd_cnt);


