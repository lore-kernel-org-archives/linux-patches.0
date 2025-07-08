Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3272E6D18;
	Tue,  8 Jul 2025 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994051; cv=none; b=gdbpQWvW2Nz+TDH1iSVQdsFmbt79lUQiy2xGi+Kj7mz5m5gpnynTmiRct/kOsBDZeOBejpMkCnFwX9d5MlZpCURjd9npkWVOM/bykRDLzMSvOKUymm3FWCVXl4O0k4S/F9dTjW+kowPdYnzCNUgzwznkDMaP6hpP1fVEXGinJhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994051; c=relaxed/simple;
	bh=tCXH9pODovt9iAfdQ50vkL6GNumcdZuWuUqea9f9PXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tk74/BF/kSyuW3/WwUFyGL7Li6C5oEzi7FLU3Mi5PLAOJkTVh38907QOGCYQXfIs1hatQVuT5/P9wKYbkfkL6/sgPJvvlFJNYRM/pLFrgoFI1LEcp7Q9RGQv0zahQ9sachlUTmCyvKyeFhO/gI0w39oePLXRYxbAv2b/lYia0yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qP7JG/SI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qP7JG/SI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87280C4CEED;
	Tue,  8 Jul 2025 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994050;
	bh=tCXH9pODovt9iAfdQ50vkL6GNumcdZuWuUqea9f9PXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qP7JG/SInLE5Ne5HxMYwCNaAovzML4QtjE62Uu1dAJjdQJltaPK2WkcEXng80/Qr/
	 gcsikMzRWkiGXn7bAzXamt1fXzOSOAf/A3a7EjB0lYeRzpkUpXEYIXPqeuoujRlh2P
	 rD3VL+huum82aAEg7hnoNx9slKas5qzCuECG384g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 101/160] usb: typec: altmodes/displayport: do not index invalid pin_assignments
Date: Tue,  8 Jul 2025 18:22:18 +0200
Message-ID: <20250708162234.293244470@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -503,7 +503,7 @@ static ssize_t pin_assignment_show(struc
 
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


