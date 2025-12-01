Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA91A264617;
	Mon,  1 Dec 2025 11:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588636; cv=none; b=WWbIV2KEmKQLcocKeki8mpqitvQMPyYBq8scLP+bF21+y4/Fx3efCm5n+J1Nwizrb52+eHMgouU6l7TCa0w5ECaDnGwo83xa28rsJFVM6fgkO+/xszIyg+KYRN71jgyaWvz0mb69yLnJz0sM1qEB53GPuyZqYcYWhDR8chQsS4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588636; c=relaxed/simple;
	bh=EEUE0RgXseOeycU54lK3m1R1SQKsMhCckXSYiC2GeZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mcy0PBQrAF5YzQcr0Zzz6EULWF5hrRX4q/wmM03hrSAi99qNohl5M7vj83oSOSyfJqW9x3c1+AivGRLsSMdd23jyLonLBYvAn3N02OtsF6nA1EAapn5o8QX7TMyZdaIOSyIlb1/ZWkdWXYJe0jmNAlybXKaYK3+1OKwwiwZlrJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4U2MaSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4U2MaSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D36EC4CEF1;
	Mon,  1 Dec 2025 11:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588635;
	bh=EEUE0RgXseOeycU54lK3m1R1SQKsMhCckXSYiC2GeZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4U2MaSWjioHyhFlgq3DHMd6XGge/pMSJtFEOXUjZNGV4dN1t+2KYQYZn7+v/rbhH
	 yqzIwERkp7XlSSbsfJIuvwFLRA/INWvZf9ZZdOcKX0v/G340b2xiwQTkTx5Ke0PP/R
	 xDTC1j4x+FAns38MXQrJuCNv9HzfWAVTKkvTRr00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/187] selftests: Replace sleep with slowwait
Date: Mon,  1 Dec 2025 12:23:12 +0100
Message-ID: <20251201112244.266042170@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e3657454816b9..354c766e7c24a 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -164,7 +164,7 @@ show_hint()
 kill_procs()
 {
 	killall nettest ping ping6 >/dev/null 2>&1
-	sleep 1
+	slowwait 2 sh -c 'test -z "$(pgrep '"'^(nettest|ping|ping6)$'"')"'
 }
 
 do_run_cmd()
-- 
2.51.0



