Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5E017F394;
	Sun,  1 Sep 2024 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207855; cv=none; b=sQdbjVexOiKK5AsuuipdW8besbFA3b7lwuAn2l2tqyz0svyd7xUp2mRfL/2z1QfssXcF/x2cDobVz1kSANfzH/fhA+m68gDGgq3ndxtuQETHGuPt+ijbgn9UDskOKDYZ/qTo3mHNu3R7iD/8ZWD3Qe6njMs/F6JjnXe3cwkqMwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207855; c=relaxed/simple;
	bh=W/vpThO1LIzhdnxtkIBwFmhPtd2y4U6F/kr5an21W7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqV6HzuaN21TNQPDrnlH0cq33Sh2d12c+NuTY1PCzsJdR5lytNJA/+3nJcgJPYla68/bu/Fni2Jwy27oiUfDKRJrzKBYKYtU5h4xXPscbTeKsD2p3LBA5jcuM9hKHlLbbFfxstgVJ4uxVZXWV5VTVAmgLsCvBgOGLao0p1pVcAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhvcZgWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhvcZgWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB855C4CEC3;
	Sun,  1 Sep 2024 16:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207855;
	bh=W/vpThO1LIzhdnxtkIBwFmhPtd2y4U6F/kr5an21W7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhvcZgWu8H/iTRzHtZ66BsC6Q1x8ZxTsBe9MvL8YD3wGLy6SHvsRCgWQ840jLvnqC
	 zvbYTsRh8bdAJVaoibUcS8cr2C0IrAk+OG1brY56RYhqpe9sUzzkfKkrLhs/7MhiPY
	 XqeB2O4AEvbrPeu0RFHg28T6+Y0x15s4QbKhtqA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Oliver Neuku <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 4.19 90/98] cdc-acm: Add DISABLE_ECHO quirk for GE HealthCare UI Controller
Date: Sun,  1 Sep 2024 18:17:00 +0200
Message-ID: <20240901160807.091417492@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Ray <ian.ray@gehealthcare.com>

commit 0b00583ecacb0b51712a5ecd34cf7e6684307c67 upstream.

USB_DEVICE(0x1901, 0x0006) may send data before cdc_acm is ready, which
may be misinterpreted in the default N_TTY line discipline.

Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Acked-by: Oliver Neuku <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240814072905.2501-1-ian.ray@gehealthcare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1807,6 +1807,9 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x11ca, 0x0201), /* VeriFone Mx870 Gadget Serial */
 	.driver_info = SINGLE_RX_URB,
 	},
+	{ USB_DEVICE(0x1901, 0x0006), /* GE Healthcare Patient Monitor UI Controller */
+	.driver_info = DISABLE_ECHO, /* DISABLE ECHO in termios flag */
+	},
 	{ USB_DEVICE(0x1965, 0x0018), /* Uniden UBC125XLT */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},


