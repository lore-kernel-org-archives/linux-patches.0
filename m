Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA313064B9;
	Tue,  2 Sep 2025 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820463; cv=none; b=oOpgz98QnjySiGuvv6ZKmwSjx3Bq23KE7200zqsLgUQiWZxcjTXt8G2u6Vgd7pWzJHWFFXLGAyfy9fI93kDvs3R+iCZwj2x9shFzeK3IEh26/J89TycbtLjdsIW/Qp0Jb/5C8ZleHGplKq6XNWufO99QQyY+wd3NeSOOJ1P9+Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820463; c=relaxed/simple;
	bh=kRBus/PHdRMNVUO1I5GYu1dUg3IXXrcdrvfjuIuqt/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbw5npE0ttywkf0i1n4+HVybOjxSPYwJ/Dh2JZNxz3iP1Zy9g8VzE0t8/pENTcc+DX7o5SZhDZDbrg6quGtVS+E7w3G7Sz1mjgkyV0CFalm2mqXk/0zELKCnRgV31xa8jF8X2ODRiTMjW9iBK/vzZORVHvvfUg0HIeN/ra/H2sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPcL3VcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPcL3VcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DB9C4CEED;
	Tue,  2 Sep 2025 13:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820462;
	bh=kRBus/PHdRMNVUO1I5GYu1dUg3IXXrcdrvfjuIuqt/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPcL3VcHrUyAdvcAzFTv08U/SGDBwj/+d1tdCVVWl7qkCjNf7CyBe5XcPXIgHqzCi
	 lyxG9tqVjAelf2JAlkdxyDRbRm9p3gWIK8A+pQTmY3UH1rO97geUN5HGz4PBwtChXg
	 ufVYSDpxaJU1Gf+6KBq2W5U76lkfRt7UvyES8hhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 09/50] ACPI: EC: Add device to acpi_ec_no_wakeup[] qurik list
Date: Tue,  2 Sep 2025 15:21:00 +0200
Message-ID: <20250902131930.883589324@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 9cd51eefae3c871440b93c03716c5398f41bdf78 upstream.

Add the TUXEDO InfinityBook Pro AMD Gen9 to the acpi_ec_no_wakeup[]
quirk list to prevent spurious wakeups.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20250508111625.12149-1-wse@tuxedocomputers.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2288,6 +2288,12 @@ static const struct dmi_system_id acpi_e
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		// TUXEDO InfinityBook Pro AMD Gen9
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GXxHRXx"),
+		},
+	},
 	{ },
 };
 


