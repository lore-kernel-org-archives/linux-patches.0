Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DBE323408;
	Wed, 17 Sep 2025 12:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113484; cv=none; b=ekdw9BKSHmR89hdwB+8ljbBEjqTGc5Elsd1TKLpMOyP0EkVc3cBIlhl1mYFlQbFA9zW2N9wRGvghbXIgOcqvdDdDcP0hMelevU8sN8Uv2Oy4cUHy3l7u1y1uG5y1d5VX2MKaXmLoqBkzFLf68QMfmn8D+j4VJ3EFyfCHXTvIFP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113484; c=relaxed/simple;
	bh=ige89Y1AQ5SkFSB9xqIEBFD9dBPlGNcSGAwm345ztxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzAykURpZ6DmemAyLJoQq4pG9U+RpP9kT0Dr9i4VehmkWJB+tR9+DIeEvDi3WyaDFRfVA2qzV41//5Ls1SNNVyskL+F5tmxSAxH/bhGKxU7QAIrBO2lcxPGP2okZ6v9GPmt8soWB8AgIVcypitflbICKQDFuJiAZb6fXGnqfpjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZg1hqWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZg1hqWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2762C4CEF0;
	Wed, 17 Sep 2025 12:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113484;
	bh=ige89Y1AQ5SkFSB9xqIEBFD9dBPlGNcSGAwm345ztxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZg1hqWI6gxd6WTpEWSKfbdmLIZPyeh7dhKEOkmubiFIs3wwwBoZwPYci48facKjJ
	 n/Szdu3rCIZogDpQJPsVhfEFn0g7uRaXs9Hegmu73XpBlN8OcAGr5dV8Ah3HemqAcR
	 ScWXIDGzC9uwAUc3bSvKtmTyrkk0CHmS3e/dOPwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Tran <alex.t.tran@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/140] docs: networking: can: change bcm_msg_head frames member to support flexible array
Date: Wed, 17 Sep 2025 14:34:32 +0200
Message-ID: <20250917123346.746926538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 62519d38c58ba..58cc609e8669b 100644
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



