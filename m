Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A75E26981A;
	Tue,  8 Apr 2025 12:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113935; cv=none; b=ZfW1ykX0WjOBOuDEqHe149m+G+hAhRxiOMxVbTri7HX0Kb92MAip4e/dhFi/VK4UHM92CYd0UGY5yVKeoSCo2FIcgZfiPQcJkdkiYFWjyWcL0/5fIYKsqH3Dz5PuO1v/l1NHttW4pWGcgUQ6kmpj2GgqDLWwEdJGVGt9SpTl8i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113935; c=relaxed/simple;
	bh=CNTgS/93Rv7MpNitHWTkj0/Pa7fC8liVf1flgHEDjMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cg72yBtKprarShAacy2YgLD/aStZV+o4EocsRfxpVMABuScDbynQFoJsIWI6v/kTu6H7Zoe6NMGeS0IfdBL3eLQbwEZLJJszoM+7fItqWHIrjfsmaQV/rbi47ebWHFCCDQq2i/EJ9g9pM0eUqK4bV6OqvDt2drv24heLBPAW09M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9d7rOwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9d7rOwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794F8C4CEE5;
	Tue,  8 Apr 2025 12:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113934;
	bh=CNTgS/93Rv7MpNitHWTkj0/Pa7fC8liVf1flgHEDjMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9d7rOwtk/1JCg9wA+6Fgrz5FfdveDIB/Sn3orWcWqzDwyp9bE+ClyxRyR/ySz4fT
	 rQGlfb/Ilb9Qz9tNcFpfyrpZuOOv5S4VbNUQPOQfKCg7b/1MRUppuNlDAk4XOwOlPd
	 oYMdbkcZkQBd7XkIMhlmOGjk8OTefg9BoASde/jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gannon Kolding <gannon.kolding@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/154] ACPI: resource: IRQ override for Eluktronics MECH-17
Date: Tue,  8 Apr 2025 12:49:27 +0200
Message-ID: <20250408104816.104963660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gannon Kolding <gannon.kolding@gmail.com>

[ Upstream commit 607ab6f85f4194b644ea95ac5fe660ef575db3b4 ]

The Eluktronics MECH-17 (GM7RG7N) needs IRQ overriding for the
keyboard to work.

Adding a DMI_MATCH entry for this laptop model makes the internal
keyboard function normally.

Signed-off-by: Gannon Kolding <gannon.kolding@gmail.com>
Link: https://patch.msgid.link/20250127093902.328361-1-gannon.kolding@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 2750518a5d5e1..11264bb4061e7 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -482,6 +482,12 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "RP-15"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "MECH-17"),
+		},
+	},
 	{
 		/* TongFang GM6XGxX/TUXEDO Stellaris 16 Gen5 AMD */
 		.matches = {
-- 
2.39.5



