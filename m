Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D2F15B10D;
	Mon, 28 Oct 2024 06:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097113; cv=none; b=DKWN/gjUQvdxWvURMlKaAg5zEMWu8TcSWBrdmInrb2ZuAybGgWyQGrdyG9JMKp1iT8m40if6sz1tUCeukdBCJgubdLI/YQtHo9I7yQKEXKXtsAG3TnUkkR90LFYpoIh8JO7B44B9rY9YiC7pHSwxFqxY9u6NSO0q4fS/uU8yrLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097113; c=relaxed/simple;
	bh=1o3Um/3Z7OL/2b5+/P6zKyqYPXrCEjd1AGKtkAulcPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhA73hlD87bI2Frid+A4ra2O6k2mmz0H66FT59jUyMMK9ydjMRQ5OQDGtF7a0S1gtIy/3gwZLoPHrbAo87feGjMWB28YF7jaL44lOB+LodAezIGYHaRGoG0CiJu+70mIjj5W+qJq7EJUhe9d2VK//pSidIcu8CRTWb2og+NH1Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6TI8KoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6TI8KoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CBEC4CEC7;
	Mon, 28 Oct 2024 06:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097112;
	bh=1o3Um/3Z7OL/2b5+/P6zKyqYPXrCEjd1AGKtkAulcPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6TI8KoQ229PiZN52sFtFcNQKPDmy9l2Z5jOKEfCyyUWgW4MjzZLwGn2Y3oWR/Grd
	 Fe2PX4gwSlGGjCvcBAoi2zdDY4dZSvbbuIcufe4BerjihFdHO2lcjFz7MYuTqkV22+
	 EzG2hOMIFi23P7dvSCSp+X3hjTuw0g2t/di5f5cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Holten <dirk.holten@gmx.de>,
	Christian Heusel <christian@heusel.eu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 69/80] ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]
Date: Mon, 28 Oct 2024 07:25:49 +0100
Message-ID: <20241028062254.528167591@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

From: Christian Heusel <christian@heusel.eu>

commit 53f1a907d36fb3aa02a4d34073bcec25823a6c74 upstream.

The LG Gram Pro 16 2-in-1 (2024) the 16T90SP has its keybopard IRQ (1)
described as ActiveLow in the DSDT, which the kernel overrides to EdgeHigh
which breaks the keyboard.

Add the 16T90SP to the irq1_level_low_skip_override[] quirk table to fix
this.

Reported-by: Dirk Holten <dirk.holten@gmx.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219382
Cc: All applicable <stable@vger.kernel.org>
Suggested-by: Dirk Holten <dirk.holten@gmx.de>
Signed-off-by: Christian Heusel <christian@heusel.eu>
Link: https://patch.msgid.link/20241017-lg-gram-pro-keyboard-v2-1-7c8fbf6ff718@heusel.eu
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -505,6 +505,13 @@ static const struct dmi_system_id tongfa
 			DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
 		},
 	},
+	{
+		/* LG Electronics 16T90SP */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
+			DMI_MATCH(DMI_BOARD_NAME, "16T90SP"),
+		},
+	},
 	{ }
 };
 


