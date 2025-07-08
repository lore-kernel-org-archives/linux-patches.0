Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233A51DF74F;
	Tue,  8 Jul 2025 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991975; cv=none; b=VivFJuY53aCZMLhZdiK+yjHtY2cSekoUHSuMl3vCDiXo7vQhVLjkHK/WxWjb8q7R9YMxUFfQsNWpPytI69dowHySuTsRvHH25baGvyPkDBlA1VrBYKm+2v4EfPVNmUoZBr/PLt6iZlEDInxf1/GtY7++qUeniV3j2w1M59cq2Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991975; c=relaxed/simple;
	bh=VAnsWC2V4FwWN3Zpy6gDE8zF8UElV7sgcLYFNvYJAMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUFaFKTjZxik+F91OFsYgHK4KV32GELWur3/PhW73jQVh+pD980yB+YSpvy/Z+s2eO7YY918/+PXq7P6q3Czl/ovjbTmfJ/FWt8zqBsvufUa0rD5jk3KIaY18N8FfWtJktzLgcNeKsg0LLzyysd4yRj+f4ZvgGmVkrvyPclG16g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLfewZPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLfewZPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA7BC4CEED;
	Tue,  8 Jul 2025 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991974;
	bh=VAnsWC2V4FwWN3Zpy6gDE8zF8UElV7sgcLYFNvYJAMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLfewZPJMUwAedyCUltg4owWPjk01d68VNJIDoKyRjA8GfuLj5+V1F+WdAqU6wqsR
	 zi2FoUuJLIs3ExvDqIWPixqBbQsmAm3IO1LmRvIDwytrzxfd5rrz83Ya2CJRq44g8K
	 Jl7Q58ipeFqMZ8j+LEPuPojdzj9STUjOB9utBOc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 11/81] usb: typec: altmodes/displayport: do not index invalid pin_assignments
Date: Tue,  8 Jul 2025 18:23:03 +0200
Message-ID: <20250708162225.202908916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

From: RD Babiera <rdbabiera@google.com>

commit af4db5a35a4ef7a68046883bfd12468007db38f1 upstream.

A poorly implemented DisplayPort Alt Mode port partner can indicate
that its pin assignment capabilities are greater than the maximum
value, DP_PIN_ASSIGN_F. In this case, calls to pin_assignment_show
will cause a BRK exception due to an out of bounds array access.

Prevent for loop in pin_assignment_show from accessing
invalid values in pin_assignments by adding DP_PIN_ASSIGN_MAX
value in typec_dp.h and using i < DP_PIN_ASSIGN_MAX as a loop
condition.

Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
Cc: stable <stable@kernel.org>
Signed-off-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250618224943.3263103-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    2 +-
 include/linux/usb/typec_dp.h             |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -525,7 +525,7 @@ static ssize_t pin_assignment_show(struc
 
 	assignments = get_current_pin_assignments(dp);
 
-	for (i = 0; assignments; assignments >>= 1, i++) {
+	for (i = 0; assignments && i < DP_PIN_ASSIGN_MAX; assignments >>= 1, i++) {
 		if (assignments & 1) {
 			if (i == cur)
 				len += sprintf(buf + len, "[%s] ",
--- a/include/linux/usb/typec_dp.h
+++ b/include/linux/usb/typec_dp.h
@@ -56,6 +56,7 @@ enum {
 	DP_PIN_ASSIGN_D,
 	DP_PIN_ASSIGN_E,
 	DP_PIN_ASSIGN_F, /* Not supported after v1.0b */
+	DP_PIN_ASSIGN_MAX,
 };
 
 /* DisplayPort alt mode specific commands */


