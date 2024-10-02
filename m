Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5881C9B91;
	Wed,  2 Oct 2024 13:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877127; cv=none; b=gLkIlHo3Mt69dCYjo4f1sJCAyg6fow6zQfYlRRVWELc9ESz5S6oemCYd7suhtCjsa0IDBkSfKGbh39wOe+R4UbH6Zr9tihVx/NNycV8HTBgg68a3CMNveGq5flqrjN0jRSQ5bpr21Uh9ZefFQApRzAsZvTOJwCXrSRHZEVd8zA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877127; c=relaxed/simple;
	bh=naBr1+ZoicO8umEyD4myv/Z4OPMQNaXpjAu9wGrZyfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHy6LE+/4BDX8Wv1Q15f7/+KUisLrabaz54oLM/bnOFf2Qqx2DsmwVjlnCMC2Zm0tyVeGZrKxyTWqjZRgG+dMZgBRCfnZMUKQasreLJ+rdOuFxSMdY02GG/eQLtA3s/hv8Lskluwu7Z31lLWuM5cozjeFZi0aOFRsHcRPGFxyxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1fNNrnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1fNNrnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB984C4CEC2;
	Wed,  2 Oct 2024 13:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877127;
	bh=naBr1+ZoicO8umEyD4myv/Z4OPMQNaXpjAu9wGrZyfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1fNNrnN8FkLpEKunCKhHPU2k99mxwBoSZ+P1gBXwnfuxwjmRoPFg/tpkhezwmblQ
	 3vHeEfowMYI3FcEBQptRiGTSZphIIEO9W5J3A4QqmswoZxdjzpDqFEi5oT5sEr84Am
	 O8KSfOBnyDsWMYbT7V3N3D0a5S8BudSHYiJMpijg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KP Singh <kpsingh@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.11 674/695] bpf: lsm: Set bpf_lsm_blob_sizes.lbs_task to 0
Date: Wed,  2 Oct 2024 15:01:12 +0200
Message-ID: <20241002125849.418760217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Song Liu <song@kernel.org>

commit 300a90b2cb5d442879e6398920c49aebbd5c8e40 upstream.

bpf task local storage is now using task_struct->bpf_storage, so
bpf_lsm_blob_sizes.lbs_task is no longer needed. Remove it to save some
memory.

Fixes: a10787e6d58c ("bpf: Enable task local storage for tracing programs")
Cc: stable@vger.kernel.org
Cc: KP Singh <kpsingh@kernel.org>
Cc: Matt Bobrowski <mattbobrowski@google.com>
Signed-off-by: Song Liu <song@kernel.org>
Acked-by: Matt Bobrowski <mattbobrowski@google.com>
Link: https://lore.kernel.org/r/20240911055508.9588-1-song@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/bpf/hooks.c |    1 -
 1 file changed, 1 deletion(-)

--- a/security/bpf/hooks.c
+++ b/security/bpf/hooks.c
@@ -31,7 +31,6 @@ static int __init bpf_lsm_init(void)
 
 struct lsm_blob_sizes bpf_lsm_blob_sizes __ro_after_init = {
 	.lbs_inode = sizeof(struct bpf_storage_blob),
-	.lbs_task = sizeof(struct bpf_storage_blob),
 };
 
 DEFINE_LSM(bpf) = {


