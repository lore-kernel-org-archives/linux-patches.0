Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526D61DE8AF;
	Sun,  7 Sep 2025 20:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277198; cv=none; b=JTOi5WY4x4iy0/KUaIxCrqHitnU91no2uZY23DBl6ESKR2+t4nJ163OQ1hshSDGITaa8lNCcgZ7W+o8YWzZpP0j0MneDvIIiFqttvXFXyY22zxgAFG6dYRg1sY7byfL1pfzy2EK4lHL8RodDxfFtLxgAN22RO3/O434eIpOHOS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277198; c=relaxed/simple;
	bh=jSsjJfJpVzDNoFybEsdKCSl2zSwsHOc5PDbWe7lF3dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W7Z/5CV11NlCrQQkqY8ycYfq1wEiJHQzqBUJOVAX3XPHbNxz1TQRIskTG+BRDG80X+MFYIA1B02MyxZZtGCtv2uhgOBwcXG2X+3gsH4uNCuUaicYVXa9tq35ZOPVpGrF9pClorE97wUqC/c+c0Ch8bLkj0I5h8Q3IskIVNLITew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pq+pN79v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pq+pN79v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC78C4CEF0;
	Sun,  7 Sep 2025 20:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277198;
	bh=jSsjJfJpVzDNoFybEsdKCSl2zSwsHOc5PDbWe7lF3dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pq+pN79vR/Tz1bz7auMllO17Ig8wdIeSllmAEXgtwe915unzBh5LlpBs5LULdp++p
	 S2a2sJU4hwUlKOT8r3BiwM4Jzrmt5aUibbfbYsU/mjEoLGpMQWLQKJE+VQIklPzr96
	 nkpxgQlclKLm+gEHK9/YaVhFy2OIlxGujRC547YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 115/175] platform/x86/amd/pmc: Add TUXEDO IB Pro Gen10 AMD to spurious 8042 quirks list
Date: Sun,  7 Sep 2025 21:58:30 +0200
Message-ID: <20250907195617.578507467@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Christoffer Sandberg <cs@tuxedo.de>

commit c96f86217bb28e019403bb8f59eacd8ad5a7ad1a upstream.

Prevents instant wakeup ~1s after suspend.

It seems to be kernel/system dependent if the IRQ actually manages to wake
the system every time or if it gets ignored (and everything works as
expected).

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250827131424.16436-1-wse@tuxedocomputers.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -242,6 +242,20 @@ static const struct dmi_system_id fwbug_
 			DMI_MATCH(DMI_PRODUCT_NAME, "Lafite Pro V 14M"),
 		}
 	},
+	{
+		.ident = "TUXEDO InfinityBook Pro 14/15 AMD Gen10",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "XxHP4NAx"),
+		}
+	},
+	{
+		.ident = "TUXEDO InfinityBook Pro 14/15 AMD Gen10",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "XxKK4NAx_XxSP4NAx"),
+		}
+	},
 	{}
 };
 


