Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DEA13AA55;
	Tue, 27 Feb 2024 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042124; cv=none; b=Se9TNAZFq9gw0paXv34EDqCsWG2Ur5ceQ6LiHoQiwY35D1JRZGu9IuCTE4SkfsyzcwUmKE24RuNvuikKeGycQqyKRe104ttdnupTF9jBWJn0pnYrVmAgMtDuZY0XFHmn0XEcdFhdMDCUYKTTjLB+rRlxOytqSRfTzhXoHYkViwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042124; c=relaxed/simple;
	bh=uVqjvABWR6SrMUtKij+VIVevZwLr/rd559aw9tX8WOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXg1X0obP6eB7ir0MG1IJscDlbc8qItRIuVHFQsCQ41rpxRtWsd3tigMhpI+ZhOjw+b/E0qZAFh+CGl7o7XaUqPHcFYKSCJR38M11R93G6XgPg8rQdxyca8x0v0HuDo+D7MgHebqGIe5NZSOFWkBxkGRz1RZHgFitrLtmQxfUx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jID8VYAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jID8VYAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0171BC433F1;
	Tue, 27 Feb 2024 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042124;
	bh=uVqjvABWR6SrMUtKij+VIVevZwLr/rd559aw9tX8WOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jID8VYARWyWay+5JIV01oeiNmF9CqDlTpp0KZzKhgLizod6xlaRH74pw50Kbx6wut
	 +geaSL8wm7stj5SCAXbn/Tw0b1/CiJtaF1oLqMb0pvr/nA5V1t652D6X9aUETS25/n
	 AOwMvN9HgxsPEtZpWbH/ImKksB4PM98MrnhpQRtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	=?UTF-8?q?Jonas=20Sch=C3=A4fer?= <jonas@wielicki.name>,
	Narcis Garcia <debianlists@actiu.net>,
	Yosry Ahmed <yosryahmed@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeelb@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 160/299] mm: memcontrol: clarify swapaccount=0 deprecation warning
Date: Tue, 27 Feb 2024 14:24:31 +0100
Message-ID: <20240227131631.009790249@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 118642d7f606fc9b9c92ee611275420320290ffb upstream.

The swapaccount deprecation warning is throwing false positives.  Since we
deprecated the knob and defaulted to enabling, the only reports we've been
getting are from folks that set swapaccount=1.  While this is a nice
affirmation that always-enabling was the right choice, we certainly don't
want to warn when users request the supported mode.

Only warn when disabling is requested, and clarify the warning.

[colin.i.king@gmail.com: spelling: "commdandline" -> "commandline"]
  Link: https://lkml.kernel.org/r/20240215090544.1649201-1-colin.i.king@gmail.com
Link: https://lkml.kernel.org/r/20240213081634.3652326-1-hannes@cmpxchg.org
Fixes: b25806dcd3d5 ("mm: memcontrol: deprecate swapaccounting=0 mode")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reported-by: "Jonas Schäfer" <jonas@wielicki.name>
Reported-by: Narcis Garcia <debianlists@actiu.net>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7613,9 +7613,13 @@ bool mem_cgroup_swap_full(struct folio *
 
 static int __init setup_swap_account(char *s)
 {
-	pr_warn_once("The swapaccount= commandline option is deprecated. "
-		     "Please report your usecase to linux-mm@kvack.org if you "
-		     "depend on this functionality.\n");
+	bool res;
+
+	if (!kstrtobool(s, &res) && !res)
+		pr_warn_once("The swapaccount=0 commandline option is deprecated "
+			     "in favor of configuring swap control via cgroupfs. "
+			     "Please report your usecase to linux-mm@kvack.org if you "
+			     "depend on this functionality.\n");
 	return 1;
 }
 __setup("swapaccount=", setup_swap_account);


