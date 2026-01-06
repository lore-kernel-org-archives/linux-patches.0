Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20670376BFD;
	Tue,  6 Jan 2026 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722429; cv=none; b=MJsc+GwHnib91LtQ782AVTd00B8LlfOA4i47ojW/UIfTgDCcXu4xJL+Oo9Bu3tnmo90Pm61uxuYKmctUY97AFQVk9t+LdF+rbZRXcX+bM96SflVfBBTYpzRZYyRDnFjgxl/PlbL297a1UosSoiRd8yRE/iIMJmaaZ2duPQOYOX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722429; c=relaxed/simple;
	bh=63SBDZdXI4hyIKAnwK1ZUUbRfIEftZ4auEyxS1y74Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BBTmKIzyLSJ32nBJsXPLHaHqdR9n+5PreV+XU5ls3q7DysBCc/4o0iZNVj/r8FX2C5k6fabD8uvCknC8IPZhW6lvGC/9GrbMY9ro8vxD9Urb6DIHKiV9i4Ts27/6KbnmUfxzDkciWWqAdJR7Hew5CMeWpdgoCbT7UMJXP9QCu/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ab/wtBwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ab/wtBwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDC6C116C6;
	Tue,  6 Jan 2026 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722429;
	bh=63SBDZdXI4hyIKAnwK1ZUUbRfIEftZ4auEyxS1y74Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ab/wtBwIWUtp+MtOHfODUF4ERbAqzTa+DTWvtCcSb0Yu5pExT5CERe1FCnXvQFpv/
	 ORy9nUsVNBbB501fyZ3nBzT4DhGbN/0x980GDUxyI1wwN8RXjFfEYF4JBtcotk+/Mz
	 5TvP67oIr0ntdTmjThlJ3kjP+kHhWVqvH2IW22/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 260/312] platform/x86: alienware-wmi-wmax: Add AWCC support for Alienware x16
Date: Tue,  6 Jan 2026 18:05:34 +0100
Message-ID: <20260106170557.253292397@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Kurt Borja <kuurtb@gmail.com>

commit a584644a490d276907e56817694859eaac2a4199 upstream.

Add AWCC support for Alienware x16 laptops.

Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20251205-area-51-v1-2-d2cb13530851@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -178,6 +178,14 @@ static const struct dmi_system_id awcc_d
 		.driver_data = &generic_quirks,
 	},
 	{
+		.ident = "Alienware x16",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware x16"),
+		},
+		.driver_data = &g_series_quirks,
+	},
+	{
 		.ident = "Alienware x17",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),


