Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51596282E1;
	Tue, 12 Aug 2025 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022276; cv=none; b=SudCM5Phjz0/o5yjwB+VTot5U29ht+ktkMiEHMjbiJ2YKRy6Cf8Pv7cKn4KAkwqr7MUnVxAiIUbPnmxndbgoLhCMo+VOR4f9Y+eUMX8jFdQhuO9DjN/xqzUY2vWjvMriRPrzm4eFLRBSf7+z+6ws2AfF8ma7v5aQPPwQO9of16o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022276; c=relaxed/simple;
	bh=rfdm8pBdpFY+qCcu8P8ryTDH7zTwwzgwHHkD+t0i3uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgQyhyl2MlD1jiw7BRWdzgb0emJYP6oTyyhd5eftdqo95l0FTg/0OzLSzk8/Ap3YvGYz2d5f/uPIXDhx0gVbZxSd4C3DNGkVyyoJFHZ1ZKYWxPWN7W93VNGPOkCb6VBgfQzdOh2N3zL/Az5ZEPTLBII6h3GwLqb+91m+dnyIhuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMTkfGb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMTkfGb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DBCC4CEF9;
	Tue, 12 Aug 2025 18:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022276;
	bh=rfdm8pBdpFY+qCcu8P8ryTDH7zTwwzgwHHkD+t0i3uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMTkfGb1c9wUelVG2EV2aenjwOtF7jevF6eGwyP2bPS+89TZxQ2+lChhpvoheP4uv
	 74Kq4g53Ztpq4+xR3p/v5N1HTZT2kFuAgiDRAqFt0vUpkp8ukR5aPTfAdU7KjDy+6F
	 7hQO4URy8mH9AfG3oMclptYURVli6rlo0XZrnjpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/369] selftests/bpf: Fix unintentional switch case fall through
Date: Tue, 12 Aug 2025 19:26:11 +0200
Message-ID: <20250812173017.563205825@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1ec5c4c47235..7b6b9c4cadb5 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -309,6 +309,7 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 			fprintf(stderr, "invalid top N specifier: %s\n", arg);
 			argp_usage(state);
 		}
+		break;
 	case 'C':
 		env.comparison_mode = true;
 		break;
-- 
2.39.5



