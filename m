Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3223612DC;
	Wed,  3 Dec 2025 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779310; cv=none; b=Z9L5bsfVA8P7yI4Xk3G0k2hzwRHCuY0tVidfaAxnr9RqnJBjs7A6NH2HaDvzZq5qCLhJpESdAZec9iYbTjcTCCaaixX7gkQM4fwyUR90YFGoyWssZ0yLmuC4avuOqami2TaAGQCBmQMhmVM8OEuAznBZ4xPCOCCqn9CRYrpzuAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779310; c=relaxed/simple;
	bh=I1JrhXmYxwOQsfD92ypRx3Mv4MXOezTJS9GSChIM62c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDP8GBPB+5Z1DfZuA43HTvGW11uurhL6+FCl3aIh3P8WLayGVhpWxE0/b3jVgiFWKLkAZgtFc5LskUV2Kg7vwTAQV8ubJHRu4YZrg7UIGTQjei9t+mURYrpBfTpEPArg6I1Uv7Rns1A70pYw8gWkqev6O//2QNa+PcRgibBf6QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wd4o3Nq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wd4o3Nq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B00C4CEF5;
	Wed,  3 Dec 2025 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779310;
	bh=I1JrhXmYxwOQsfD92ypRx3Mv4MXOezTJS9GSChIM62c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wd4o3Nq0OFLhdmBUKiWMk04QMUSm038/o5qjV7AgCAkH32bwco49SzSOMEwFL+cTk
	 ZTuUN7BKFqA3RY54QO1QSKn7Yvp+EivXI+6024gBv9Gss8xoKwKl45Lw9XiKDiHZz4
	 PRsHUZ5fsZ73OVYUO0EEOMPBJuxbFjbfcX64KYQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 220/568] selftests: Replace sleep with slowwait
Date: Wed,  3 Dec 2025 16:23:42 +0100
Message-ID: <20251203152448.780758510@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 2f186dd5585c3afb415df80e52f71af16c9d3655 ]

Replace the sleep in kill_procs with slowwait.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910025828.38900-2-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 135e19db39eb0..bb20dac178698 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -194,7 +194,7 @@ show_hint()
 kill_procs()
 {
 	killall nettest ping ping6 >/dev/null 2>&1
-	sleep 1
+	slowwait 2 sh -c 'test -z "$(pgrep '"'^(nettest|ping|ping6)$'"')"'
 }
 
 do_run_cmd()
-- 
2.51.0



