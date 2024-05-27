Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E803F168C4;
	Mon, 27 May 2024 19:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837753; cv=none; b=GrGc6jmP2Iteu0EFBa5eWLtK+CpoF85LXX9W5ABAIod9NOWz2tKzW06tkich/JCRXx/j9PHDitfaAO3w7mpTtDuAvmJ3Fa1tlyYroZO4THcg7Pr2TuKCUy8KpGpI0d1+SFjq4QTfXiF7c8PhKcIj3OIzIq8gDQdnFhjD1lCQgJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837753; c=relaxed/simple;
	bh=7wTLt4E0dXym+IvTR3by1l7I9L3daHsjSFCmmddb7LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OSNRWBdgxPUvUtCVLwXhdFh+2LU+Zcat3N+PxFOp2WQh2KxqnrHTMSMLlUbV+5dYIgHKES6x5Y5gv3flanh+9YS4fkMUhNbqdmKl+JmxfccpmzzV4eotpCYlxltmCKB2A6jlrH3vFh9RtrLT2EQ70sWJSv65N9OzDT0NEMEzAyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpZQ9fzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpZQ9fzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0ABC2BBFC;
	Mon, 27 May 2024 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837752;
	bh=7wTLt4E0dXym+IvTR3by1l7I9L3daHsjSFCmmddb7LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpZQ9fzGJZwXtYf/pw86GyhZbCYpOtiSbQmhBMH1yfqztJax1wZViNN0HJesWcbKy
	 2qyOOUE6OQ400paeJEsPqA01oMh5DsY/xj6uA60GGvS1FB9puff1iozpPZr3x1Qybd
	 mrIu+bhovh7/rCwnArLuvHwzW0L0TCQtxOyHuo7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 091/493] Input: amimouse - mark driver struct with __refdata to prevent section mismatch
Date: Mon, 27 May 2024 20:51:33 +0200
Message-ID: <20240527185633.362352378@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 0537c8eef4f699aacdeb67c6181c66cccd63c7f5 ]

As described in the added code comment, a reference to .exit.text is ok
for drivers registered via module_platform_driver_probe(). Make this
explicit to prevent the following section mismatch warning

	WARNING: modpost: drivers/input/mouse/amimouse: section mismatch in reference: amimouse_driver+0x8 (section: .data) -> amimouse_remove (section: .exit.text)

that triggers on an allmodconfig W=1 build.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/2e3783106bf6bd9a7bdeb12b706378fb16316471.1711748999.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/amimouse.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/amimouse.c b/drivers/input/mouse/amimouse.c
index cda0c3ff5a288..2fbbaeb76d708 100644
--- a/drivers/input/mouse/amimouse.c
+++ b/drivers/input/mouse/amimouse.c
@@ -132,7 +132,13 @@ static void __exit amimouse_remove(struct platform_device *pdev)
 	input_unregister_device(dev);
 }
 
-static struct platform_driver amimouse_driver = {
+/*
+ * amimouse_remove() lives in .exit.text. For drivers registered via
+ * module_platform_driver_probe() this is ok because they cannot get unbound at
+ * runtime. So mark the driver struct with __refdata to prevent modpost
+ * triggering a section mismatch warning.
+ */
+static struct platform_driver amimouse_driver __refdata = {
 	.remove_new = __exit_p(amimouse_remove),
 	.driver   = {
 		.name	= "amiga-mouse",
-- 
2.43.0



