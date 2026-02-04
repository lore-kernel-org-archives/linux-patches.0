Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0D5219301;
	Wed,  4 Feb 2026 14:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216595; cv=none; b=RW0FJ3qF/aSf1Q6fmU+9oGrZqhJw+g+2ImXrPgIiBwQpueSLgPTN2jx/O0Nz3W26iyakVRvsh2WvHgoRQH63B8aEGA56mTAiDtCXf0pzXxQ5hRLbZxT7oD3pKYwrMNMYzFifzN785cAoshinA1HYIhxmhcSiQywfx5VCWl7M928=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216595; c=relaxed/simple;
	bh=lD1go5YAY6Wx9EIKHaVYu2tQhzB4sNx4P5ypkkLzMj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etWdq0heUqc8jjQLXD/ABNgv3fMj+/HiymKXoZyyo4bHjl9DnBqzwHAVGxMgXVPmLieQkD3kBwIYuWdZdZni9bBc1RN2SOuXonCNoPDTQqERmitPMNHl+wnJDVDO5XamD8fDt+M2QrpXyaFhvno8FyBexHoRpjtVFUNHoe1N6kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvvUy3h7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvvUy3h7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F2EC4CEF7;
	Wed,  4 Feb 2026 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216594;
	bh=lD1go5YAY6Wx9EIKHaVYu2tQhzB4sNx4P5ypkkLzMj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvvUy3h7fAKtQb4H+53GOqoYSRjjuNnvKw+0SGDvpsOcCro+TVdLO+yG32VRIbXDi
	 i5tULjYAKLS2LqfHHzlhVAe+zraPzWQA2RgoeNOBTZOKkVVJhgouM3E/r8smSCY2Sn
	 u2teCkw0HksD6kvR8uMRwx+x3QvClAoNOtzeCJe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 133/161] net/sched: act_ife: convert comma to semicolon
Date: Wed,  4 Feb 2026 15:39:56 +0100
Message-ID: <20260204143856.527080591@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit 205305c028ad986d0649b8b100bab6032dcd1bb5 upstream.

Replace comma between expressions with semicolons.

Using a ',' in place of a ';' can have unintended side effects.
Although that is not the case here, it is seems best to use ';'
unless ',' is intended.

Found by inspection.
No functional change intended.
Compile tested only.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20251112072709.73755-1-nichen@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ife.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -648,9 +648,9 @@ static int tcf_ife_dump(struct sk_buff *
 
 	memset(&opt, 0, sizeof(opt));
 
-	opt.index = ife->tcf_index,
-	opt.refcnt = refcount_read(&ife->tcf_refcnt) - ref,
-	opt.bindcnt = atomic_read(&ife->tcf_bindcnt) - bind,
+	opt.index = ife->tcf_index;
+	opt.refcnt = refcount_read(&ife->tcf_refcnt) - ref;
+	opt.bindcnt = atomic_read(&ife->tcf_bindcnt) - bind;
 
 	spin_lock_bh(&ife->tcf_lock);
 	opt.action = ife->tcf_action;


