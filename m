Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CF1186E47;
	Mon, 12 Aug 2024 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479855; cv=none; b=ippJQnppGx35QEDxEzzH5vbQt45GdGLq+Q++XW8CYA1pvi6/5RXh9qIKTlciT0123NlsWTDwBOmTpRMuPkttGa6YC796hAmShkaGIPU4ckGDpf2ZgQtMFNMg0A07kzRbpPzRcnGME9rB+p8tSezrxZBcr85dp7UuMu3GhQgFItk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479855; c=relaxed/simple;
	bh=Hyh7DkvJKdFCR5PBJ2oNncnnbLeiR4R6kwPMhDH57ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PuWomO5N5VrOPCnkwwXxUVS7AVp/yAwLMNN825BlNEuCozXJh5MEZZ6MKLO7LoTXDQebn2otoNVnBrhCmQDI73YK36KDOyIz8aepevY3CtAPoTSupeQJTazabsOADGW2Fe+8ZtUbKkm0w13RSNvpWBZG/cqTvt5EvjXk+4Sg+r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5LPyUNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5LPyUNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA02C4AF09;
	Mon, 12 Aug 2024 16:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479854;
	bh=Hyh7DkvJKdFCR5PBJ2oNncnnbLeiR4R6kwPMhDH57ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5LPyUNZYtp2nmHtO5izT15/ICFaWOHSTgHYzwd4OqB+8c6SqYQZgH6b7rLdtTrtj
	 nw2dwmeLuD48Gf6o0zJ7EOBH7da0K50BKu2/Yo1GXT2atRM7k74aDBtcIfqKPy0TL9
	 XL+v5lx+wLvXVbOvSziYxp1x81HrSOAdQpRyDSDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Laura Nao <laura.nao@collabora.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 014/263] selftests: ksft: Fix finished() helper exit code on skipped tests
Date: Mon, 12 Aug 2024 18:00:15 +0200
Message-ID: <20240812160147.086631856@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laura Nao <laura.nao@collabora.com>

[ Upstream commit 170c966cbe274e664288cfc12ee919d5e706dc50 ]

The Python finished() helper currently exits with KSFT_FAIL when there
are only passed and skipped tests. Fix the logic to exit with KSFT_PASS
instead, making it consistent with its C and bash counterparts
(ksft_finished() and ktap_finished() respectively).

Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Fixes: dacf1d7a78bf ("kselftest: Add test to verify probe of devices from discoverable buses")
Signed-off-by: Laura Nao <laura.nao@collabora.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/devices/ksft.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/devices/ksft.py b/tools/testing/selftests/devices/ksft.py
index cd89fb2bc10e7..bf215790a89d7 100644
--- a/tools/testing/selftests/devices/ksft.py
+++ b/tools/testing/selftests/devices/ksft.py
@@ -70,7 +70,7 @@ def test_result(condition, description=""):
 
 
 def finished():
-    if ksft_cnt["pass"] == ksft_num_tests:
+    if ksft_cnt["pass"] + ksft_cnt["skip"] == ksft_num_tests:
         exit_code = KSFT_PASS
     else:
         exit_code = KSFT_FAIL
-- 
2.43.0



