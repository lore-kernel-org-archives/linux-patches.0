Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43ED46C4D3;
	Tue, 21 Jul 2026 15:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648523; cv=none; b=iuDNxTA+GSpBRE+ojY0Ea93xqv9gxl3L/QPiLN7oGpGpHEjkdbZ2dOs9X7Xlx7mK5KXtpS1UudcUdiTSAKDAuBnl36D1+FkSNap2S7MPGKqt8+pD0HAMLDWsth1kM4gAxAeNLaSPT6/suv+T/H2GwKoeJRZ35cOQbr/FWHxAxuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648523; c=relaxed/simple;
	bh=253s6tPKk3g4zFku8bycGeh48BIcCFxM85BJMRIoFYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxSp2hTMK5kOUgQE0W7Qvk1QbprpQtMYYAnxwCsHYJ1TDzAV8KcDCs28xVeTaU9pnZD6CGa70rkDih0+ox5e8wd0w61zIGODR77oE4hxn5qQNN0bVbUQRqSrLNKV2A99CcERHUuyDUlko0JyfE9qpYe08j8Z8PRF8IE/MWmxkCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3d/tRtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3d/tRtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7C11F000E9;
	Tue, 21 Jul 2026 15:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648521;
	bh=r7dQg9zksnq55AspBs1qEWBcb7ysQZfDSWnhrAWXCsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3d/tRtbYB/m6Ti/j9Y6w/CseA3y9fXYAzQ2X+1slbl6fSagyGRmUL0TyeijBb1Qn
	 J3wzt+tHebWptSj+YzZN+D5wl344idhWbp1i8GFTFEr9lPNfy/YrL1QuRHGhZqTmV7
	 Gky5/0FHj78Px6V4om1G6Zaj2oPmt64MUhK/lqWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Kvasnytskyi <roman@kvasnytskyi.net>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0232/2077] selftests/bpf: Reject unsupported -k option in vmtest.sh
Date: Tue, 21 Jul 2026 16:58:25 +0200
Message-ID: <20260721152558.148345183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2f869daf8a06b7..9ca8022853933a 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -382,7 +382,7 @@ main()
 	local exit_command="poweroff -f"
 	local debug_shell="no"
 
-	while getopts ':hskl:id:j:' opt; do
+	while getopts ':hsl:id:j:' opt; do
 		case ${opt} in
 		l)
 			LOCAL_ROOTFS_IMAGE="$OPTARG"
-- 
2.53.0



