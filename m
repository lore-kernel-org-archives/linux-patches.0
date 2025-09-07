Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAE14315A;
	Sun,  7 Sep 2025 20:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277806; cv=none; b=ks+wXvRBTXx6e7B8WvvKxtfByimnQ6t1FXJmYp5Dy1L2UMZg0+rjW+zpiMYDazxe5V4p6VfTRjvGyKy5yKmUwveAYBQHQE3BckGiOTvQozZKoYu4UNC7aj9+I5OV9D6O/5AVsN9tT9W0VzKX7vB1zYGZxMVv0F+0xZPgdizztLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277806; c=relaxed/simple;
	bh=Fq1YAtOVNvFDh7pQpVWB5eqgH74YgkBOcsOGig7b+hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7MbZPLIXTLH5yIvYTZf1istyJInhPVt4cZinAoA1uOFogGpYU1R1Cz0tyq0bYsF/fbi6xcpnKDLTtthlRUOCqvLwKBzkfBTRMFeYtEXva0k7rpL3PRpiU7pf+x9zLKHognIr+KqceBHAnNInP+x6aZFBiXj7IJm6SpNgn1OWFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ru/NGEse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ru/NGEse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB14C4CEF0;
	Sun,  7 Sep 2025 20:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277806;
	bh=Fq1YAtOVNvFDh7pQpVWB5eqgH74YgkBOcsOGig7b+hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ru/NGEseOluMg9tVTfp9ip0nuzGSV/EMkSEAXUMh/mKhb8NXCubXHfA/H0YXeIYhC
	 xbd0tFUcfvqRwyJc7pFOvFuyUKxvE05UWMluf5KIHZVV5Jg90Z+P9/MY9TszdnZTBp
	 mlmETEo0rHMO4oqxfTU7rWpViDiz3MAXmM1S27/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.16 130/183] platform/x86/amd/pmc: Add TUXEDO IB Pro Gen10 AMD to spurious 8042 quirks list
Date: Sun,  7 Sep 2025 21:59:17 +0200
Message-ID: <20250907195618.881371173@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -248,6 +248,20 @@ static const struct dmi_system_id fwbug_
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
 


