Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0DD33592B;
	Wed, 17 Sep 2025 12:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113957; cv=none; b=CauKgLFcvqKEEt3lvcu3ztvV6lOqm62aetrg0l7jJ/u6MGW5fgAfXZGkl067CGuZlxds1Kc6v4t96UOL7Ww0Cy/dmJbKXFjSp4s5KSywi1ccKPssVEHFJfUimOgekOZ9Hiux37qQV2b9RP2bowniha6e3LJ8ECtrFbsqcy5xrWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113957; c=relaxed/simple;
	bh=/DMrBEVkt98kLGt26a1gMl8BFsaH60dyKwpZNhzdVi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJp3B5F8wVFixp3ZBhuv6Hft30x/idU/tjKyHnp5f3DQAgjZFnfscQpxEUqA2BXPo+qQZ4B6Y3xlCbNxSNPMlsQTDj3eI5tcQPT81HpCPPHv2hflXa/g3mSSoNnxRieb2C5Wc+aKs55++zRmmL/qP29kzJ0LzWJMzZkHVsrTPpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3QAH3Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3QAH3Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FB3C4CEF0;
	Wed, 17 Sep 2025 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113957;
	bh=/DMrBEVkt98kLGt26a1gMl8BFsaH60dyKwpZNhzdVi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3QAH3Za9SBz0uZQeFrhrITeyhVl93CpN33PcN520Ddv9FHRa5nAkhJyrg1AI5HF1
	 Nvkav0ene/Vr1pA2x1ZY/ZKXtGuVPwno85DNSEf/O2jKhNQa06eYe2W6MN9iKacbJz
	 U+tm1jZ6qjVwP7PPkwUiM6kqmlLDZxGMG153TxpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Tran <alex.t.tran@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/101] docs: networking: can: change bcm_msg_head frames member to support flexible array
Date: Wed, 17 Sep 2025 14:34:54 +0200
Message-ID: <20250917123338.556907318@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d7e1ada905b2d..3bdd155838105 100644
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



