Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C33427A10;
	Tue, 21 Jul 2026 19:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661602; cv=none; b=J9dHiBN1n94nTTMUYFrmHYj/tpNGSmEoWGygRBBvGyOAZXEsvoyczUTPVrfgBuYsDYiooN0juhl61kWsE5lLPPqi0Kwg3ztfv27HR79nahLAcFKWwyhxZJR06PTbu1YVvguvgbEDsZ/QW3g4P18L793fnScsH78SiW1rxQRoufc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661602; c=relaxed/simple;
	bh=c9iYTDWeR5KirNfu0L+RXbqg87hn+zWW+womK8Ctdc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUg/ENbqI1zvChUg7nUk4rhVkYmsZXo2tSb6OkYRp95dO13B6wghZn1vcSSvwQ/snbEhbezcrPl+3qa8lZRMJWHbmX+Lg4MCP62m1sP9gcUYw1F3w8KWo7si6mxfVpqxegwGxjbprjDwZKLtjKi3oW0HAhPKSLMZrPACq3pZCvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdAsvaBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdAsvaBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4C01F000E9;
	Tue, 21 Jul 2026 19:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661600;
	bh=+I8Ss8P3opgc4hvy74Av5vDjwO48216Tze1rQTtrug8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdAsvaBIK/vZBGnfPwKWx58m0HHi7j1N+fCEct2pzFua9aVh7xsk7mOrMNnJcXZdm
	 krG1sEMv7QzxjjGFLpL2U+OkTcP/+jXja7w38aOi8EXpsBSm4TtSTsK/qkMa7S6RDg
	 /li4Ag4+fjCVmu2K4HpDlBe4tN5AGNSmxXsgidd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Kvasnytskyi <roman@kvasnytskyi.net>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0127/1276] selftests/bpf: Reject unsupported -k option in vmtest.sh
Date: Tue, 21 Jul 2026 17:09:30 +0200
Message-ID: <20260721152448.945763106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Kvasnytskyi <roman@kvasnytskyi.net>

[ Upstream commit 6df582112aa9ac9d190169abdb0e42e496659ec9 ]

vmtest.sh does not document a -k option and does not handle it in the
getopts case statement. However, the getopts optstring includes k, which
causes the script to accept -k silently instead of reporting it as an
invalid option.

Remove k from the optstring so unsupported options are rejected through
the existing invalid-option path.

Fixes: c9709f52386d ("bpf: Helper script for running BPF presubmit tests")
Signed-off-by: Roman Kvasnytskyi <roman@kvasnytskyi.net>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260516120625.80839-1-roman@kvasnytskyi.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/vmtest.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
index 79505d294c4411..b0aca33d75912c 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -373,7 +373,7 @@ main()
 	local exit_command="poweroff -f"
 	local debug_shell="no"
 
-	while getopts ':hskl:id:j:' opt; do
+	while getopts ':hsl:id:j:' opt; do
 		case ${opt} in
 		l)
 			LOCAL_ROOTFS_IMAGE="$OPTARG"
-- 
2.53.0



