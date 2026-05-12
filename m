Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992393955DB;
	Tue, 12 May 2026 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608324; cv=none; b=cn5kevd3QEh4EPbvpFq+oQhUHmHftZrVslX83pV7u5S7DtfeRQW6y9fmvPOJdEtPFYY5T9xdhZMyPEgsmwppacFmbiqwViPqQQWunBO6g3AvBY0ARONy+IGo6OPMsfn+tLVBNKU46ClQSCEQvqaA64xeSeM+8qnLbXVoZ4WHzhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608324; c=relaxed/simple;
	bh=3PwNKzuw5fNswCslRv5mKvXez3PjQbERFumJBY5iN7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LkjKMD0b7WZQ39FEejGBUle9K2tgTJvcRX/eBbUhynSpMJG+8lYEvGNAdl0WCuaKLr/NFiOHcXBBmTbxCc55ZK2sGtVVXRLHKAIm6PyOa5WeLLSiAfbpgWMlHm53cjzzBYY1C+Shgv+S0RyklE0XjVYG65J/JrTdlfsBExJRlEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nd199hIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nd199hIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A10C2BCB0;
	Tue, 12 May 2026 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608324;
	bh=3PwNKzuw5fNswCslRv5mKvXez3PjQbERFumJBY5iN7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nd199hIjCyw9H5Eu2jp9PUUSfBatF9VRUNlBovoeq+nKmIcvk3r4QgQoX2KQqJmrC
	 sV0JLdHLMN3Z2dkCiQwkVCyjEmsHnndSh/OpsXcWdUObq6TAsHWB3eq6A1FuzRmT/f
	 CZX4GAVEVX2LJoaheE1Y/vIxqVLvXxqdH1P7YNhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 6.18 007/270] ACPI: video: Add backlight=native quirk for Dell OptiPlex 7770 AIO
Date: Tue, 12 May 2026 19:36:48 +0200
Message-ID: <20260512173938.609906599@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Schär <jan@jschaer.ch>

commit ad7997f5a01af6f711fe6b6a2df578b964109d49 upstream.

The Dell OptiPlex 7770 AIO needs the same quirk as the 7760 AIO. The
backlight can be controlled with the native controller, intel_backlight,
but not with dell_uart_backlight.

I dumped the DSDT using acpidump, acpixtract and iasl, and confirmed
that it contains the DELL0501 device. When loading the
dell_uart_backlight driver with `rmmod dell_uart_backlight`, `modprobe
dell_uart_backlight dyndbg`, it reports "Firmware version: GL_Re_V18".

Fixes: cd8e468efb4f ("ACPI: video: Add Dell UART backlight controller detection")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Jan Schär <jan@jschaer.ch>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260411092606.47925-1-jan@jschaer.ch
Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -878,6 +878,14 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 7760 AIO"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Dell OptiPlex 7770 AIO */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 7770 AIO"),
+		},
+	},
 
 	/*
 	 * Models which have nvidia-ec-wmi support, but should not use it.


