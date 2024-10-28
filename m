Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254AFA47;
	Mon, 28 Oct 2024 06:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097923; cv=none; b=ZIZNr64BTSJBvTFcGYZJemdXa9ashZMg4LTIYa99QHNCIK6+9pqy57Lmi1AOWJrCmWuR5IoFMQl3hlrB1/mdHuJsi2CQiUzObtbkxth4poWoTerB4J3vU/j4LRYwzyN+9SFFBHs+23jdSX2iQqrpzJWYrFYH6FxLVjtXTo8wvow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097923; c=relaxed/simple;
	bh=euxfLqiVtZXMFwiP95mBjPvQpREVCtqk9P6baGEfP3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgVojTzwi6CHQuGocUg/F7Fx6T8KqdSs30BHRe1/h3mtMwLBXOJbWvp/ROaKOtz1EkOTmlw9fTa9JMQSEYqh37up36MVST0Gr7qaHd96+ZR6ap8XEiVtECTYnDlsD/yw7ectnH0VF1kt4l5vi2pbzj7qPV8+63GUWXVIzbKaXKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1yGKMxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1yGKMxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7906EC4CEC3;
	Mon, 28 Oct 2024 06:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097922;
	bh=euxfLqiVtZXMFwiP95mBjPvQpREVCtqk9P6baGEfP3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1yGKMxbcPJsAcFQ7L9QtEYJjE4VO6eUc5XRcpK3QmHsVjaiTz3327U8MXjYmjbRE
	 ttIMihHPB07gKxKH6vnvb4XhCm3eSzqoICib7vYSgV/zbh7NEO5AykVAFyXIPG4eni
	 GxEvo+SM1SJ/d915J2DDl9HaTGUB/aWH5g29nyHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Holten <dirk.holten@gmx.de>,
	Christian Heusel <christian@heusel.eu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 180/208] ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]
Date: Mon, 28 Oct 2024 07:26:00 +0100
Message-ID: <20241028062311.064774873@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -498,6 +498,13 @@ static const struct dmi_system_id tongfa
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
 


