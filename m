Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EECE2882CE;
	Tue, 12 Aug 2025 19:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025673; cv=none; b=CYIkIM9bMgZqExIYl3PNYNVPQxuJBmOwh3f/dU45m9j9L1rgjHfIbg5J/w+zYID2sXR/OrcA+ZFUQfYYHdoOEmGjU9O+FOv2EUBulQphfGuELCekAwZb6YDbBmSyfDXhkSZO2X38sV3C/UYQZPtVVSRs3+2gzJWpU08N1EBzwis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025673; c=relaxed/simple;
	bh=rYTLyLPmtvNNIH1xBjzYdteeLek18yWaoZdR9rIdZYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsSGJvHfoe7jscGngJYOLNbI2EznlQpXKj1bIvfZIw3HamS3EpdA1G9dT+vfYT0mu58UUnGMf8lnpDX8cn4j0yFtER8GRh+H9hgHxwdZCgoRsaY8r2W8XRgZTg7AHctIkbn6/Rv48c73vKpUVn+ow80CySOYFj73MoUa2UwOPHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1HFdTua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1HFdTua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF81AC4CEF0;
	Tue, 12 Aug 2025 19:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025673;
	bh=rYTLyLPmtvNNIH1xBjzYdteeLek18yWaoZdR9rIdZYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1HFdTuasjvxFdWoqZ53out3Ol3Rb5V0Y9AwYmayZFMjBYJ5IaRopwRKwZrnR1QF5
	 DTqWPAdbQYzswC6QDeWEbmFVdA/2wCz54L7a0mqlwZQm3zcyRGh71Bae1B9Qy8KTOR
	 zoawGcA8Tuy4/Yd7QRrEaqGx5Jqub8JXlapo7VwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 109/480] selftests/bpf: Fix unintentional switch case fall through
Date: Tue, 12 Aug 2025 19:45:17 +0200
Message-ID: <20250812174401.985158198@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 66ab68c9de89672366fdc474f4f185bb58cecf2d ]

Break from switch expression after parsing -n CLI argument in veristat,
instead of falling through and enabling comparison mode.

Fixes: a5c57f81eb2b ("veristat: add ability to set BPF_F_TEST_SANITY_STRICT flag with -r flag")
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20250617121536.1320074-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index a18972ffdeb6..2ff2c064f045 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -344,6 +344,7 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 			fprintf(stderr, "invalid top N specifier: %s\n", arg);
 			argp_usage(state);
 		}
+		break;
 	case 'C':
 		env.comparison_mode = true;
 		break;
-- 
2.39.5



