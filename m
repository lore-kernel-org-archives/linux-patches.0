Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52463D39B
	for <patches@lists.linux.dev>; Sat, 20 May 2023 21:39:13 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-561f201a646so63153437b3.1
        for <patches@lists.linux.dev>; Sat, 20 May 2023 14:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684618752; x=1687210752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=skIbHQXL89xTcGXjMUySFNmB7v0Lz7PRThViE6J7dUY=;
        b=XOhjWMQCujbQihpjnwMiF/SfmTXnOhr/Ys+ogxPguM/2oUktHMtmWjf0aUhcRyzCBh
         /kEz89yUIxWvTiuBpO6/Wjfh6R5quIC8RrwBjsMz56N1Y2yK9n3Cj9SRiHdx2dwl6IxK
         Le1AiISUDlsAWmd2yStz5460GT9pE4x2v1mY830nZULv4KAUzKO4xLF0NpKPOt7W9XFZ
         cvTCRVOpI2oh0KmGEIhbI/RnUkApGY6MlYpTXol3S0DG9VxNlofkeMqz3w/mMlc8bNhg
         +g6lwMsJQn6eGGP2hsP/o91kkTkhD689u5GWS8emvFQWY54mktJXLQtS/S2hKgd91VrV
         8TgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684618752; x=1687210752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=skIbHQXL89xTcGXjMUySFNmB7v0Lz7PRThViE6J7dUY=;
        b=A8Nh4RtEAkk3lsheRDTlaXtFHuju8PAUOxVHqX3HfqIerf01KtDFt1v4V57AG+M8ro
         lcxThTuSkfTG5LGvR5IzDEjuYTNviXQWECghVyXcO+GkBXmxEQsC0dbb8RfWVsXqVeOm
         kPRnvGNdLLz6vc0P9gBX3CSJ3mNeN8T/YQFE3/V2tjqMw6km8UGHIc00rfNGqevClDxH
         CQK72w10fatododHTFcK2HQdyp6XXcL56RJkAzF1czKU3tRVN42sqjFyA5XCNKPBfslz
         iOzHSuoqjAVUXHW+sucmK0OmK8Aag1gwjKre9/s58BuC5yoIWoj4FVBZIVOd78Hk+KSP
         L5mw==
X-Gm-Message-State: AC+VfDzLDG227UQF02LgKcYX+/pWEeKjTJqeFBewYEBSacpYS619q2Mz
	myh7cNN1Xr+6d7vhmTWzUxpxcc5l+vTg
X-Google-Smtp-Source: ACHHUZ5NT94sAhhBSYkBg9+aQOzjs7EaWrlC4HRCrVmXKqfpsmVjx6ZkufUyOOHq8ozbnDIs1+yqYhmL4bo5
X-Received: from gthelen2.svl.corp.google.com ([2620:15c:2d4:203:988d:5c18:d518:3f0b])
 (user=gthelen job=sendgmr) by 2002:a81:ad50:0:b0:559:f89f:bc81 with SMTP id
 l16-20020a81ad50000000b00559f89fbc81mr3705340ywk.6.1684618752673; Sat, 20 May
 2023 14:39:12 -0700 (PDT)
Date: Sat, 20 May 2023 14:39:10 -0700
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230515161736.775969473@linuxfoundation.org>
Message-ID: <xr93jzx2el8h.fsf@gthelen2.svl.corp.google.com>
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
From: Greg Thelen <gthelen@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.10.180 release.
> There are 381 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.180-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:

[...]

> Baokun Li <libaokun1@huawei.com>
>     writeback, cgroup: fix null-ptr-deref write in bdi_split_work_to_wbs

Sorry for not noticing this sooner, but I think there's a benign issue
in this backport.

v5.10.180 commit 2b00b2a0e642 ("writeback, cgroup: fix null-ptr-deref
write in bdi_split_work_to_wbs") contains:

+static void cgwb_free_rcu(struct rcu_head *rcu_head)
+{
+       struct bdi_writeback *wb = container_of(rcu_head,
+                       struct bdi_writeback, rcu);
+
+       percpu_ref_exit(&wb->refcnt);
+       kfree(wb);
+}

[...]

@@ -397,7 +406,7 @@ static void cgwb_release_workfn(struct work_struct *work)
        fprop_local_destroy_percpu(&wb->memcg_completions);
        percpu_ref_exit(&wb->refcnt);
        wb_exit(wb);
-       kfree_rcu(wb, rcu);
+       call_rcu(&wb->rcu, cgwb_free_rcu);
 }

Notice there are now 2 percpu_ref_exit() calls. The upstream, and 5.15.y
patches remove the cgwb_release_workfn() calls to percpu_ref_exit(). The
5.10.y fixup is below. It's not essential but might be worth applying to
track upstream.

From 416e0e8ab5ff41676d04dc819bd667c6ad3f7555 Mon Sep 17 00:00:00 2001
From: Greg Thelen <gthelen@google.com>
Date: Sat, 20 May 2023 12:46:24 -0700
Subject: [PATCH] writeback, cgroup: remove extra percpu_ref_exit()

5.10 stable commit 2b00b2a0e642 ("writeback, cgroup: fix null-ptr-deref
write in bdi_split_work_to_wbs") is a backport of upstream 6.3 commit
1ba1199ec574.

In the 5.10 stable commit backport percpu_ref_exit() is called twice:
first in cgwb_release_workfn() and then in cgwb_free_rcu(). The 2nd call
is benign as percpu_ref_exit() internally detects there's nothing to do.

This fixes an non-upstream issue that only applies to 5.10.y.

Fixes: 2b00b2a0e642 ("writeback, cgroup: fix null-ptr-deref write in bdi_split_work_to_wbs")
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/backing-dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b28f629c3527..dd08ab928e07 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -404,7 +404,6 @@ static void cgwb_release_workfn(struct work_struct *work)
 	blkcg_unpin_online(blkcg);
 
 	fprop_local_destroy_percpu(&wb->memcg_completions);
-	percpu_ref_exit(&wb->refcnt);
 	wb_exit(wb);
 	call_rcu(&wb->rcu, cgwb_free_rcu);
 }
-- 
2.40.1.698.g37aff9b760-goog
