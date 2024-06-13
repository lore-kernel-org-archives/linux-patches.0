Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2678F1411C5;
	Thu, 13 Jun 2024 12:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281507; cv=none; b=iNzD60iz5Q1cA8zAe/DfTIt7QMnfDK2OReeBr5GPqmUjt862J3j2Ix/mqGXWbBSPrDgQd95n0usTr39EtkhIVD2pfnyn1AL8lWqtM5nkRwG+on478ozm35towvpjq6AkI7FD2rzV5IbFz8F+3Y9Mr63USoyGEXx0zzGgNAxa924=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281507; c=relaxed/simple;
	bh=R/EZ5ooGe19W0KUcyapyiHlWZAVz+G6momCxeduBsMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oj8x+bC7CLo1XnM/zyvo4eNuk+/mWFgrIq+P7GQvL4sP6/aBMn8BfHq6VLM9NL2eMzmEFVK9+/p5SU+jtHNHmmYnuj7SUgCNp80Hn1NBuMFWqLcIucq0TRGyytwnIOPa+caO3Ijs0I9zy1M/PJHjh0cSfomLpQz7XH2yWkTRBZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWo4BahK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWo4BahK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34BAC2BBFC;
	Thu, 13 Jun 2024 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281507;
	bh=R/EZ5ooGe19W0KUcyapyiHlWZAVz+G6momCxeduBsMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWo4BahKZ3MTQkiy4XNpb2XCEV449ppG7flaQ1uQMKDFFX1+CTn1EWtvKTJ/O033V
	 F9z9RRza9tEseHK4USAf72vgXR+QbrDb6a7c3JajAG7XGV48t/sjIWWXXYfXlgoAU4
	 gqsx1NmtEm3c5Qb+IAS5F22RpX7c54IgStyGH8DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 279/317] ACPI: resource: Do IRQ override on TongFang GXxHRXx and GMxHGxx
Date: Thu, 13 Jun 2024 13:34:57 +0200
Message-ID: <20240613113258.343438253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit c81bf14f9db68311c2e75428eea070d97d603975 upstream.

Listed devices need the override for the keyboard to work.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -475,6 +475,18 @@ static const struct dmi_system_id asus_l
 			DMI_MATCH(DMI_BOARD_NAME, "B2502CBA"),
 		},
 	},
+	{
+		/* TongFang GXxHRXx/TUXEDO InfinityBook Pro Gen9 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GXxHRXx"),
+		},
+	},
+	{
+		/* TongFang GMxHGxx/TUXEDO Stellaris Slim Gen1 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
+		},
+	},
 	{ }
 };
 


