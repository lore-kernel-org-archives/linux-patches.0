Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A3413B78A;
	Tue, 27 Feb 2024 13:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040550; cv=none; b=ulU6g/BMEUd/0Mg9XbLn+RvIdh/CaYow295BG3l0VWNrV6vW5GUQ9jujovqIPLArHx5/JNXv3oThyvt9jnoYgZRAu5g1q8HMa3cbxklHnz3Ys86wbOtV2FHOO3G5SBb177RpzwMcr+C1Kddfnj2zi/hhmvHLXq/dwIK6RILjFJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040550; c=relaxed/simple;
	bh=JKt0f6InaSrtEuUukuq5MibrK+jTA6fkZw6WNyHPV4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGQOuZFlR7pwpQRx7KA7QSTEP81e87byugtjwaC8Jg1bJMc0l7qD0gMUPlJrNCEMggMAZBGCl+iaLdiRV5DXRi4Hnm5GHIks4QcTpPE+TuKbgMFr3l0gzkuwi0H4sqCnjxnBBfMQUKu1eILJynQ+eE+LRck3kMM+penVUlh2uIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P61PFPDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P61PFPDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F374C433F1;
	Tue, 27 Feb 2024 13:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040550;
	bh=JKt0f6InaSrtEuUukuq5MibrK+jTA6fkZw6WNyHPV4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P61PFPDFC6+4I4Wr9w1YnqmWvqGM0NIDYF00QWyQDwZYTmyyr4MOJqMIPlu89gJ/Y
	 KaJUtj+1SirKFOeNxluyP4Wv9S5Cg67M8mFLofFHoxQSArlh+lvad3NWw+nPKlOgQZ
	 T//duhcr79ijbcmXhapqVNXTZy0dsdJnOK11Tt1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 005/334] tools: selftests: riscv: Fix compile warnings in hwprobe
Date: Tue, 27 Feb 2024 14:17:43 +0100
Message-ID: <20240227131630.811480081@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Müllner <christoph.muellner@vrull.eu>

[ Upstream commit b91c26fdb0e8150cdb610cdaadea62bb5e43bee0 ]

GCC prints a couple of format string warnings when compiling
the hwprobe test. Let's follow the recommendation in
Documentation/printk-formats.txt to fix these warnings.

Signed-off-by: Christoph Müllner <christoph.muellner@vrull.eu>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20231123185821.2272504-2-christoph.muellner@vrull.eu
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/riscv/hwprobe/hwprobe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/riscv/hwprobe/hwprobe.c b/tools/testing/selftests/riscv/hwprobe/hwprobe.c
index c474891df3071..abb825811c70e 100644
--- a/tools/testing/selftests/riscv/hwprobe/hwprobe.c
+++ b/tools/testing/selftests/riscv/hwprobe/hwprobe.c
@@ -29,7 +29,7 @@ int main(int argc, char **argv)
 		/* Fail if the kernel claims not to recognize a base key. */
 		if ((i < 4) && (pairs[i].key != i))
 			ksft_exit_fail_msg("Failed to recognize base key: key != i, "
-					   "key=%ld, i=%ld\n", pairs[i].key, i);
+					   "key=%lld, i=%ld\n", pairs[i].key, i);
 
 		if (pairs[i].key != RISCV_HWPROBE_KEY_BASE_BEHAVIOR)
 			continue;
@@ -37,7 +37,7 @@ int main(int argc, char **argv)
 		if (pairs[i].value & RISCV_HWPROBE_BASE_BEHAVIOR_IMA)
 			continue;
 
-		ksft_exit_fail_msg("Unexpected pair: (%ld, %ld)\n", pairs[i].key, pairs[i].value);
+		ksft_exit_fail_msg("Unexpected pair: (%lld, %llu)\n", pairs[i].key, pairs[i].value);
 	}
 
 	out = riscv_hwprobe(pairs, 8, 0, 0, 0);
-- 
2.43.0



