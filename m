Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D4146C4D1;
	Tue, 21 Jul 2026 15:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648888; cv=none; b=o5QauHPhprsSDSSbY+hMebvFsKOtM7wntD8g+pO+PQikJNRmhtSVpzYdB37I7xmDIvOCtL+Ypcb5dwL4W9iG51L3Wk4uO2eQM8eqcrrfxDYg7+gwez3j0CyGiRmeE7TmP99ASuw+n9SRLnVkHftv975PUYrf2ER+tZjTwXYwSpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648888; c=relaxed/simple;
	bh=bHTHDjnUbVCjLQpUcgIF7Pnq0URmZLR9Vs0df0jcSEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu+A/APAc3vM/nt6SQs8+yVXCz6IJIz7pQlLKY+Hko428Y37IKdeSz5SsiUEr8hqwUhyDsra3RPByp79aqPAvUj9KExRGJNDP2HjvfKsi+V70gmjWSuKdaO5MD5lagD4M+TwELBIBnTPtNqjOmCDZNyFVQ3e2V2MkyxwAVzOD8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4zdx7at; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4zdx7at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F0B1F000E9;
	Tue, 21 Jul 2026 15:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648883;
	bh=4EjHACqJ1zyrguC9XlbG01FyduTqC4H1ZlysOWxKNdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4zdx7atRqieJbDLdRmkHYCl9U94vTbb7l1N1pzUJ56bPvWwHpN2EFK2QdAutUOYM
	 BvVn/DVOQ1vxvdO5x45r5j3plYcD5MSA5kWtoAQY4OEanhwne1ITgPFd8ua/2RnaWL
	 eFZOc3Rc703CrsVZqSexec9uDBrs9BGxsFQJtrXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0314/2077] driver core: Fix missing jiffies conversion in deferred_probe_extend_timeout()
Date: Tue, 21 Jul 2026 16:59:47 +0200
Message-ID: <20260721152600.083664002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f9e6da99fe49277979798a1c3b9790ae10aaa18a ]

mod_delayed_work() takes jiffies, not seconds. Thus, restore the dropped
conversion.

While at it, fix incorrect indentation.

Fixes: 1137838865bf ("driver core: Use mod_delayed_work to prevent lost deferred probe work")
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260525012340.3860581-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 3523a5d8ec5030..6ced7272b97e3c 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -324,7 +324,7 @@ void deferred_probe_extend_timeout(void)
 	 * start a new one.
 	 */
 	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
-						 driver_deferred_probe_timeout))
+			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
 }
-- 
2.53.0



