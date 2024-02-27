Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACA013B790;
	Tue, 27 Feb 2024 13:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040972; cv=none; b=HZVp5SgryvVeJH/+CMns/nU0roK6U3XgILEfA7anRmUV7OJaOpW3cAKqgpjSL35XLM0mFbZ/Xsv/14KKI+PayVOi87keEYlj8MmbgNeFByDa9oLdvKrpiw2IH89sR9iTrX3J3dsl/8O6CtofiP4AGVFroM2RAsuCtj5hrUDBhqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040972; c=relaxed/simple;
	bh=S8yfdpaTn4VouWA+FP06M6hARDjKYwjdtLBUz6CIPbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mo3s2V2exhVPhf+xu8ooAhpMrujkGoWmK5d1JkiRdvXhK2fwwtZE+kbgIJuCy2CGex9UFoSk5zhdA55gB+63Mp54YVoEHFKnBKLxW4ISR2fGHsS0m3RZqUqF+8TdGoMOUkfOmU0ytRqdzu8PDukrc0nK7SSwbjepr6/HblsicqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikFqf6Uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikFqf6Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9110C433C7;
	Tue, 27 Feb 2024 13:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040972;
	bh=S8yfdpaTn4VouWA+FP06M6hARDjKYwjdtLBUz6CIPbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikFqf6Uva3ZqrjLOKox0s9KiyMMg4GhLOfXpdJZF8lLki9JQAw5wFUPnAClB2dCif
	 WufqVT/h2nXE2MAl/CGZoQUnlV6JuDyd4Rcr+Q2zfeMhL4TPddUVOhH/+HKMf48Zgw
	 NMHPgRj7oiTmxSCxZBm+h4ss0NJfx+4o7fyb7fmg=
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
Subject: [PATCH 6.7 173/334] mm: memcontrol: clarify swapaccount=0 deprecation warning
Date: Tue, 27 Feb 2024 14:20:31 +0100
Message-ID: <20240227131636.129546768@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7905,9 +7905,13 @@ bool mem_cgroup_swap_full(struct folio *
 
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


