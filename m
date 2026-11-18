Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032221;
	b=138NIPIBmy/1sgazZdbUDyq6Z9rqpLEy/dwJWVoaMyM+4if4bleNihCyuMXxTQXbJej6
	 lmaNUdnIVl0nt7lT9NO+Wwim2ummTx2Won260lH+m4Qe4aXLrmlzZr6UbZLaTMxBOuQsW
	 h13MUAJ9eEBbQzvkfY68UehPsSuVa297pd9bhWhp+IliFc+UbaZY3Q+3JduV69EMosdm/
	 bFtL8wk3O5d7RcVaAO0lePX3RiraLpMRX3VQb5brRu//glgVXiFz3JaS86htDxNozgzwa
	 U6zRvmxs08DGh4bS5PzIgIn5GZRL5eZaOJG+GfqLHt6N27DvXPO7Tx4iadBIOI1h80g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WkNa1Hom7gH9wlZ/8Z+Lg0bmFGHEGQuX7QSdrfvMjJk=;
	b=Z5HW0ltRJXO5POqN2kOp1+uN1IT1JJ2u/mu0JhR7wdwGtbOVW2LY2SFam+LJw92Ah8j+
	 xcZWlEprQylAdXWhLvB2yLTczzue01NqMaSiSEsNigs1JLbJjn5DIa+y4kMAdT/6LJUTD
	 iFucXcrs/Ha6PdQXsTkdEbyylh074JQ6+oHEzpYT16psBWuYMFKLUpSoQdSO3QSpa2lOo
	 iRz3cRPq9isxEepOwAn+S+x3F7UWEOQ1aj9m0O8g0JX94KNF0fgdVyKO4g19ncP1vX5+b
	 oESX5/qoC6TaoqL/sw6zrg61io0ivPX/KDfbJyj7Y9Tx+sdN50a4iULS1AxUotoOm6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BaQCFZzp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CFF606A331;
	Wed, 18 Nov 2026 20:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BaQCFZzp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E377E1F000C4;
	Wed, 18 Nov 2026 20:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032221;
	bh=WkNa1Hom7gH9wlZ/8Z+Lg0bmFGHEGQuX7QSdrfvMjJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BaQCFZzpQdyhkCauSw8vBhxceYVXrdhwAw7LPSdYusLU823B124w9T27AQxoH9Pve
	 +VoC2eDpnVAPbVz1MEDWZy0Iies8PU6G9RLp3/WwkHSB3FJy4aah/rTp0Xkm8AM9pn
	 7yPqbpp1L6v6R9b8L9sp+IsAjfPH/2CMXfgsHUG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1336/1756] selftests/bpf: Fix spelling mistakes in descr literal strings
Date: Wed, 18 Nov 2026 15:57:43 +0100
Message-ID: <20261118150102.549835308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



