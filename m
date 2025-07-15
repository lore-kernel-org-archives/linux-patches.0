Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652482EBDFC;
	Tue, 15 Jul 2025 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587615; cv=none; b=SBev+V9mDq2Zc2Ydu+QlXWG5SwvNgnl9KjK5DUN/Qedi4qjKBDVvP0kc2GgNisfiWisuaQO0bwptC+NvKaXcFu9b8VltcdM90Lvn/YrAmuo28OrRTIZm9cIYrVA2x2QIhxK8aJWki5XKyXYLyfQMK5d2uTPmOTpzkVoSEkavLFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587615; c=relaxed/simple;
	bh=3H0uedK8OL+2/4K/1gj6gRmAEhr838pFPJyX2MOJDIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeSCbiVWnyxHGZJ8QvU1rKl7uMU+jgsScaAF60yTFzf+5OsVqdLC0ooOUZCYUXnVh9sELYmNFV+dUqm+dfzgKdxXPruFe1o07DuFAaKi9S55Z/+M3X1rV7yWU3nwnp/Bad7hwutV+oWKpAVBSMvsHqpRjQ3L8zv8luU08mQPLWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmH910Zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmH910Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB68AC4CEE3;
	Tue, 15 Jul 2025 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587615;
	bh=3H0uedK8OL+2/4K/1gj6gRmAEhr838pFPJyX2MOJDIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmH910ZdlThyCbOOqA2fAxktQKq9I1gjh801SCL5kEzNwbrZJlDjwwRyBFMfmUIDt
	 9wuS8y5rAMKbjo5vE0PYQfcKfNOT1wxNAvtz5IfGI0rwj3z/ODkFVe1Vv3atYkZap0
	 qvYWLdf1E2qFalP3K73YIqLVzO2Ec/uF7at2DOAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 079/208] usb: typec: altmodes/displayport: do not index invalid pin_assignments
Date: Tue, 15 Jul 2025 15:13:08 +0200
Message-ID: <20250715130814.107365082@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,7 +509,7 @@ static ssize_t pin_assignment_show(struc
 
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


