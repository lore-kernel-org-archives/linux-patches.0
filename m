Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81EC308F13;
	Wed,  3 Dec 2025 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776222; cv=none; b=Vf+67EtiDU2ln0jit6zMWe6Y+z2EfkIo734Y/KzYaSQtxxvYq7304y+K/fA3ToooMolNLU8BMeFvLxuEUf4mtki9iwLhiqJVaxOrwBOvYUeKF2Nn9+PbG4Vgljy6Z4XW4iBfNbqbLK+Mpqvd6KqYjmq2UEi8NDNgbOcX03icr5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776222; c=relaxed/simple;
	bh=13eJnYr1HR2RkqIG0wso0vg4VuBC07KSTY8iSzB0uxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0Zo+7C/L7xV83dz9sLnJP0RsEnDRhXeRfIeXKpAxeIBVyZuJAudGZI72RYUOqTqbeDXg5DTGIAdn8/uC1qU6rWQ3w8sItCMhRixDcGJCtUvjuQiKCJN5OupWDwHBh4s+Bt/bIBGzgL1ZTY3UN3TmpmruA7qYw7TJMDc13J5uHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9UvmeEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9UvmeEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7AFC4CEF5;
	Wed,  3 Dec 2025 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776222;
	bh=13eJnYr1HR2RkqIG0wso0vg4VuBC07KSTY8iSzB0uxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9UvmeELPEpPAOf/Me750ybNIf+8f0yR3OdnV6IrAXJtJbiwdYwNRKMiDujeod82L
	 ZGGpe6HwB+UOODDaDNDbQthCHPVNCT1gnmBJTol3KIevoAz+52VjaClW+QNhF3JSp8
	 bkvG8CtzFowQXFvrGRqkM0K28Kq39EdFWk6rk0kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/300] selftests: Replace sleep with slowwait
Date: Wed,  3 Dec 2025 16:25:21 +0100
Message-ID: <20251203152404.953619835@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 806c409de124e..2f5cdbc5dee39 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -183,7 +183,7 @@ show_hint()
 kill_procs()
 {
 	killall nettest ping ping6 >/dev/null 2>&1
-	sleep 1
+	slowwait 2 sh -c 'test -z "$(pgrep '"'^(nettest|ping|ping6)$'"')"'
 }
 
 do_run_cmd()
-- 
2.51.0



