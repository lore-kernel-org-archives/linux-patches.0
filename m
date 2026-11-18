Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027129;
	b=S+4VEFwYQnCRJLM27EBXTbSftfPCk9dsz9dX86Ddrb0QFMzhU2tZDncJ9fL3VUCVAI14
	 UDaDil66WHR+wi8IymwvK2Lzgb3kg1NJDYBe4iQvYpZpAuaZj059OAuJYNMXPlwmG784o
	 NepdDz6d9aIOsM9rvQfQghIazPV965dfYxHeHcoPnsiciC3m+D85CV7pzu+1Rn6Ey3nRG
	 avolVz5okPBOrQIyb/Aft9Qv4cUTgkxl1mmvbWSByyqHU8mRzgDwQGq+sGtlsCz2Q6pIS
	 8AwrKyWnVvRYpM8TUFx5BhGocu2OtjVEOA6uuu8Z17A3NYcgqfpXayo13c6wcueE2nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Dtv754h6cLvGrpi1Zv3H/1izieD6qUHJdd1e4YATtE=;
	b=LGL5KPO/tJtp8x2vVKliHwCFBmgirei/qi7KBbHN2yi2GYRo0Ze8l/ybCCrxJ0H3oqzx
	 oNmjuN3148bf4IszFm4iUWBoTfI8D5Ht7hwQxELvfhS32q6n/J2sVMCDz7hP/QhJ+UQ6j
	 +3G4huGbAFKU955gw0M4mx4g8GBzu6LoG+lPQs/SLKRY9O7qeRdgO1bqq3s/U1/x18SUQ
	 zRZ/c3iYTta1LB8TwvwsPSCYjgOpNqbbyI++78XTLgZcVldLKajzefKCObnZ9dxvrO+wo
	 zc0h7ugCeuh69qDe6D6PEhHasBu5PmUX8AamSv0PgKFWUXrWLSCdNwFBIJXZLeIiN4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDmVU07P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44034606A330;
	Wed, 18 Nov 2026 18:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDmVU07P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCED1F000C4;
	Wed, 18 Nov 2026 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027129;
	bh=+Dtv754h6cLvGrpi1Zv3H/1izieD6qUHJdd1e4YATtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDmVU07P4/nlcuk7nn6dQOKdhmGqJvkietous8+UitGAZ/3jVeGyeWN0GWjwyru2R
	 XNtzDlOnQOBZv0Me+LpHzIXMGzJus4S7yFX/A19D/Ihp8pNUY+u8B9e0rZBBLeszfH
	 h0su7zNONwLu7E0V7QKi+utxyoJh3eyfPzZmZrBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1679/2151] selftests/bpf: Fix spelling mistakes in descr literal strings
Date: Wed, 18 Nov 2026 15:56:54 +0100
Message-ID: <20261118150222.989840298@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 760c953525bab88f053e61f1c1a6b2a5f76911c0 ]

There are spelling mistakes in the descr literal strings. Fix them.

Fixes: 095ddb501b39 ("selftests/bpf: Add sockopt case to verify prog_type")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261012212334.183116-1-colin.i.king@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockopt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt.c b/tools/testing/selftests/bpf/prog_tests/sockopt.c
index eaac83a7f388b..ecf5a7a047a48 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt.c
@@ -933,7 +933,7 @@ static struct sockopt_test {
 	/* ==================== prog_type ====================  */
 
 	{
-		.descr = "can attach only BPF_CGROUP_SETSOCKOP",
+		.descr = "can attach only BPF_CGROUP_SETSOCKOPT",
 		.insns = {
 			/* return 1 */
 			BPF_MOV64_IMM(BPF_REG_0, 1),
@@ -947,7 +947,7 @@ static struct sockopt_test {
 	},
 
 	{
-		.descr = "can attach only BPF_CGROUP_GETSOCKOP",
+		.descr = "can attach only BPF_CGROUP_GETSOCKOPT",
 		.insns = {
 			/* return 1 */
 			BPF_MOV64_IMM(BPF_REG_0, 1),
-- 
2.53.0



