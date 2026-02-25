Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD7125A655;
	Wed, 25 Feb 2026 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983539; cv=none; b=poDTZ/hJ3mCVdYrCIMoePZ2SYfOTUM71GOT0egiE/jYIYpsybd4JL7KXvzaTkzSyvfQiYrJtBNbVnSfuSSN6srOibvRQ0Xq237zpatfzBqTTp0MpsHhxL41DWHJizeGfRK8PMkuSFFFVxgs0/dXGPjYB5v9uMh8Ofux6APQ6xtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983539; c=relaxed/simple;
	bh=99jMZrr6yrfDHYCyqa8IEFWqLxIeUN4x20CcYSAOscI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=py3bVnxiRdmpP2QJ4buQ3eNDwknD6SX/pH365d6tlVALuZvoO9KLI1ilxyABClsBzQZS7mlPJa+qzXcc0LA+yv0+7ZQ/vkVN0dQhI2bRROHRYN8DD3FWMp14wTJXOUeWIe4L8K0IH0y9jhhP8AxOsxj2mI9HaXK6ZAaU+dgLLNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBgx+m5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBgx+m5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F8FC116D0;
	Wed, 25 Feb 2026 01:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983539;
	bh=99jMZrr6yrfDHYCyqa8IEFWqLxIeUN4x20CcYSAOscI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBgx+m5wi3Zz6pG7GgFmb8Mhfg/MYgPS+Qy8NcYW9ISlFBIoa4BJ4f1S24w9E4C+W
	 d2FTPfpMWZBjvcvyS/y6v6SsEEnJ+R//U9fwz7y0N5016fNNKJMVTxSpGsntDIKVN9
	 t5kwqkg4bRupUpe6N1RGPLxYqTE/V8DBULkU5If8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 643/781] selftests: netconsole: Increase port listening timeout
Date: Tue, 24 Feb 2026 17:22:32 -0800
Message-ID: <20260225012415.572890363@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@google.com>

[ Upstream commit a68a9bd086c2822d0c629443bd16ad1317afe501 ]

wait_for_port() can wait up to 2 seconds with the sleep and the polling
in wait_local_port_listen() combined. So, in netcons_basic.sh, the socat
process could die before the test writes to the netconsole.

Increase the timeout to 3 seconds to make netcons_basic.sh pass
consistently.

Fixes: 3dc6c76391cb ("selftests: net: Add IPv6 support to netconsole basic tests")
Signed-off-by: Pin-yen Lin <treapking@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260210005939.3230550-1-treapking@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh b/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh
index ae8abff4be409..64d3941576d5d 100644
--- a/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh
+++ b/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh
@@ -247,8 +247,8 @@ function listen_port_and_save_to() {
 		SOCAT_MODE="UDP6-LISTEN"
 	fi
 
-	# Just wait for 2 seconds
-	timeout 2 ip netns exec "${NAMESPACE}" \
+	# Just wait for 3 seconds
+	timeout 3 ip netns exec "${NAMESPACE}" \
 		socat "${SOCAT_MODE}":"${PORT}",fork "${OUTPUT}" 2> /dev/null
 }
 
-- 
2.51.0



