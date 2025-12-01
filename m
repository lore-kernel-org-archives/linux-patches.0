Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150662C0277;
	Mon,  1 Dec 2025 11:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588390; cv=none; b=pef2dclkThhqndhj8yrQhdOy3bC46vRKjpNrcHVUY+odnfRaBMi+fCAlerujnMKT/mdRVmKeWAuZE5JzO7I3apcL1DQUlZXnP/5E7V0Ab+KvMRloZlwHC/Tykxk2sP2B5oUdLMhBWtP4pDWKpqrjh/8gHeXcgtHf9bW85nzLeu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588390; c=relaxed/simple;
	bh=HGBwn2zlxSsa3fkzIAhkbrGicMxlxcHhmED9Cqdmdl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FOQTjEVhqk3hDU5WQ15xeB2wqKPC8RwsDc/jBV1S7ye+Zx/5TiCxb7yyPAlcbh44wPbzjXVCTbpyi6Ww6OxR2xEMX/LkDqYgZ/kIOLuzU9yqiP1pIFXwNbhwxOUHxqR4iEwnsnTGbO5tYq/Zcel8x2yNmkFoL543UjjbvFZVhJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwRSFulv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwRSFulv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3690FC4CEF1;
	Mon,  1 Dec 2025 11:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588389;
	bh=HGBwn2zlxSsa3fkzIAhkbrGicMxlxcHhmED9Cqdmdl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwRSFulvE+fJxNmcJhJr1omM2Tje+9Bs9aJ5rFLaX1IrSPkXAgEI8D/JfyJgdTZy8
	 yGyKL1JlN5clIlTx6shlq6VIC6rmWIxa+svOcopwD/151LWavzbU6p/YX270uw+zyN
	 j01qc+/selYcVM38GpcndvTG/YWAtlVmrWnIGKSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/187] selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2
Date: Mon,  1 Dec 2025 12:22:19 +0100
Message-ID: <20251201112242.378146950@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 98857d111c53954aa038fcbc4cf48873e4240f7c ]

Commit e9fc3ce99b34 ("libbpf: Streamline error reporting for high-level
APIs") redefined the way that bpf_prog_detach2() returns. Therefore, adapt
the usage in test_lirc_mode2_user.c.

Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250828-selftests-bpf-v1-1-c7811cd8b98c@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_lirc_mode2_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_lirc_mode2_user.c b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
index fb5fd6841ef39..d63878bc2d5f9 100644
--- a/tools/testing/selftests/bpf/test_lirc_mode2_user.c
+++ b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
@@ -73,7 +73,7 @@ int main(int argc, char **argv)
 
 	/* Let's try detach it before it was ever attached */
 	ret = bpf_prog_detach2(progfd, lircfd, BPF_LIRC_MODE2);
-	if (ret != -1 || errno != ENOENT) {
+	if (ret != -ENOENT) {
 		printf("bpf_prog_detach2 not attached should fail: %m\n");
 		return 1;
 	}
-- 
2.51.0



