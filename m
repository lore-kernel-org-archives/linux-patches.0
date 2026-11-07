Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061170;
	b=0dl3rm+Ibo6hccqTg0UvIHF7RfEdFhvwWPOaaEDMh5cONzBZK9TDUKYEdKgeg9quR0f4
	 i/z5xJtj9wv7FUOkVxnC76szzQppRr8PplRck+NS+d1kY5Wf4Jmnz5rfDKv77iD0yAcl8
	 MB3mG3Tn0fZufxuqyCfgoqIGwKKajif7Rs9sQGxCvgDwXP8GZlUAck+3plfrzP+aXx6OZ
	 f0nlbXbcD9ED0siBvJCrw3XM0g4AlR6MDaPJi+ewUQDQdW8ijoVRSDz5XFayfd2MtrOqL
	 86QYHdGWTov/k5wGHumaF9pJ0zwgDPotTQEyqKJeWnoV98rZKQtLRlM/PCNu+Jmb+5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XaKL6IvyoxkYunVVJANL09DHZCG4M8ImxOAJq4Cnxbc=;
	b=Eg2DViL3TaJBXjUrI6PY3fzPl2966gTN2eZvcifW5Ppx+eHlIDKjP01AIjE5ThiCzoh9
	 Gtp4Yy2KKPJDWUO6++GohKBJH6OTtPejkO9k1XR+QP5zYNYUoX00mBrAmlbCIb1qfyMvX
	 S1Xf5vsP/4GNo7WaSGKsFkvHX30qQ84w7kt3uOWGcY78IcihtTxvfv7d4mRe2rO7o0U25
	 twxZHqOESeqpp6kXOACJ5BRWzQ03ZAbOUh31BVdrWlWwdrTBKWjeMnFxRIPfBd/QnVaUu
	 fc90An9ls1es4P37Io6JSLzp3voVGIRULlF+57lNOO5TIkGOaXMr6BO2oq1kjHDwkPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLGhDmeQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A878606A33A;
	Sat,  7 Nov 2026 14:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLGhDmeQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F141F0089F;
	Sat,  7 Nov 2026 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061170;
	bh=XaKL6IvyoxkYunVVJANL09DHZCG4M8ImxOAJq4Cnxbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLGhDmeQcXBGlqu0nN41lTD5E/2m0Oedw0YckiI8MR6jPxGLKZrlA78LEAqc+kvzs
	 oMiWHnNIXnZGv9Rahh5Gt2BMiYZiGDLhoQGBfXThzx8+tNMPwimo6+Dx/QQ6EfnXNY
	 FfOAMq8W4ISatqGIEa2ASZAX6XfSbAnxIQSBesNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keren Sun <kerensun@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0474/1536] mm: remove unnecessary whitespace before a quoted newline
Date: Sat,  7 Nov 2026 08:41:30 -0500
Message-ID: <20261107135010.817057879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keren Sun <kerensun@google.com>

[ Upstream commit 91478b238e584d0ec1ea8c58ef46e4e14d58e526 ]

Remove whitespaces before newlines for strings in pr_warn_once()

Link: https://lkml.kernel.org/r/20241115235744.1419580-3-kerensun@google.com
Signed-off-by: Keren Sun <kerensun@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 45b1ec4887bd ("mm: memcg-v1: fix wrong linux-mm list address in deprecation warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol-v1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 1bad668aa337b..afc9660c9f945 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2020,13 +2020,13 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	} else if (!strcmp(name, "memory.oom_control")) {
 		pr_warn_once("oom_control is deprecated and will be removed. "
 			     "Please report your usecase to linux-mm-@kvack.org"
-			     " if you depend on this functionality. \n");
+			     " if you depend on this functionality.\n");
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
 		pr_warn_once("pressure_level is deprecated and will be removed. "
 			     "Please report your usecase to linux-mm-@kvack.org "
-			     "if you depend on this functionality. \n");
+			     "if you depend on this functionality.\n");
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
 	} else if (!strcmp(name, "memory.memsw.usage_in_bytes")) {
@@ -2884,7 +2884,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 
 	pr_warn_once("oom_control is deprecated and will be removed. "
 		     "Please report your usecase to linux-mm-@kvack.org if you "
-		     "depend on this functionality. \n");
+		     "depend on this functionality.\n");
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
 	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
-- 
2.53.0



