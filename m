Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0C827F4C7;
	Mon, 18 Aug 2025 13:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523604; cv=none; b=rz+pK/V5J9PV3JPHWNYWHaY5Fl1Tj07kMR1LbjrBEYlA3FEUpwET4jjQqismBwxDp3YV0kZaUMETDX2LIW/K9YF0U+GRHCAkMYYpWgTKdMUWb1t3opIXPFPJIXFekWxZVIbgfYwtEgde1ZNGxxQDzhJqXC0HIY4feibJBqX6bvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523604; c=relaxed/simple;
	bh=pGAX19Sww9RbmaBZFdjxQcy0s5Z8NEF8/OU2GBWFqBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPtEKcReF7gtfymnyBRm8G85IMJ+sPJJc13yPwbGxUTVLbRpBXAksEOe9bSnHDQdAIUoUhRo9UVH7nULRml+qtzUnH/A+IBPk9/w9wERpHtVnZsnuZhyYMNtSExrJ2tvV818v/hL9MI3BODEjEiUFThOi5ayR59FW+h0+v3V8NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUhMlny/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUhMlny/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53C6C4CEEB;
	Mon, 18 Aug 2025 13:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523604;
	bh=pGAX19Sww9RbmaBZFdjxQcy0s5Z8NEF8/OU2GBWFqBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUhMlny/uwDkUuU8XbfZR/8cIui8/a6Y3lH5OrzQdHhyIVLr+6ScFR3fZ5jnpZZVU
	 vmnvARUBQ/j2My8IFZJaJXZpihQ07eDZVWgOBGuQ+A61iKSIs03X/cOSVDc8Fi9P7T
	 zW6471rfvz+HxJf3WwbWjrivw+YyNO3jlG8nDxuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 190/515] selftests: netfilter: Enable CONFIG_INET_SCTP_DIAG
Date: Mon, 18 Aug 2025 14:42:56 +0200
Message-ID: <20250818124505.689156453@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit ba71a6e58b38aa6f86865d4e18579cb014903692 ]

The config snippet specifies CONFIG_SCTP_DIAG. This was never an option.

Replace CONFIG_SCTP_DIAG with the intended CONFIG_INET_SCTP_DIAG.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 43d8b500d391..8cc6036f97dc 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -91,4 +91,4 @@ CONFIG_XFRM_STATISTICS=y
 CONFIG_NET_PKTGEN=m
 CONFIG_TUN=m
 CONFIG_INET_DIAG=m
-CONFIG_SCTP_DIAG=m
+CONFIG_INET_SCTP_DIAG=m
-- 
2.39.5



