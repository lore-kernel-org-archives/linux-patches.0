Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7A846EF64;
	Tue, 21 Jul 2026 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661149; cv=none; b=m3VWlmn4X22zYLbRCVTg08uGiQSOr/o/jzRzq9ynsitCXgR2dXy983S7T5WeiFh5m/WLHDD8yDyz4tyIhOqA4P5ewZFNttDXUyhOj54xt5J0bmTGdderMFqSWC0xcd1lPhwtIImeBc1v8yMF2WKAm6LLen+ifNbnGzWlxQfpAlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661149; c=relaxed/simple;
	bh=Mppba6PzPgoFs2OjW4uRTsKr/iMwozOLv4QkzUDozW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJeRYZVJeynyGK4MtxlMDh5g4s/jvRXy5nYu/1FCDnkWECdDyNMZ4KGk8N9qK7n4q2tqbA1kS0M/irJoJPRgywwgYGqGR5nVLe3nA15SISFiAn0ozXnVgSYko/k+fNJmd2Cf4SmQ0ohGGdp1Su4oySKqGqTffr/HcoS7VefekI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OnyRVBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OnyRVBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39521F000E9;
	Tue, 21 Jul 2026 19:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661148;
	bh=1gk2V2ziSnsUwbpEUhNODMB13m2lxvCU26dAnG0cI5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1OnyRVBwP7ElqAHWDwdCJeYmz3L4/C/5wviGGUx0HY/aa2zcMuhuznNLO+8Se6tpO
	 K0b86zbkojfhYh8aSANHgOcyWtdab+e3Mq+UeqJa2x25KD/itdiGKmbsQka8guUvuq
	 PSBHZiKJxnBBfcdcX/bM7t8yQfYBjqkgynADDfXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1195/2077] bpf: Fix BPF_PROG_ASSOC_STRUCT_OPS last field check
Date: Tue, 21 Jul 2026 17:14:28 +0200
Message-ID: <20260721152620.999673883@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thiébaud Weksteen <tweek@google.com>

[ Upstream commit 8405c4626460503027461652f96d8bb10c2a9173 ]

When struct prog_assoc_struct_ops was added,
BPF_PROG_ASSOC_STRUCT_OPS_LAST_FIELD referenced prog_fd instead of the
actual last field, flags.

Fixes: b5709f6d26d6 ("bpf: Support associating BPF program with struct_ops")
Signed-off-by: Thiébaud Weksteen <tweek@google.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260618040934.4113938-1-tweek@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ddf0571f476bf1..96d1b797e1523c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -6208,7 +6208,7 @@ static int prog_stream_read(union bpf_attr *attr)
 	return ret;
 }
 
-#define BPF_PROG_ASSOC_STRUCT_OPS_LAST_FIELD prog_assoc_struct_ops.prog_fd
+#define BPF_PROG_ASSOC_STRUCT_OPS_LAST_FIELD prog_assoc_struct_ops.flags
 
 static int prog_assoc_struct_ops(union bpf_attr *attr)
 {
-- 
2.53.0



