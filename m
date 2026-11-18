Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026833;
	b=pWh/fCXgaAi/BpD0qL2psjg3djqyMHt38lpYhL5S4tmO4uXOMsg9z66HdPRlv5hjcZu2
	 2bbskbivEkxKdGoBLx3eascvHkcXcyw/N/3zdRzeViwjRZ42YhIS5COQsXQkwzxjToNet
	 pV78YJYxyJZ5r4yF9X+PgBxKH/3pJySo1GlGXKxlfE93UqPTUTfV6a+cUgYjgKp2Ia08w
	 qpmy/XiRE5Gz0xWhMdjKAY1s2zDKIipthbg2yFUPMJTRbDWFv0xbtSp2hjjzSJNKyicVH
	 n9P0u36BClJiIKO4FQ7J08gQikh8gb1SokE5Zfg4OuTMp5p9njQFvrNQZEba3IEYc9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wLpAFVM3PY2o7xHSQ8zgjB7QLkF+ExD5rIlFtw/WjBw=;
	b=DM6wGBbSZZdWQCHozdEQc/55TA44WtCtSNpZEM+XSZiTgAOs8aKx1PK904TngO8MLxVl
	 MI50jNqpRXlXMYfJnb+D1Sgv/gSMYpbxKsG0Ta2PB1nPib8dDxkvQWCLmnllCAPq+D7Zp
	 3eShlgZvlDOK4I8NxHAnUgOjpS8uIOTXKKqSwCiEh3LlKnOGdsfbs5FQpwBKap7EQ+6DD
	 OV2CohwVPZG6XYZY7s+bWELwmmSCcPyLDbbLH8EqkWrmvxKB4/hHwWabzg30iKnMgRsFy
	 udTC/IMAAfuKMz0K6h8QQoGY7DfXDGQK+eDI2CQBC4UGL+f95cTi5d0VZ7oBO2C7LNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YmTll+6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1621D606A31C;
	Wed, 18 Nov 2026 18:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YmTll+6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C381F000C4;
	Wed, 18 Nov 2026 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026832;
	bh=wLpAFVM3PY2o7xHSQ8zgjB7QLkF+ExD5rIlFtw/WjBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YmTll+6eY9ZKY6h5suOrn0z0RDKrBoH2V+yBshx/e0urtRZkuk3PapBgMZgj9Z/6
	 kY27LfP6FJW49cGRo7+iX05onA3/bXEOj/4GpfRAoX4Kh+rbJSKbdYt/99Gi4BkcaS
	 XmTDxx3O6tjtrFNgjJOszX52+CTcu2a8IMojkL38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1575/2151] selftests/bpf: Report a failure to register the session key in test_progs
Date: Wed, 18 Nov 2026 15:55:10 +0100
Message-ID: <20261118150219.257439372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 66fd5eb9da12ef4ed089ed1974160d07ff034a19 ]

test_progs adds the key that verifies signed programs to the session
keyring before it runs any test, and exits when that fails.

It exits with 255 without printing anything. pam_keyinit revokes the
session keyring on logout, so a test_progs started in the background
from an ssh session that has been closed since leaves nothing but an
empty log behind, with no hint of what went wrong.

Print the error before exiting.

Fixes: b720903e2b14 ("selftests/bpf: Enable signature verification for some lskel tests")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261008-selftests-bpf-test-progs-session-key-v1-1-ec48e793639b@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index eda3fcf72095f..1f9f4bd32999a 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1973,8 +1973,11 @@ int main(int argc, char **argv)
 	libbpf_set_print(libbpf_print_fn);
 	err = register_session_key((const char *)test_progs_verification_cert,
 				   test_progs_verification_cert_len);
-	if (err < 0)
+	if (err < 0) {
+		fprintf(stderr, "Failed to add libbpf_session_key to the session keyring: %s\n",
+			strerror(errno));
 		return err;
+	}
 
 	traffic_monitor_set_print(traffic_monitor_print_fn);
 
-- 
2.53.0



