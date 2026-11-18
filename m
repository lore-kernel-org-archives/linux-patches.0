Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020703;
	b=pkCJcMPMOxv82rqrgnR1/TkciKOpK3U29qYN574fkHDLkCLsz8vuEJ2fErJAk37s1jXo
	 vaRga4LI+4vteuImyhT4LeRhuxdk4GqkZGrSGAkD4D4SbzfTRGFlPS0jPaAqovCFJY84g
	 WjQ6sMopNBSVm7I3ogGichMMuEcYHSHPtH/MxeK54ok3ppFGIPebbLK2F0VBj40YLpV0p
	 gTv3enp+p1bS6SvDaWzv0F3UPgHzO7IfwsfW+NMRj5ymM9L1UxEO7NVT1QRWZSekRgX0V
	 MhBYe9O+f1+pndrRh5UAzd9WjDI3yJhhcnivZMdWCWbnfqs/WoyZQvs5oTGr98n920A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Fn6qGtgJvCKDKZGMidyERNCjeIB25ZZTuH7pr7jDf4=;
	b=nsWTPREtkLCsTxxyinR7Rv0EEOhvejZOGwcgvKfy4ZqHi3BGuZ65UJbCejJi6AT91ta+
	 x7BrufEuHsmmvIQ8kFg7RIj56iPw9OSvp5rDHhoocvOyeR0zoplqczlQN3uUsTzFNmgP9
	 c1aY5Tnw8gWTOipqHtTLugezncC5XtT8NlV6b5xCjvAzVCnnMnVPn34gUOWcCtq+/JXZd
	 egoegAyMb6KL5uERIZNCRY+JtTTbTxAk629ks2AldTu4qxOJCxavqd/Ob2Im+FLKOINy6
	 CTCC2THz5tkwmQLtRtwTSrqWgs6YDv/WqROHLhGSsTWUW8jz3O1lkZD2MLcZ4SE8YEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0eLeCyb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9279760A2612;
	Wed, 18 Nov 2026 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0eLeCyb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52771F000C5;
	Wed, 18 Nov 2026 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020703;
	bh=4Fn6qGtgJvCKDKZGMidyERNCjeIB25ZZTuH7pr7jDf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0eLeCyb07osg+wzC3XGLTcpatAZ3duULZSuDUPaEQWtMrUpA7fxIsfGGkUjsnwi2
	 WmQEZB1npLY/cZ4yxWA11GN9T8ahppgBSA8pVHOAmRzYOVGcofDWrccAbUPGYyxgUI
	 LIoZQfeRams3tTLCYnuYuDLpFNlbmZANamflkicg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2045/2651] selftests/bpf: Fix spelling mistakes in descr literal strings
Date: Wed, 18 Nov 2026 15:54:45 +0100
Message-ID: <20261118150359.706906052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6c96f2d9fccfc..7dfdc4c12deca 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt.c
@@ -955,7 +955,7 @@ static struct sockopt_test {
 	/* ==================== prog_type ====================  */
 
 	{
-		.descr = "can attach only BPF_CGROUP_SETSOCKOP",
+		.descr = "can attach only BPF_CGROUP_SETSOCKOPT",
 		.insns = {
 			/* return 1 */
 			BPF_MOV64_IMM(BPF_REG_0, 1),
@@ -969,7 +969,7 @@ static struct sockopt_test {
 	},
 
 	{
-		.descr = "can attach only BPF_CGROUP_GETSOCKOP",
+		.descr = "can attach only BPF_CGROUP_GETSOCKOPT",
 		.insns = {
 			/* return 1 */
 			BPF_MOV64_IMM(BPF_REG_0, 1),
-- 
2.53.0



