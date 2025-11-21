Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE934E74B;
	Fri, 21 Nov 2025 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732376; cv=none; b=IaYuuMCU5prGX1/IwyGmGGzc6tFtJ5h2uHbVCHfl0zxdYhhdtJVhAtU2BHd6QA1qt98uAWgGj72rOLJUp/tziT/thl3ENLwz+he6wWzjN8KyPRIrx1rbyM5yyXHPepIOiLmSIHi6cP9V4WJd4hjyuCsO86Z1MlJSqOc9AM8Qyr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732376; c=relaxed/simple;
	bh=u8jAGiqNI1vLzBFrP5edK8MQy4uSWbNyeLWyKOSbNLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nu6SBTK2xMTsNBkdJZeiBUKqUA5WiGWAkKMZkGmpCREACcCCWy8gAgAvEFjOajs9N/ryAaXHSoaeg5YIbhp4aKMj+TJF5LT4TVy91r0QLl+Pq/jxtn2JGCp1A+MTE97U+IGxmDof/IZhZXCGDGjkcXQyvYLRpNPRGSfhkwZ5Id8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FleUJOY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FleUJOY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3510C4CEF1;
	Fri, 21 Nov 2025 13:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732376;
	bh=u8jAGiqNI1vLzBFrP5edK8MQy4uSWbNyeLWyKOSbNLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FleUJOY9BN8+wc+V9gIxccR2BuFJdj1R63OO5KfjaXjP1nrt8bQefKOlSCi4nLwQK
	 AQO+7ZNL3aBQd9ieG+G7DFAmQmhl08koHPPs5uJK3m8t0XDPQBv7R1jSS7E2M4kkG+
	 4V3k33ypzoiIGME4Of3xMuZ0bkd12dpU+ScPm+aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/529] selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2
Date: Fri, 21 Nov 2025 14:06:05 +0100
Message-ID: <20251121130233.377052190@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4694422aa76c3..88e4aeab21b7b 100644
--- a/tools/testing/selftests/bpf/test_lirc_mode2_user.c
+++ b/tools/testing/selftests/bpf/test_lirc_mode2_user.c
@@ -74,7 +74,7 @@ int main(int argc, char **argv)
 
 	/* Let's try detach it before it was ever attached */
 	ret = bpf_prog_detach2(progfd, lircfd, BPF_LIRC_MODE2);
-	if (ret != -1 || errno != ENOENT) {
+	if (ret != -ENOENT) {
 		printf("bpf_prog_detach2 not attached should fail: %m\n");
 		return 1;
 	}
-- 
2.51.0



