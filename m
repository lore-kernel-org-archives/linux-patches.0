Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383611DE89A;
	Tue,  8 Oct 2024 13:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392473; cv=none; b=ad9PJt+cgrdCKNoRVkK3KBZAYMk64SxfzoOW0/pemCuBllfrLIt/slchZJxFhe12jbpaD6/TKKVTqCotcVvjL7ZCljlpvQMg+ObT5MlOXtTbY26q9Jy4uH5kUogYNhQ21JA3Jm33GY/pW/J/iX8MJRUpmMF6eRy7Cqw36igdHsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392473; c=relaxed/simple;
	bh=+0WG6J+UasL0rUT7UcWN0cBXicSbXd5ly30hBt+wy/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVkF8Ekt8BKo8ljN1yWU8IMmn/+spMnVHGYZbUuD3V5KD5GFzpDaeBjGe9Xj5S9zgk0OifjxZuV79EF3yLQNj8zCCFrztDtN5IQuwasKwfCaCi2VY6H21/l6+Bpln3OLDUMDvqmyVvcsxsMbZc4MuK0K9XuGvrNV/eY3hC1s/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+a7B2vS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+a7B2vS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1565C4CEC7;
	Tue,  8 Oct 2024 13:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392473;
	bh=+0WG6J+UasL0rUT7UcWN0cBXicSbXd5ly30hBt+wy/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+a7B2vSLkBshhejn8xmllvADJ7sMdR42NKBRAKZ8+tA+1KtCv2Tef9pSUC0lNSGD
	 fWvFiQDcF3iL2RyjCn30b+fVIHL/ezNuvHW64+he0A3d4hJpV/GCTnChkQqvvVE7iR
	 QI0TGgVOLFpSHkuY9LyHHQzDLpUEvUe62MtD+7M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 6.11 426/558] sched/deadline: Comment sched_dl_entity::dl_server variable
Date: Tue,  8 Oct 2024 14:07:36 +0200
Message-ID: <20241008115719.037928248@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit f23c042ce34ba265cf3129d530702b5d218e3f4b upstream.

Add an explanation for the newly added variable.

Fixes: 63ba8422f876 ("sched/deadline: Introduce deadline servers")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/147f7aa8cb8fd925f36aa8059af6a35aad08b45a.1716811044.git.bristot@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -639,6 +639,8 @@ struct sched_dl_entity {
 	 *
 	 * @dl_overrun tells if the task asked to be informed about runtime
 	 * overruns.
+	 *
+	 * @dl_server tells if this is a server entity.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;


