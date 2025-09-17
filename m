Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA885296BCC;
	Wed, 17 Sep 2025 13:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114124; cv=none; b=eT0/+QpBf7csJxzQsck80+R7O/SYJrH8Hm3IssqvlRjA2i9/mY1tQjd7KQNHOWpd+10XU/NH07guV42s9S/aNVf/yO8Yn9DeAkxfnuLrLd48lj/ioaLdQY4/dqIAW/s2fU00Moh6IIh0liABDCt9Cm3Fz9bnwXLhHEc8t8c+WGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114124; c=relaxed/simple;
	bh=P2GjAKDCJJablRkGzxm6xae9PqW326BCJTcjrv9nr0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQbL0ckxAPaP7FxBH3OqTfTodisEwvb4/goVS88RomOjXKtwaeBNrDRzmbcKJMjWPX+DuNa7W2zvAsnhAwmbI+SL6aNgngyw05ODs9htb6s56Mtyv3EjpLo8Ut9CcYBOLiu0F6lZ6FE2sO7O4rPuMN9eY59MXo4Naejvk8CWUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alRrG3Lb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alRrG3Lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E369EC4CEF5;
	Wed, 17 Sep 2025 13:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114123;
	bh=P2GjAKDCJJablRkGzxm6xae9PqW326BCJTcjrv9nr0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alRrG3Lb/5VFtdJAMLqUI1aAEKuxElyziOzzPFiR9VYGwthMIBza45YmPNm0xTcmA
	 xazn7uJWdJjMN7yL8Fm7aEqqLhFa1GaoPoQlUMwAUKDorcsUvO5oGZTMi9Gxu/cP9C
	 rDpYEIFOHVKJafb8ac+upDfVKdrZpMmSAKrEb5VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Tran <alex.t.tran@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 53/78] docs: networking: can: change bcm_msg_head frames member to support flexible array
Date: Wed, 17 Sep 2025 14:35:14 +0200
Message-ID: <20250917123330.860834716@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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
index ebc822e605f55..9ac6d3973ad58 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -740,7 +740,7 @@ The broadcast manager sends responses to user space in the same form:
             struct timeval ival1, ival2;    /* count and subsequent interval */
             canid_t can_id;                 /* unique can_id for task */
             __u32 nframes;                  /* number of can_frames following */
-            struct can_frame frames[0];
+            struct can_frame frames[];
     };
 
 The aligned payload 'frames' uses the same basic CAN frame structure defined
-- 
2.51.0



