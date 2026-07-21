Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132343B1EFC;
	Tue, 21 Jul 2026 21:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671195; cv=none; b=LpsLw6MzPPLAnrML9OwC5zWYfsTYqUbszwn0AUuYsxP3EFTlFRcVeZu0PGim1uQxRgcTzyuxiJrgvmWVG/3AFrIRyUy0FEHG+IRLINK9d+iNCR6EmgEBCUKbbwwliwtGhjfBf/vKImaZEX1CHqXLCWfpj9hCqKXdQMdOwmB/nng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671195; c=relaxed/simple;
	bh=HTvgtPMs66ZKY6vWmt42ggbydP720+ukHJ0qlkfytQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2EJNXIJQfBxP/PGBrpTeJIn1bCpzCOt4E1U/OhZ2NHtQ4O6ohqOK81hHxD7lzPp9Skcj40+Mgowd4Ira+rcQSaO49F17oWu6mPsPWL7lYTjE9WZPnU0iNzHs8/3YRlvn7tACFXyo0fop1JvIuCl7n5jGR3x6O7uYoVicBrE5O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6bRwKQ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6bRwKQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF6D1F000E9;
	Tue, 21 Jul 2026 21:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671193;
	bh=tN0aUXigU6ENcaapV0jo+GKKw+s0dZyhfsIh4CQnTms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6bRwKQ/eENsUbG2E1beBbV/tB4tObPA0RyzGRc3MYW9YIiZOu/PAwuggbckHVpLR
	 nGD4mqDe4WSw0X4fkeHYrgCJDk9ucq2N+ZeO4exUMt6AwnX1IIIUdXUP163Jqt0c6a
	 tn+CkjHCMmmtXgN6Yk1ja7ayOViYuOHNjEgvh03w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Madhu M <madhu.m@intel.com>,
	Jameson Thies <jthies@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 154/843] usb: typec: ucsi: Pass full DP config payload in SET_NEW_CAM for DP alt mode
Date: Tue, 21 Jul 2026 17:16:29 +0200
Message-ID: <20260721152409.477721762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhu M <madhu.m@intel.com>

commit 735a461d060d4eeb2f9732aba1295bc32a3982e2 upstream.

In the UCSI Specification Revision 3.1 RC1, bits 32-63 of the SET_NEW_CAM
command hold the 32-bit Alternate Mode Specific (AMSpecific) field.

For DisplayPort Alternate Mode, this field must contain the full
32-bit DisplayPort configuration VDO payload that the OPM wants the
connector to operate in, rather than just the pin assignment value.
This AMSpecific value follows the DisplayPort Configurations defined
in the DisplayPort Alt Mode on USB Type-C Specification v2.1a,
Table 5-13: SOP DisplayPort Configurations.

Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Madhu M <madhu.m@intel.com>
Reviewed-by: Jameson Thies <jthies@google.com>
Reviewed-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260619153311.3526083-1-madhu.m@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -185,13 +185,12 @@ static int ucsi_displayport_status_updat
 
 static int ucsi_displayport_configure(struct ucsi_dp *dp)
 {
-	u32 pins = DP_CONF_GET_PIN_ASSIGN(dp->data.conf);
 	u64 command;
 
 	if (!dp->override)
 		return 0;
 
-	command = UCSI_CMD_SET_NEW_CAM(dp->con->num, 1, dp->offset, pins);
+	command = UCSI_CMD_SET_NEW_CAM(dp->con->num, 1, dp->offset, dp->data.conf);
 
 	return ucsi_send_command(dp->con->ucsi, command, NULL, 0);
 }


