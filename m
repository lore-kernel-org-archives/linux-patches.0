Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6025118A6CF;
	Wed, 17 Sep 2025 12:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112999; cv=none; b=t0v7Jj2HFzQaeoG4b3gZBx/1B3AJ1cTSpElRtlL/3g4eoMltbBa0H+Z8KnuOfKiRULQkCAAQ+i9to/5u7dVt3BU/jdeBmZgeO9CX39O60gqKf69qDrAZPcGGAwO0w+UqE+GOersqSaBcyA9R4zwZK1M4dTD2jArGSgBenCBEHho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112999; c=relaxed/simple;
	bh=4VZuPhg4GnxTIAj20x32TN4G7DnLuIQqQyXqcsYMQ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KazC4fTzITCCaIIa3SnYXm2p8Z9HKdLNqspyNAkrL7K/RSkiCMLNI288aCF8bU0o/gAAFS86NBvEgExdVjNywUwyPpXu+XeCwr9BYDmGxhakqXoglN2+OcK3rLEbgCCr3UTbfqIqt8NDyMY2kgLHD7saBWLCtH0VdiuNp3XjezE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsrXZ1bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsrXZ1bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AD8C4CEF5;
	Wed, 17 Sep 2025 12:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112998;
	bh=4VZuPhg4GnxTIAj20x32TN4G7DnLuIQqQyXqcsYMQ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsrXZ1bv2LwznRlubZGFZ/uB6bQE2CRtbOLVLNYZFz9e8PVXvfsuMf31VfpQoB4Nk
	 /qfW4Hnscbxm2gPK1ce04i9fhgrPBUwDqSIjfwrZtKjf7M7ze922IPZq/F8VKjdgKa
	 Qr8M90Jm+CJn46EVnFOisRLffY/w/NftoJut6lkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Tran <alex.t.tran@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 139/189] docs: networking: can: change bcm_msg_head frames member to support flexible array
Date: Wed, 17 Sep 2025 14:34:09 +0200
Message-ID: <20250917123355.258709256@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Tran <alex.t.tran@gmail.com>

[ Upstream commit 641427d5bf90af0625081bf27555418b101274cd ]

The documentation of the 'bcm_msg_head' struct does not match how
it is defined in 'bcm.h'. Changed the frames member to a flexible array,
matching the definition in the header file.

See commit 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with
flexible-array members")

Signed-off-by: Alex Tran <alex.t.tran@gmail.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20250904031709.1426895-1-alex.t.tran@gmail.com
Fixes: 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with flexible-array members")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217783
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/can.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
index b018ce3463926..515a3876f58cf 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -742,7 +742,7 @@ The broadcast manager sends responses to user space in the same form:
             struct timeval ival1, ival2;    /* count and subsequent interval */
             canid_t can_id;                 /* unique can_id for task */
             __u32 nframes;                  /* number of can_frames following */
-            struct can_frame frames[0];
+            struct can_frame frames[];
     };
 
 The aligned payload 'frames' uses the same basic CAN frame structure defined
-- 
2.51.0



