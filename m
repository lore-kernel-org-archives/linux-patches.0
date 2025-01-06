Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617B786332;
	Mon,  6 Jan 2025 15:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177660; cv=none; b=FteYgeNi1IIN87506yp1TYYGoCtwPi0PdFEMR8Ilg7r7eHU+/VVzUS4iULPX3tvTspsAAyFwWYxje9r3YTiwhjRgPpnuCAEztwZvIM17Rx14rqtiycp983bKPaRXgo4fnZBKcRyvAL/Fz1OAaa6uamgqZ0z0Z4uc5bIFkSw8UcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177660; c=relaxed/simple;
	bh=QHLuIUhX/qAnOn+yUgOvy9Mo/dwGm0li+U7d7+g8Yk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RJ6eHbdFS3tthghvL+/hM+MklPjcjm6osU4MOMRYkt8vo2lzDIscawfvw/EY8PzwlMy0qktRIB9M8q9MGTPA8kHs1C0NsCJpo4vr+LL+vHIJjx4mXiPDfoxw9r0Sd2TQoTKzlxXPGrbvdGJrm54xFAyuhlAWrAk6LK8AN9KfdVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WblQbqks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WblQbqks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84247C4CED6;
	Mon,  6 Jan 2025 15:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177658;
	bh=QHLuIUhX/qAnOn+yUgOvy9Mo/dwGm0li+U7d7+g8Yk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WblQbqksv1DCRPFXOV7eUa/MuFqOfu2WtlPA6JEA2eBHhu4252kMC35SwPk2NWiAQ
	 cy+nyAzuKpqAGKUTaZD+z+Z5kq+66LolkFgXc7eSgjbQMC+lMjjag0EoSJ5srXR45c
	 7Oc3lAeNAEp1X3na/fAJOnG0vtApYKGkPgGT/dP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Sankar <vishnuocv@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 003/156] platform/x86: thinkpad-acpi: Add support for hotkey 0x1401
Date: Mon,  6 Jan 2025 16:14:49 +0100
Message-ID: <20250106151141.871053425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Sankar <vishnuocv@gmail.com>

commit 7e16ae558a87ac9099b6a93a43f19b42d809fd78 upstream.

F8 mode key on Lenovo 2025 platforms use a different key code.
Adding support for the new keycode 0x1401.

Tested on X1 Carbon Gen 13 and X1 2-in-1 Gen 10.

Signed-off-by: Vishnu Sankar <vishnuocv@gmail.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20241227231840.21334-1-vishnuocv@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/laptops/thinkpad-acpi.rst |   10 +++++++---
 drivers/platform/x86/thinkpad_acpi.c                |    4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/laptops/thinkpad-acpi.rst
+++ b/Documentation/admin-guide/laptops/thinkpad-acpi.rst
@@ -445,8 +445,10 @@ event	code	Key		Notes
 0x1008	0x07	FN+F8		IBM: toggle screen expand
 				Lenovo: configure UltraNav,
 				or toggle screen expand.
-				On newer platforms (2024+)
-				replaced by 0x131f (see below)
+				On 2024 platforms replaced by
+				0x131f (see below) and on newer
+				platforms (2025 +) keycode is
+				replaced by 0x1401 (see below).
 
 0x1009	0x08	FN+F9		-
 
@@ -506,9 +508,11 @@ event	code	Key		Notes
 
 0x1019	0x18	unknown
 
-0x131f	...	FN+F8	        Platform Mode change.
+0x131f	...	FN+F8		Platform Mode change (2024 systems).
 				Implemented in driver.
 
+0x1401	...	FN+F8		Platform Mode change (2025 + systems).
+				Implemented in driver.
 ...	...	...
 
 0x1020	0x1F	unknown
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -184,7 +184,8 @@ enum tpacpi_hkey_event_t {
 						   */
 	TP_HKEY_EV_AMT_TOGGLE		= 0x131a, /* Toggle AMT on/off */
 	TP_HKEY_EV_DOUBLETAP_TOGGLE	= 0x131c, /* Toggle trackpoint doubletap on/off */
-	TP_HKEY_EV_PROFILE_TOGGLE	= 0x131f, /* Toggle platform profile */
+	TP_HKEY_EV_PROFILE_TOGGLE	= 0x131f, /* Toggle platform profile in 2024 systems */
+	TP_HKEY_EV_PROFILE_TOGGLE2	= 0x1401, /* Toggle platform profile in 2025 + systems */
 
 	/* Reasons for waking up from S3/S4 */
 	TP_HKEY_EV_WKUP_S3_UNDOCK	= 0x2304, /* undock requested, S3 */
@@ -11200,6 +11201,7 @@ static bool tpacpi_driver_event(const un
 		tp_features.trackpoint_doubletap = !tp_features.trackpoint_doubletap;
 		return true;
 	case TP_HKEY_EV_PROFILE_TOGGLE:
+	case TP_HKEY_EV_PROFILE_TOGGLE2:
 		platform_profile_cycle();
 		return true;
 	}


