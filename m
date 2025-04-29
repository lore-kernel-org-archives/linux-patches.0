Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE9E1C6B4;
	Tue, 29 Apr 2025 17:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947320; cv=none; b=d4h400tFvygFSPsQlwnk5Ix3uT0pIeKVbioUNiRwFwgXtw2TOWpjRx1JMmVF8CknSXcYNdAfxKRGIeI1HEOLL2cWpcQWewqZmmrQNw1SjgObVBixvzFg+N9QmXFZP3wIxwP2v2VP0qB2cdY2Kr4Cpmk5M3OuOuc5w4q+flMmzXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947320; c=relaxed/simple;
	bh=eRvKyetvQURkbppJO/bGFE2XTxYU9pAsp21CqMyvfUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKldVeZzligcC0YOVyjGacTrRJGMMfh9gSHcrTvST2AlRdGxjkSty5b3DGri35uUp3+Q0wnUCRGyCGegODKhqn20MCWjqj29SzosMY3ElQUhgYD6UfbfvkQ4Ae7Dto/ny10hcSYAuQMGS6C+fFF6DUpgmy2WR92x3WumopGmzcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpIC9Bnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpIC9Bnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE49C4CEE3;
	Tue, 29 Apr 2025 17:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947320;
	bh=eRvKyetvQURkbppJO/bGFE2XTxYU9pAsp21CqMyvfUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpIC9Bnn+NJYp06e5UHc0GJhpOjcFYWS4TL9xxSQtWwfHVyIsYZQLGrUeXqXBZPEN
	 9eGfgmQLIfOCalHGGRTNGj4UB4WOjFW18GbcLVSTxupBNT7KSzIJKTKb/08o/4sLNw
	 jMcojKrbhjTItnN2F6qljw98Nya8/AZ1LAbluxzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ehrenreich <michideep@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 244/286] USB: serial: ftdi_sio: add support for Abacus Electrics Optical Probe
Date: Tue, 29 Apr 2025 18:42:28 +0200
Message-ID: <20250429161117.966839079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ehrenreich <michideep@gmail.com>

commit b399078f882b6e5d32da18b6c696cc84b12f90d5 upstream.

Abacus Electrics makes optical probes for interacting with smart meters
over an optical interface.

At least one version uses an FT232B chip (as detected by ftdi_sio) with
a custom USB PID, which needs to be added to the list to make the device
work in a plug-and-play fashion.

Signed-off-by: Michael Ehrenreich <michideep@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1071,6 +1071,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 1) },
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 2) },
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 3) },
+	/* Abacus Electrics */
+	{ USB_DEVICE(FTDI_VID, ABACUS_OPTICAL_PROBE_PID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -436,6 +436,11 @@
 #define LINX_FUTURE_2_PID   0xF44C	/* Linx future device */
 
 /*
+ * Abacus Electrics
+ */
+#define ABACUS_OPTICAL_PROBE_PID	0xf458 /* ABACUS ELECTRICS Optical Probe */
+
+/*
  * Oceanic product ids
  */
 #define FTDI_OCEANIC_PID	0xF460  /* Oceanic dive instrument */


