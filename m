Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410EE2EAD10;
	Fri,  9 Jan 2026 12:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960607; cv=none; b=J/UX53p5+E7gjLgr3Ej02JCfUTpUHyR0R5mX7sDR1NZww5rg8qOiTv5iOvCpjs+mCreT3PZfRJHh+WLz39SenY+yL/T7nq0vq+iqRc3JoNlRWNJdtVy/CnIMGtYHdQBGWo6knZODpC4+TRmb0e+SHgHJfwK1DiGWs3TAzYSxn4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960607; c=relaxed/simple;
	bh=PNxaQf6yEXX9pCF1AbF1BrBNuHoq73P4WbOO2sGAZAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEsVIYW3MFDePHmDYa9raopiGX6NmpqY4Y36gBJof/L0YGnfNMg3aw55nMse6aoCIEi1i+JGeK/KP3UHjMPGIRHwPAnZfHsgSsgvooYfzvjjOT5e98UrvppHMO+XsvcMpmGAAT0HFwgzeEQa0SI6py5CmRZ79bOFX6RntlhRuoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAjdxIyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAjdxIyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DE1C4CEF1;
	Fri,  9 Jan 2026 12:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960607;
	bh=PNxaQf6yEXX9pCF1AbF1BrBNuHoq73P4WbOO2sGAZAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAjdxIyyYhzaxTsv/i0PiwE4fweFIrHg/MzExbV2DgRxrVrSKktZD6imIrY/TTa5q
	 jsB/PvSuHZdhU0ZMKTgpfh1HeXoSKrp9ET30s+FBdJdfKRaicMUj2OQhYXRNAu6ygg
	 3Kdx8oQKupZpzDU4Et8ocli4AlcEnwlfkvh6rzw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>
Subject: [PATCH 6.6 431/737] usb: usb-storage: Maintain minimal modifications to the bcdDevice range.
Date: Fri,  9 Jan 2026 12:39:30 +0100
Message-ID: <20260109112150.208537778@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

commit 0831269b5f71594882accfceb02638124f88955d upstream.

We cannot determine which models require the NO_ATA_1X and
IGNORE_RESIDUE quirks aside from the EL-R12 optical drive device.

Fixes: 955a48a5353f ("usb: usb-storage: No additional quirks need to be added to the EL-R12 optical drive.")
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Link: https://patch.msgid.link/20251218012318.15978-1-chenchangcheng@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -98,7 +98,7 @@ UNUSUAL_DEV(0x125f, 0xa94a, 0x0160, 0x01
 		US_FL_NO_ATA_1X),
 
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
-UNUSUAL_DEV(0x13fd, 0x3940, 0x0309, 0x0309,
+UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x0309,
 		"Initio Corporation",
 		"INIC-3069",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,


