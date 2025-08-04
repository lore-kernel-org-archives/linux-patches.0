Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC04429A2;
	Mon,  4 Aug 2025 00:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267324; cv=none; b=gwdPvLOr/lQZc3mAhtRCJqtvWUJcvrJ9l1a5/P7iImi0dM4vLmy5aj6GbefxP5sp40aaAkJt/85BpQ/VnmeqnzYjYegmTUQjwqcqeH5Vrp5h1Xd32MoyGuxNEKP1HJmIEGqUJTHb+jdI2h8jEaKwBdP4ZaMx1FoSBfI6CS7YSek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267324; c=relaxed/simple;
	bh=tV8mOr2kNygU7VxJZSE6t/MNb+JDz0pMHgh4pTga0Ms=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PDXHR+P1K4+npA9+6904dacjC9ME+4eLRXQDRC93bXeRaVqx7fg88ME20hdMdvL7RYLI/fZ9k7vUilaulToIhh5pCzpXfhFlMfDpqjgPLXIu6XSNW/ghnPQCKQe/HoCSnYVeSlkayUZlmXykIIQzhRbLBQFXa6FDT1D0UtWLUsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYf57zXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYf57zXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0023BC4CEEB;
	Mon,  4 Aug 2025 00:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267324;
	bh=tV8mOr2kNygU7VxJZSE6t/MNb+JDz0pMHgh4pTga0Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYf57zXtYd7IRjILSUwucwLAUdlYlIpK9cWqML5+xOOopNgHlggSsIoI/yJyTCoH0
	 DN3UPIbjJ2MolQRwMTqeoswRIxYeuMmVNhbmk7PnlYmFU90gTes3INNDOSGdEOLBZh
	 lihWrecqEuCuir4a8gHKB7Ai+lyjgKOgIRVblMU8sKTw46WUSa3//AxIQ9lq4kYTJN
	 4oU3T7Ovt0ZeCSJAjJ6ZXh1Ayg93yW9nsXaXhMxoRgBzMxy3eMPyAbk+kGGJ6Mwk1x
	 Io948BCj1o9yBohaaCNKq4yOXAS1C0btsFFrjXOYoan6brW7r4RyvM3+vN8MvdjO02
	 kHngp/DOeekhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	abhishekpandit@chromium.org,
	ukaszb@chromium.org,
	akuchynski@chromium.org,
	chrome-platform@lists.linux.dev
Subject: [PATCH AUTOSEL 6.15 19/80] usb: typec: ucsi: Add poll_cci operation to cros_ec_ucsi
Date: Sun,  3 Aug 2025 20:26:46 -0400
Message-Id: <20250804002747.3617039-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: Jameson Thies <jthies@google.com>

[ Upstream commit 300386d117a98961fc1d612d1f1a61997d731b8a ]

cros_ec_ucsi fails to allocate a UCSI instance in it's probe function
because it does not define all operations checked by ucsi_create.
Update cros_ec_ucsi operations to use the same function for read_cci
and poll_cci.

Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250711202033.2201305-1-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I understand the timeline:
1. The cros_ec_ucsi driver was added on 2024-12-31
2. The poll_cci requirement was added on 2025-02-17 (after the
   cros_ec_ucsi driver was already in the kernel)
3. This broke the cros_ec_ucsi driver because it didn't have the
   poll_cci operation defined

**Backport Status: YES**

This commit fixes a regression where the cros_ec_ucsi driver fails to
allocate a UCSI instance during probe because it lacks the poll_cci
operation that became mandatory in commit 976e7e9bdc77 ("acpi: typec:
ucsi: Introduce a ->poll_cci method").

The commit meets all criteria for stable backporting:

1. **Fixes a real bug**: The driver completely fails to probe without
   this fix, preventing ChromeOS EC-based UCSI devices from working at
   all. The error occurs in ucsi_create() at
   drivers/usb/typec/ucsi/ucsi.c:1933 where it checks for the presence
   of all required operations including poll_cci.

2. **Small and contained change**: The fix is minimal - it only adds one
   line to the operations structure (`.poll_cci = cros_ucsi_read_cci,`),
   reusing the existing read_cci implementation which is appropriate for
   this driver.

3. **No side effects**: The change simply allows the driver to pass the
   operations validation check. Using the same function for both
   read_cci and poll_cci is the correct approach for drivers that don't
   have the ACPI-specific sync issues that prompted the poll_cci split.

4. **Fixes a regression**: This is fixing a regression introduced by
   commit 976e7e9bdc77, which itself was marked for stable. Any stable
   kernel that includes 976e7e9bdc77 but not this fix will have a broken
   cros_ec_ucsi driver.

5. **Clear fix relationship**: The commit message clearly identifies the
   problem (ucsi_create fails due to missing operation) and the solution
   is straightforward.

This should be backported to any stable kernel that includes both:
- commit f1a2241778d9 ("usb: typec: ucsi: Implement ChromeOS UCSI
  driver")
- commit 976e7e9bdc77 ("acpi: typec: ucsi: Introduce a ->poll_cci
  method")

 drivers/usb/typec/ucsi/cros_ec_ucsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/ucsi/cros_ec_ucsi.c b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
index 4ec1c6d22310..eed2a7d0ebc6 100644
--- a/drivers/usb/typec/ucsi/cros_ec_ucsi.c
+++ b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
@@ -137,6 +137,7 @@ static int cros_ucsi_sync_control(struct ucsi *ucsi, u64 cmd, u32 *cci,
 static const struct ucsi_operations cros_ucsi_ops = {
 	.read_version = cros_ucsi_read_version,
 	.read_cci = cros_ucsi_read_cci,
+	.poll_cci = cros_ucsi_read_cci,
 	.read_message_in = cros_ucsi_read_message_in,
 	.async_control = cros_ucsi_async_control,
 	.sync_control = cros_ucsi_sync_control,
-- 
2.39.5

