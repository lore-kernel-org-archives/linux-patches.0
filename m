Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9910F1CCEDA;
	Wed,  2 Oct 2024 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880615; cv=none; b=fL4JKXh8kIB622DJqdnvgyMf8vuJ8fbDKp+WAbeRT+hAo3r7Igk2Pp2uuqSOXF2kgSAFjtnXDrGm2kmwRvAzrpvPlCJ3H6009Wrwd1BCzvpN5pVnNyvzbjrQM2sQR5iczS+Duc0lCcE5m+a785gky0RUr+1aY3sdBd8+vvGFuE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880615; c=relaxed/simple;
	bh=hejstT7zn7ptB7mLJibwRjMDHVs4v/OQHm/QISuCgvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/XwW/okuqwdVRdXmSHkCKpqEsjz/KL47QK44fZdMHk8YIYV8WuchpDHGiHiiCYyYnyGqFrfAAEZhjfCM8crcwq3OWo84Hs08HOSQsPPpQSy1KgRwpPEnn+wV1PhB5v3KRRmKfaXusUBy7Igah0mVaBtMbweOfP89AJQk2xVGAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8g1Asog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8g1Asog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234D9C4CEC2;
	Wed,  2 Oct 2024 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880615;
	bh=hejstT7zn7ptB7mLJibwRjMDHVs4v/OQHm/QISuCgvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8g1AsogGM+wAAojBJLVX/n08wvy2ZNA2LINSNdCV0HT8lYI5gXaZyM1qGS84u7ta
	 FlkUNxr9QD/Xr5t+7JMhZC3oa3WrdPbGY6PY6jL7+TJasU0Jt8wOfnE/Lp/V5C8sKK
	 T4VrXYIdtBmT81S+7k34k9HzYPkLl+fNBEV6qD0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KP Singh <kpsingh@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 519/538] bpf: lsm: Set bpf_lsm_blob_sizes.lbs_task to 0
Date: Wed,  2 Oct 2024 15:02:38 +0200
Message-ID: <20241002125812.934721023@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -24,7 +24,6 @@ static int __init bpf_lsm_init(void)
 
 struct lsm_blob_sizes bpf_lsm_blob_sizes __ro_after_init = {
 	.lbs_inode = sizeof(struct bpf_storage_blob),
-	.lbs_task = sizeof(struct bpf_storage_blob),
 };
 
 DEFINE_LSM(bpf) = {


