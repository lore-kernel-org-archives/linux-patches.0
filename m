Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784D51D2228;
	Wed,  2 Oct 2024 14:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879030; cv=none; b=iOh1Wp16wkZswdE55UWM0D2UltslQMLNb0NIdRwYJNL6JVuq50ELmGdZ/UPqqsby3GpbfwnuEvyEaF/IVEkMD3lA2HeH2GnfzT1PIxBsGPpvs2ECLSzqe8VN+sxzndW2pohGo/uFPgvD7Uj4ARDaTeKLnRG2J/mzyuJ7oDc2jTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879030; c=relaxed/simple;
	bh=HAe4FdTuFrZXSeYMEJRR7qUvQp0wskHQfGoy4vbqgRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSpNlNnS2EpxYdDTFCXLKhydHrw1gK+uRXAliSABaBjTtWW+G5fazu9srRKG5uVpP7S3+11XWwelYuAdBO6ccNuTe6C8UpKpWz3sHL8x5clMVxumZ9pjHE2ig+R/pJxKXgV0jUW6HqE0/SXxi3Lxo+2lJcWyCjF/zVDYDaLK2jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4jzt6kD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4jzt6kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025DDC4CEC2;
	Wed,  2 Oct 2024 14:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879030;
	bh=HAe4FdTuFrZXSeYMEJRR7qUvQp0wskHQfGoy4vbqgRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4jzt6kDZigJedpU+jmqqHBAilOgu+M6bFJwnDCSLdb+yLhXMJkWKZr+22yipIfDD
	 1+I/cT64ogIz3ek8nW6o+yctM+xBN8ol746/fo2g6oVREy6e9PKohoaF1GW/n/lcF6
	 Fe3PhEcDlkF4Gvg54DC5k8F1AD4tulY8Mtesuh1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KP Singh <kpsingh@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.10 615/634] bpf: lsm: Set bpf_lsm_blob_sizes.lbs_task to 0
Date: Wed,  2 Oct 2024 15:01:55 +0200
Message-ID: <20241002125835.393482413@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


