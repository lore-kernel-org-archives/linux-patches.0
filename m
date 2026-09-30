Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7637503BF3;
	Wed, 30 Sep 2026 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786229; cv=none; b=cR/8Wf/jiV5oOkMU5JfVsiKIm6PY2tjXktDCm2MJtK22Gy3qd3zjDg8Fmw2q8B0O+QaZiH8+3y5YOULLL3Yj7d8SjQPfEOm+XsH//RQCKzaGTsW/F+Wr4NiSuxbPq1RCZlH+vSlSTb+lLU8o11kDxM6UNPpSCjm1dX3IkQz7HA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786229; c=relaxed/simple;
	bh=psvsf3Lv8BAbROA85iovCzJTDdDd4ljWRxFGlfveZXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaNc9w1A2NljBC5HF1fcprLWZ2cH2R3+5sXYNJgoEH5bI+gmq+DaCtycFJn/Qi4Ty74DH+3iLHHjFZtDIL4vBQuQelwa4b1OwSDAQVHUxRkcAM+8+meupqd/PQE2f5a92U9MndX2D5G5Y/+IjwpIS6ANULP5cfqjx0iAmdR8Oj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSNF7jCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSNF7jCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC631F000FF;
	Wed, 30 Sep 2026 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786228;
	bh=ODbBXYd2G2awgTZNzD4vXjx+ibAA1KCWlFnBMSKp2es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSNF7jCDO3AU7+cMfSMIXKPlDEOa2hR7miYH9kaIsS/oJWagwWDn9xiIFOOR10xAl
	 XmJoZEFX2oJ7uxu1q7j7KI3k9av87GpZVLKFV7g7ktkp73iJ5zXzczwHWIajn8VjDw
	 A0qcAoxPmpUR+zNtMzgJTUBlXHmReBF361kUmlAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Sommers <chris.sommers@icloud.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 742/982] Input: i8042 - add quirk for Acer Aspire Go 15 AG15-42P
Date: Wed, 30 Sep 2026 17:24:38 +0200
Message-ID: <20260930152432.692801218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Sommers <chris.sommers@icloud.com>

commit 25e424eb4ae1a662d9c3573218d06ac32f797fc5 upstream.

On the Acer Aspire Go 15 (AG15-42P), the internal keyboard drops out
~5 seconds after boot on both Linux and Linux-LTS kernels. Keystrokes on
the built-in keyboard stop registering while the trackpad and external
keyboards remain functional.

Testing confirms that booting with the i8042.reset kernel parameter
resolves the issue and keeps the internal keyboard responsive.

Add SERIO_QUIRK_RESET_ALWAYS to i8042_dmi_quirk_table for the Acer
Aspire AG15-42P to automatically apply this quirk on boot.

Signed-off-by: Chris Sommers <chris.sommers@icloud.com>
Link: https://patch.msgid.link/20260907182723.2709981-1-chris.sommers@icloud.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -261,6 +261,13 @@ static const struct dmi_system_id i8042_
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire AG15-42P"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-132"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)


