Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABECD13F016;
	Tue, 27 Feb 2024 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042853; cv=none; b=GydZ4ADORH1jAqY2MLu1GSrmBACT9OYka1Urwx/54WNmKbzDLNPoUK6vGWrLjP3CgEEPOrQd31PIQ+iC/xbdF5vrTCFNNJZ+lr6DrCgrFHVWAZ76VuUfx6Fbt60vOR27a87ofYbWn8P5mtIsVRfrVFFQ3+NXyJPYuFN7kguM2r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042853; c=relaxed/simple;
	bh=ucKthrS9X2vlxxQfCsYLQZScdzOtoquD30f3iwbCO10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxylB5+27YHcpYnBnqxODhKOrB6J/7lrwWEeE9+QgKHRiyG/SA8smcl/ZIld5jlCnslXzRnNdzIGYcpx0vQZGVpRsntUUAbqNkzgTGkNubx2FAM+zBz2Av2GkDXrgtWlWJhofBTaIWZquga4D0NOhzG7bZQOL93OimBJ9g+xzIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz7+yj4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz7+yj4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAF6C433F1;
	Tue, 27 Feb 2024 14:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042853;
	bh=ucKthrS9X2vlxxQfCsYLQZScdzOtoquD30f3iwbCO10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz7+yj4Ge7xrdIL+09c+WUqAqCD/qzua0ZNW4vck7uNlkJrgm6oe37n+0xmI/w26Y
	 r8MEkDkn4M16EnzwCoRg5MRsb5bhGoGjtutlNRV0SMuyPQzQy1CZXc9m5IKqwXxnEs
	 8WegF8hIqF0oZpRTRLKWMaF3b83551xXAatCg3A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <suhui_kernel@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/245] kernel/sched: Remove dl_boosted flag comment
Date: Tue, 27 Feb 2024 14:25:32 +0100
Message-ID: <20240227131619.901896504@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <suhui_kernel@163.com>

[ Upstream commit 0e3872499de1a1230cef5221607d71aa09264bd5 ]

since commit 2279f540ea7d ("sched/deadline: Fix priority
inheritance with multiple scheduling classes"), we should not
keep it here.

Signed-off-by: Hui Su <suhui_kernel@163.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Link: https://lore.kernel.org/r/20220107095254.GA49258@localhost.localdomain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7bfc2b45cd99b..9b3cfe685cb45 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -608,10 +608,6 @@ struct sched_dl_entity {
 	 * task has to wait for a replenishment to be performed at the
 	 * next firing of dl_timer.
 	 *
-	 * @dl_boosted tells if we are boosted due to DI. If so we are
-	 * outside bandwidth enforcement mechanism (but only until we
-	 * exit the critical section);
-	 *
 	 * @dl_yielded tells if task gave up the CPU before consuming
 	 * all its available runtime during the last job.
 	 *
-- 
2.43.0



