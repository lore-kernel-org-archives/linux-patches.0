Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833F5313271;
	Wed,  3 Dec 2025 16:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777802; cv=none; b=vDkwZ7H8bnVUeqgSYmSfR4yIhUnKAA5iqV1UywTqpTwjWRJryFidazP4eh8aZOjMspIoVPOR28RIJwPrnc7jXqMJwc/rwnDiCICcITrevS6bx0oz7f3atrixLMp2SJhIOIiv/2cMIqDEZTKMHsqDxFt//4RtJeVmUr6pUBhz5+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777802; c=relaxed/simple;
	bh=y8dCy9c+xQAj3EdJJIwmxDo9RhFu+aBevTZBVs9QW4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWplQSN6O0yywtICt4L1OQkLxc+pXLUeA72ByhxIE7P2NS7NF7U/lorGSPm4Kq3auXGiz94bJKol5XYXZxoSd76LmGQlsdfgaYtBbUMzOoYM8DSA8WKtOrdTfx1QU6qNa2qdtC0quY0dP+3Yzu5H1EguK7SFUD5WuDJGHMv/Xrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6JCli5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6JCli5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5A4C116B1;
	Wed,  3 Dec 2025 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777802;
	bh=y8dCy9c+xQAj3EdJJIwmxDo9RhFu+aBevTZBVs9QW4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6JCli5X9N5Ylxc1w86Gm+ttYQ8iTbMbXrRxF1O6kxyZJGjMeaIRuH03W6ANek9To
	 rsqdxy22okvRNb67P6KG+Tlo6foI8DJVO8YPz7C21v3eaKwvbDzuFq9rGkpcd4HeZZ
	 xiwofIyAPOaasqPc6HngPg+ck8QgXTjztnpeHR2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/392] selftests: Replace sleep with slowwait
Date: Wed,  3 Dec 2025 16:25:01 +0100
Message-ID: <20251203152419.639773828@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0e43b9e95f4dd..7bca859223a57 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -186,7 +186,7 @@ show_hint()
 kill_procs()
 {
 	killall nettest ping ping6 >/dev/null 2>&1
-	sleep 1
+	slowwait 2 sh -c 'test -z "$(pgrep '"'^(nettest|ping|ping6)$'"')"'
 }
 
 do_run_cmd()
-- 
2.51.0



