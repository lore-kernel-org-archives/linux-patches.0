Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F7336A004;
	Thu, 16 Jul 2026 13:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209827; cv=none; b=S2Xo8MEsZwfrQZ8+HBK/W98vYTGDUgUH3MenZZdvJKi6cgnT4e7iZUZ3uJPe3bEl6wWllUtGP81KmIyHs5TcgDEZYV7/sTu/vTFIw9VjK74VNVRrjkmC10dCu3qhXkB4tClVAxBv3lMQx0yppFQ5YuxiOD6NGylyZV0InY75Yjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209827; c=relaxed/simple;
	bh=LIL5j2XsjK6+5EnqHVgPtBEyjHqPYHX1PB8zlHr3bsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqYd7fIwKilKqwzFLgEzyi106yWOl+1nm1Ot4Uqqj2T6/w4VNT/borJIPkIruVVIFLFZhTeY3dN9ElRHXoVud6B1p0mL8yoGX0LPNbl1rkEZfDO0H40inIeKIdT5namAdbL4ZFyEO1KIbUP7VNP007pPLM9kOuS5IXk8XeXwljo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXrdtiI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXrdtiI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706FE1F000E9;
	Thu, 16 Jul 2026 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209825;
	bh=+DISx7e9Hxh/nI7S3onu97XCkV+3r3/nnANBriiPoxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXrdtiI5HGs2KTroYBUO/FhRj0Z+b3yBA6fpbkAAyHgwkb/AEyNtB8nswZCAxnJ8p
	 0gsgJBMMhinzBDdg4p2+RI3fdhZd2HRZXG5bSzzPr/nefagYYRiHapTdOreUW4j8pg
	 gKA+S+LG+6mZunw8NjV+jqmg5J700ewhegQOaW3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Madhu M <madhu.m@intel.com>,
	Jameson Thies <jthies@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.1 333/518] usb: typec: ucsi: Pass full DP config payload in SET_NEW_CAM for DP alt mode
Date: Thu, 16 Jul 2026 15:30:01 +0200
Message-ID: <20260716133055.096736916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


