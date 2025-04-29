Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC1D82C60;
	Tue, 29 Apr 2025 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947889; cv=none; b=Z1qhE9EQSKLFBxCj8drcB65tRi1DZmJvxgxfeuiANkTnK7hgeBGLUo6X7S8j3dlGUbKjSJAg2gnKHVOO8IW7qHpSE0zEVyb7CW16m2iAV7lLVPTjTYAu3DJXxHJNXBjnjIVmgz1hgISJ9ML9tTlod9sFmcj4BodyQkpJxZ9DEwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947889; c=relaxed/simple;
	bh=Ug8DpiHDlJXvjuL/79ey0iEuXXrDYCtLsYiB+n8Ec1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puyO0Sj36vhVFuSR0R3c631NqOHBU07LKVreTv77cTYyQoYnRd3UqFJsurGylbgpkJttxilCLPWqJiBH2iJa98Mw+Yvt+tOdMlD9UT0PdD1iTTCn4ONoq1drD0Zno/FSL3//FYuKjhJkqKJOP8yVCL8cgUFUF80xGAVXgqvVh5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B47xkQAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B47xkQAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2240EC4CEE3;
	Tue, 29 Apr 2025 17:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947889;
	bh=Ug8DpiHDlJXvjuL/79ey0iEuXXrDYCtLsYiB+n8Ec1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B47xkQAuZjzzwcDafZDezedBphqLtZfr4l8Z0dHKVJaN0tQiNQrJRdLdVJhWEDauQ
	 z7/AY2UG0KslDfsNhgM1kuVs9wNR7su+DmgscPYgJxHe2tsoxukgFGyprZIgZ+27wK
	 C96MlziNZD/cYZ3mOoKC0raf1Bdrv44D+eJOgQg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ehrenreich <michideep@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 133/280] USB: serial: ftdi_sio: add support for Abacus Electrics Optical Probe
Date: Tue, 29 Apr 2025 18:41:14 +0200
Message-ID: <20250429161120.570150524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1093,6 +1093,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 1) },
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 2) },
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 3) },
+	/* Abacus Electrics */
+	{ USB_DEVICE(FTDI_VID, ABACUS_OPTICAL_PROBE_PID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -443,6 +443,11 @@
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


