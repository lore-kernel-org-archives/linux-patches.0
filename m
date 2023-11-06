Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6A200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5yBX+df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E108C433C8;
	Mon,  6 Nov 2023 13:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699275933;
	bh=Q3jEHGEnEMCLXitDUCBx+7HDsKY4tEoFHbUeQ3isBs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5yBX+dffJ+lZOZjm0LCh2GSyszZ1bg7tTo7WOC2B7X2tyLUu3afe0zhFNjoyB7MG
	 NrkycIW562AOeUkb4Qesl5jvK+ja603OUXeEHGRGmFa5uNp3aLQTapPdJNCr2rbsAT
	 OuXo48j736GmpzDWWM/VCY3yos+B70aDlPW9fS8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.14 13/48] perf/core: Fix potential NULL deref
Date: Mon,  6 Nov 2023 14:03:04 +0100
Message-ID: <20231106130258.305286633@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.862199836@linuxfoundation.org>
References: <20231106130257.862199836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit a71ef31485bb51b846e8db8b3a35e432cc15afb5 upstream.

Smatch is awesome.

Fixes: 32671e3799ca ("perf: Disallow mis-matched inherited group reads")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11059,7 +11059,8 @@ static int inherit_group(struct perf_eve
 		if (IS_ERR(child_ctr))
 			return PTR_ERR(child_ctr);
 	}
-	leader->group_generation = parent_event->group_generation;
+	if (leader)
+		leader->group_generation = parent_event->group_generation;
 	return 0;
 }
 


