Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4434BEEBA;
	Thu,  3 Jul 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556244; cv=none; b=Y0YiHaVvTk1C+bZTR1axVleDQZDkLdx9YBRxrhFJkZyT+jNP8hOfDOHJB+Wjg5K19LyYNJtbu8u2V0zmcpV/k88DNnAUZz6rCbRiLeTsLrEC3mgnkZZrv/Qq9s3MwAoRhEr1NMvx60mq6xRwBnzJn7+B7FaSBQr2VfYY0S9mVlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556244; c=relaxed/simple;
	bh=e2GCdM/oHTmA74AVNrAZU5RpgBWXePgEb3Xs70Mu4J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGQ0vsV+2eDKGhaSGrInIkXRajrPgkRNM906r7FJ6WUuKFUR0K9zoVlpc/B1JOZq+4gVkXp7VAqLx1nAGnY8sHVaBQ+82UWMeJa/hwUAzpTESbOYL8ubAklj0h4njTwRkP8JwyJMr28k6AyZuFgsBbYvJOmjrWp9CMivI4Ntzo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnlzWDqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnlzWDqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4766C4CEE3;
	Thu,  3 Jul 2025 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556244;
	bh=e2GCdM/oHTmA74AVNrAZU5RpgBWXePgEb3Xs70Mu4J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnlzWDqhGxBF8P7TyinnXUBwiNnjF4MIN23JKzAjc//xHl1tYcf7iV3Rx7sG+mUFd
	 D7marYZrYyEWs6x6EOViSHZzFk8k1GxvBxCw/q6SFoWaFA2QAW7nXRosNYGe21PCXi
	 7/SCx3awcAYUK300xiVvQT3QpugXCaWemdYaSKm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 119/132] fbdev: hyperv_fb: Convert comma to semicolon
Date: Thu,  3 Jul 2025 16:43:28 +0200
Message-ID: <20250703143944.060484180@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

commit 27f22f897095b09df32bf689b63624d23b0c8ebc upstream.

Replace a comma between expression statements by a semicolon.

Fixes: d786e00d19f9 ("drivers: hv, hyperv_fb: Untangle and refactor Hyper-V panic notifiers")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hyperv_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -1217,7 +1217,7 @@ static int hvfb_probe(struct hv_device *
 	 * which is almost at the end of list, with priority = INT_MIN + 1.
 	 */
 	par->hvfb_panic_nb.notifier_call = hvfb_on_panic;
-	par->hvfb_panic_nb.priority = INT_MIN + 10,
+	par->hvfb_panic_nb.priority = INT_MIN + 10;
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &par->hvfb_panic_nb);
 


