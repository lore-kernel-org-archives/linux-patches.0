Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232B275809;
	Mon, 14 Oct 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917797; cv=none; b=VNDlRyXBHo3CStgZjcC2j2ll8T5bGmwI73jTwFqyVSfc1gL8IZc0GPAbMACJdrgDxA6VJzrMVBRhxe1yDysM592/nVjWZS7Z5w3XCtlsVh1fvMhkYlqxYlyBzyQsM1iRZdH5YkceSUrCULiSIL0vb6XDIy23yLPKK5yeAeo51xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917797; c=relaxed/simple;
	bh=HeJoAcldFPKFSG/ThfyabfJ2tZPDsYLtiV3s4u593LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pn/3H74uu1onycNr1NwE7y1iiJTeTE3SWIcz8EFMsxwOMRJ9xYRrpnthY+CUDjphA9LmMuMvdHjj9W6hAhDfixbi9fBpANiZSKDU7+lXS+bkr1gZf+kEU2phlximSpsfzAbJ9Nb681nP0o1Q0p1WkZJRu+9GePKFvL6+1e60mIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzE3wlWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzE3wlWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94737C4CEC3;
	Mon, 14 Oct 2024 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917797;
	bh=HeJoAcldFPKFSG/ThfyabfJ2tZPDsYLtiV3s4u593LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzE3wlWJSe18QrMTiB82xkRFWBmMqPXobxQsIQFBLyM5iopr+mDz6JjfjA2OTluiA
	 53Tx3W/BrUibFsgUVobVhu0KQoJp9q76IvAF4iI/vSlDpCkIHOjLpVS3rlVHVdVgh9
	 GmvyEoRG1DXRrG60kFG6z9BFk6VYWb8qNpZTT3lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yhs@fb.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/798] selftests/bpf: Add selftest deny_namespace to s390x deny list
Date: Mon, 14 Oct 2024 16:11:32 +0200
Message-ID: <20241014141223.340940607@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 8206e4e95230daeeba43c59fc7c39656883ecd62 ]

BPF CI reported that selftest deny_namespace failed with s390x.

  test_unpriv_userns_create_no_bpf:PASS:no-bpf unpriv new user ns 0 nsec
  test_deny_namespace:PASS:skel load 0 nsec
  libbpf: prog 'test_userns_create': failed to attach: ERROR: strerror_r(-524)=22
  libbpf: prog 'test_userns_create': failed to auto-attach: -524
  test_deny_namespace:FAIL:attach unexpected error: -524 (errno 524)
  #57/1    deny_namespace/unpriv_userns_create_no_bpf:FAIL
  #57      deny_namespace:FAIL

BPF program test_userns_create is a BPF LSM type program which is
based on trampoline and s390x does not support s390x. Let add the
test to x390x deny list to avoid this failure in BPF CI.

Signed-off-by: Yonghong Song <yhs@fb.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221006053429.3549165-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: aa8ebb270c66 ("selftests/bpf: Workaround strict bpf_lsm return value check.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/DENYLIST.s390x | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/DENYLIST.s390x b/tools/testing/selftests/bpf/DENYLIST.s390x
index 17e074eb42b8a..0fb03b8047d53 100644
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@ -75,3 +75,4 @@ user_ringbuf                             # failed to find kernel BTF type ID of
 lookup_key                               # JIT does not support calling kernel function                                (kfunc)
 verify_pkcs7_sig                         # JIT does not support calling kernel function                                (kfunc)
 kfunc_dynptr_param                       # JIT does not support calling kernel function                                (kfunc)
+deny_namespace                           # failed to attach: ERROR: strerror_r(-524)=22                                (trampoline)
-- 
2.43.0



