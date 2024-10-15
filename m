Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9EF1D4154;
	Tue, 15 Oct 2024 11:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993172; cv=none; b=PNwptYHPrMi3oR+Tn2QtLPo7DU1xro59juXoTbPg5gPIXQr4Mkva1JtNMHVSomvpAtMlqA0fofdfnvp8SnMUBb8MvYI/qCHgVgxhfXMaldIZbrRaBiNfW4eRebvCAB8XfeSwPSid3P7Y/wLglo0GorCWkB75CMoHdnyQqdM2mqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993172; c=relaxed/simple;
	bh=HyBiQVJtxknYh1V97h6jizsrymLHNPID1XxWCScFHVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dz6CJ0VsqAEPG0jZEoZoozrgPvQcLKUM+eWu2yj/Zu93cJ9jtVWh7XIn20nyaFpvDBJ1Gqo9X8pHcMVSsJhfvepYwilf4bEqHGUVeVRaVTz+FEk3urEJVtuxF4Z2GFz3UVdHsmVfFtkALPkAKl/1FuKsiKkjIyU3c1A5q7tawSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBTycWw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBTycWw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12E7C4CEC6;
	Tue, 15 Oct 2024 11:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993172;
	bh=HyBiQVJtxknYh1V97h6jizsrymLHNPID1XxWCScFHVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBTycWw8/t5w04NwnKq2wkmXrA3rGLxAMm3r/Am28uPT2WpoZwUXh4w0pcMiW//yS
	 93D64YOQ5vnv6D+BV9nO+P58kCLbDn9GB3FQXRK4E55TKUSMS8UFu9lsapLsmV1ZE7
	 PLGv/9HOxzL/bBcvRTn/0BxFnWgIaNvcQ9+Lqn8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 332/691] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Tue, 15 Oct 2024 13:24:40 +0200
Message-ID: <20241015112453.512000682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit a98cfe6ff15b62f94a44d565607a16771c847bc6 upstream.

Internal documentation suggest that the TUXEDO Polaris 15 Gen5 AMD might
have GMxXGxX as the board name instead of GMxXGxx.

Adding both to be on the safe side.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240910094008.1601230-1-wse@tuxedocomputers.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -516,6 +516,12 @@ static const struct dmi_system_id mainge
 		},
 	},
 	{
+		/* TongFang GMxXGxX/TUXEDO Polaris 15 Gen5 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxX"),
+		},
+	},
+	{
 		/* TongFang GMxXGxx sold as Eluktronics Inc. RP-15 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),


