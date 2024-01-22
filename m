Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECA01350D6;
	Tue, 23 Jan 2024 00:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969342; cv=none; b=DI7NhbHv3mZgMJyRAkkR7J4IxyOGTC/njUa7Ei1kYybWk8Ie1m5tIKV9Bf8czRURCgGWZXSPLn+kX+R7PD21frPMs/Hm9kV9srIiXi0zu8j9S17M3hp9PguQACwgB4WZifP8QT+hrJL0L09mBQhSt+rI96C8dxOc5sBFGQC4ZJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969342; c=relaxed/simple;
	bh=dE9vsgGpsC3kHTuJ0mCYMZTmeJkXf/i9+FFpTyvsjK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvLXEZrfdb7RaUWxfGCjphZA08FLzztyFd6oClbVlB6CiXbjnrASBDQuXFm0zOYPWLcKyYzGYEQ4yykTFC4qE6vABhDnjW/0wkJNEInl7qT8Z8h5sODXlE9JDWiPnnazhViIBloOor7YoSFXlmuCxUFbOwb7IbEz2Q3fDkN8Nj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DODRLdbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DODRLdbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB26C433C7;
	Tue, 23 Jan 2024 00:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969342;
	bh=dE9vsgGpsC3kHTuJ0mCYMZTmeJkXf/i9+FFpTyvsjK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DODRLdbFbjedRQ4j3QwSHopWaBM0OFRYXkH1GG81HT+7UHy/T3dh8u/2k4mDQ+gjO
	 NOcvkBrDrGOtgwRKnewwMzKkBwN2bU9kEcGJgwi1SD1wHQOzNvWw4fmEyoX9TRmfMX
	 9zCRep7TvoDUIlvfkkiCHVgPMSJn0dt54ea6iQr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 160/641] test_bpf: Rename second ALU64_SMOD_X to ALU64_SMOD_K
Date: Mon, 22 Jan 2024 15:51:04 -0800
Message-ID: <20240122235823.042728220@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 5181dc08f79583c6dead80208137a97e68ff07b0 ]

Currently, there are two test cases with same name
"ALU64_SMOD_X: -7 % 2 = -1", the first one is right,
the second one should be ALU64_SMOD_K because its
code is BPF_ALU64 | BPF_MOD | BPF_K.

Before:
test_bpf: #170 ALU64_SMOD_X: -7 % 2 = -1 jited:1 4 PASS
test_bpf: #171 ALU64_SMOD_X: -7 % 2 = -1 jited:1 4 PASS

After:
test_bpf: #170 ALU64_SMOD_X: -7 % 2 = -1 jited:1 4 PASS
test_bpf: #171 ALU64_SMOD_K: -7 % 2 = -1 jited:1 4 PASS

Fixes: daabb2b098e0 ("bpf/tests: add tests for cpuv4 instructions")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20231207040851.19730-1-yangtiezhu@loongson.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 7916503e6a6a..3c5a1ca06219 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6293,7 +6293,7 @@ static struct bpf_test tests[] = {
 	},
 	/* BPF_ALU64 | BPF_MOD | BPF_K off=1 (SMOD64) */
 	{
-		"ALU64_SMOD_X: -7 % 2 = -1",
+		"ALU64_SMOD_K: -7 % 2 = -1",
 		.u.insns_int = {
 			BPF_LD_IMM64(R0, -7),
 			BPF_ALU64_IMM_OFF(BPF_MOD, R0, 2, 1),
-- 
2.43.0



