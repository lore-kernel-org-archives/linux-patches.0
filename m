Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC3C186E31;
	Wed,  3 Jul 2024 10:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004327; cv=none; b=LdDqnlmhsa2joyHbDIT859iyhKGZKVKnMStwlhnuhM3judSVqn5D7/eXVjgmfZ4XCZ44/hlCQeA7dU0/VdOfxmeQWimzzyg0OKJJafs8Qw5iNH1uFMf/GzqAG9UHtq9U9Jn8qtwv91CxQBeJOBgQFUGDXLN55jnEaQkjJd6VMX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004327; c=relaxed/simple;
	bh=pUY6hBXWi/rB2Kdx2AKpswWRingC8h7JiINV1Jg6y2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omLa03HQ2oIPimc7C9vHRlCuoZaeOaoUBPDZeyKDsYxz13woEFiqJku5bIfHas7z04Z2oEVTe9Vhah3LCemTHY9mOTnIfiDYs8QB97P8HGxTZHPyKKeBAyd1Qs/P/f+KlClJkhIQwQEQDkKXnJG1EyzjtAYstGNuAcpRgAA0rk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P10iDnPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P10iDnPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8287C2BD10;
	Wed,  3 Jul 2024 10:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004327;
	bh=pUY6hBXWi/rB2Kdx2AKpswWRingC8h7JiINV1Jg6y2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P10iDnPxZwu+ICXQmaWUWtpmlfIAdBa4iAeNe9bKI+6A5is8obocfhdwzlyMZB5lD
	 iOBtMfPH3B5oM1S1COhrHJaf4RnMVHxX0FrRHKhMyXLbg/DXzJiM3x5jl7f8wIHO1I
	 E9Kf41DkR5nZXRtXLJ8pY8DYCu9N/ubdhfXCK5cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 166/189] usb: gadget: printer: SS+ support
Date: Wed,  3 Jul 2024 12:40:27 +0200
Message-ID: <20240703102847.733172818@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit fd80731e5e9d1402cb2f85022a6abf9b1982ec5f upstream.

We need to treat super speed plus as super speed, not the default,
which is full speed.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240620093800.28901-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -208,6 +208,7 @@ static inline struct usb_endpoint_descri
 					struct usb_endpoint_descriptor *ss)
 {
 	switch (gadget->speed) {
+	case USB_SPEED_SUPER_PLUS:
 	case USB_SPEED_SUPER:
 		return ss;
 	case USB_SPEED_HIGH:


