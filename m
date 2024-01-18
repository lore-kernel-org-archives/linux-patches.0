Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C87B23762;
	Thu, 18 Jan 2024 11:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575727; cv=none; b=UQrgCMPczICLZuyekOPIakdaR8rdiLNT9MgMENgJEjSJrLP8UWb+4x/gjjAiQjsMSCQ8+E/215tsIj5aZJtYS1OzWC9mkF/r6HaHGG790pb21sLEIOmH9ciatyfGFcSPB1f53C/EsY15LaLFJnxAXHbIhgO/Z2swLtP4XjM4VnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575727; c=relaxed/simple;
	bh=rlXAz6gX6kaLK4NGXbOD+30sZ+lPT2VtpCheUk9fzmE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=uKUwO1faMMgrc6MWI/VxJBuPQe7CP4FZumj/oTxIqVaDd8h8+m71d0D6zmoJhdQQrZbiyB8svcQiavWVdwguGwcJ6Xb3rHrYiJP4j8fJ9a0VosF1xlZCwesbutNOnCAE1ABjOJj3rwFwS25EaVl0dy6Vf2klrjXK5coNebChtR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDGGIXoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDGGIXoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FB0C433C7;
	Thu, 18 Jan 2024 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575726;
	bh=rlXAz6gX6kaLK4NGXbOD+30sZ+lPT2VtpCheUk9fzmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDGGIXoQ5zwQgP5JYddmTFDMEfCD4nJqKKOi2w/eLC0ln6kjjszMH/kCRNH1z5kOf
	 Jm1utJmqNWRVIhqzADmFopyeqgb7ym6wzNG9UF1q5bXYFuiQxtS00FsM/nlJFvSBlJ
	 n0YcWlvpPOImMHka3Y/1rpVDTgL6FnemPnANwWD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Acuna <ldacuna@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 083/100] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Thu, 18 Jan 2024 11:49:31 +0100
Message-ID: <20240118104314.508958533@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit df0cced74159c79e36ce7971f0bf250673296d93 upstream.

The TongFang GMxXGxx, which needs IRQ overriding for the keyboard to work,
is also sold as the Eluktronics RP-15 which does not use the standard
TongFang GMxXGxx DMI board_name.

Add an entry for this laptop to the irq1_edge_low_force_override[] DMI
table to make the internal keyboard functional.

Reported-by: Luis Acuna <ldacuna@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -513,6 +513,13 @@ static const struct dmi_system_id mainge
 		},
 	},
 	{
+		/* TongFang GMxXGxx sold as Eluktronics Inc. RP-15 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "RP-15"),
+		},
+	},
+	{
 		/* TongFang GM6XGxX/TUXEDO Stellaris 16 Gen5 AMD */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GM6XGxX"),


