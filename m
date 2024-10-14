Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82B414AA9;
	Mon, 14 Oct 2024 15:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919538; cv=none; b=lSZqjgFx3Jdvy+nqUDvJ8OfSPSpLJXeESBS5A7LYWKNytd5/D9gnhCf0C6nabGU4jbW86lRoh/pkxYXFD9Lx8HQ8v6AuxJNnUjjFR5E3qDaFubFaFapzxegQLDNrQfXW8ST3ODPmRW2wk0Y7qEvppbBUPJGi0tBFURzzsvJ0pJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919538; c=relaxed/simple;
	bh=P0oFhWYA9EP2EuH9rrmipOMbzhuvJ1zISw3YRZub26c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHjrMWxfGi82GVm04v1gJlro4Q6Nw/cp1xkhNi3Tuei2syFw347zxZehVJXyzucuoZe2Tb914iDkNm1vKcQKZ5hk00Rpsmm6D+Amsva17quYnnZEOjTR/5334mvY1mtPw/6SQIYA8A1Hzi0tNu6h7JuCBBpJ/mkqaXaXLP0zISk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5OPeUnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5OPeUnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CD0C4CEC3;
	Mon, 14 Oct 2024 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919537;
	bh=P0oFhWYA9EP2EuH9rrmipOMbzhuvJ1zISw3YRZub26c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5OPeUnqGKP1B7qJ+iRDvX4sKM2J0qLOSbzetDRuHj8cYOSfGF8Y5iI7s70s+xLbV
	 6/2Z6OM+HWguqpqZo/zy639sdlyjOKOoFeEnhK+APYwoG68wbhq0Ev/2+KzAOnmywm
	 XkNyNEbY8qU/hg/lh2TX6H2fVYCKZdCoDaPntLBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 603/798] ACPI: resource: Add Asus ExpertBook B2502CVA to irq1_level_low_skip_override[]
Date: Mon, 14 Oct 2024 16:19:17 +0200
Message-ID: <20241014141241.700698057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

commit 056301e7c7c886f96d799edd36f3406cc30e1822 upstream.

Like other Asus ExpertBook models the B2502CVA has its keybopard IRQ (1)
described as ActiveLow in the DSDT, which the kernel overrides to EdgeHigh
which breaks the keyboard.

Add the B2502CVA to the irq1_level_low_skip_override[] quirk table to fix
this.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217760
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240927141606.66826-4-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -514,6 +514,13 @@ static const struct dmi_system_id mainge
 		}
 	},
 	{
+		/* Asus ExpertBook B2502CVA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B2502CVA"),
+		},
+	},
+	{
 		/* TongFang GMxXGxx/TUXEDO Polaris 15 Gen5 AMD */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxx"),


