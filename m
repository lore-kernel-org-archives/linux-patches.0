Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E4C47CC6C;
	Tue, 16 Jun 2026 17:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630904; cv=none; b=Qgn8MBD0tJZqxepSe+w0n0lhcA0ZkMINQFV1KBBtiH/TGtG+Xf0IGIkUzQGHrYRji24X/D/GLw4BEh12UhvU+xGoTeA3ncIT/oUAU1CxzvdtT/fV0KjrZ6QaHrELkvPqYkeHM3hDmyg8KEDpJo2NtWM97AeJCdBeUOhHGiTHADM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630904; c=relaxed/simple;
	bh=CGnNxVuaxxW67+UDLtp69/ru5GKBW/mROMDJyZw70OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUaDAPvr6NVRcO5tVCjJWMfl/bR2lgbdmylIKtd/zPCQfFGZzMsyGCqU0E9M/7HNykS8OstZhAJ7JQOH+V3+ya2CQq4stWT/GEY9Vb0pR2eYf47GVV+5KWfhM+vuYSo86k/rlsti+BZat1tJuwVQO+c5wO2EHIQXgzYpny6PCF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+wybfwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+wybfwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E491F000E9;
	Tue, 16 Jun 2026 17:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630901;
	bh=+XNkSsCU/is+UMNmRhxYyua19BV3+Y/10QziHF8/uZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+wybfwNBOAfcqbVl44CYTUz2xFOENM4/NPRez18kwKWz1jOc3Y1qLSQY42+Ni/Lf
	 jAX1wnvpzRuu0UbgeBpYaPxJcGwUeSxN613aCDbGUyYaxWGfTSSCfJ4sClDliNN6wv
	 rlRzLOVkj2A13Ez8h/NCXE26YrUeinCUE5gAlWLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.1 101/522] USB: cdc-acm: Fix bit overlap and move quirk definitions to header
Date: Tue, 16 Jun 2026 20:24:08 +0530
Message-ID: <20260616145130.650458212@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Wentao Guan <guanwentao@uniontech.com>

commit 5eb070769ea5e18405535609d1d3f6886f3755bd upstream.

The VENDOR_CLASS_DATA_IFACE and ALWAYS_POLL_CTRL quirk flags added in
commit f58752ebcb35 ("USB: cdc-acm: Add quirks for Yoga Book 9 14IAH10
INGENIC touchscreen") were placed inside the acm_ctrl_msg() function
rather than in the header with the other quirk flags.  Then, their
values (BIT(9) and BIT(10)) collided with NO_UNION_12 which is already
BIT(9).

Move the definitions to drivers/usb/class/cdc-acm.h where they belong
and shift them to BIT(10) and BIT(11) to avoid the overlap.

Fixes: f58752ebcb35 ("USB: cdc-acm: Add quirks for Yoga Book 9 14IAH10 INGENIC touchscreen")
Cc: stable <stable@kernel.org>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Link: https://patch.msgid.link/20260522091357.1301196-1-guanwentao@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    2 --
 drivers/usb/class/cdc-acm.h |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -113,8 +113,6 @@ static int acm_ctrl_msg(struct acm *acm,
 	int retval;
 
 	retval = usb_autopm_get_interface(acm->control);
-#define VENDOR_CLASS_DATA_IFACE		BIT(9)  /* data interface uses vendor-specific class */
-#define ALWAYS_POLL_CTRL		BIT(10) /* keep ctrl URB active even without an open TTY */
 	if (retval)
 		return retval;
 
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -115,3 +115,5 @@ struct acm {
 #define DISABLE_ECHO			BIT(7)
 #define MISSING_CAP_BRK			BIT(8)
 #define NO_UNION_12			BIT(9)
+#define VENDOR_CLASS_DATA_IFACE		BIT(10)  /* data interface uses vendor-specific class */
+#define ALWAYS_POLL_CTRL		BIT(11) /* keep ctrl URB active even without an open TTY */


