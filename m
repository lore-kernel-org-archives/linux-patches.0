Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7C8225413;
	Mon, 18 Aug 2025 13:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525362; cv=none; b=cGjsu1e+KBSC4XmaYXZpE2aMK8uvIwL7+H4NXo3cI/nOFIdeY289pol7HEq5LMcgudr5ucDT6AhtIFsyGlms/r4WOO9u+uUeR5AtOLhdeZSduHSKzfOPEn2cgW6Np0Qf78MVpD01lOa2jjq0EbCZr+RmpqjogYj1TZ8RdvVKzig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525362; c=relaxed/simple;
	bh=7u2iPHZQFr6eUPXAW/bKvYILCOjHZJ8UoD5D1kNEoxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2ljUlzZWdV10G9GZM4j/iWe7ojb54nJPISDY1fpu+CgmPciExWQLfX7Cf8tAHwSSfTHa8E1+VSt1G34ctssIMD8TPLuFCbvjPjFFj2ZYNlEAxDroCxJXmbRGYT6eqKa+2i8ECkYhDoZ4kE0muUgzY7XBvH+dTm0jp9EsNZDa6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWz/LXcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWz/LXcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D30C4CEEB;
	Mon, 18 Aug 2025 13:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525362;
	bh=7u2iPHZQFr6eUPXAW/bKvYILCOjHZJ8UoD5D1kNEoxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWz/LXcqdDtzOUZw+dhhbY6eousVQJVuunIcNhuPS1xGSoXAXz11TajMahYWrP/VN
	 iUmfjzg5s/X2fxxSJ2MvXQ2rx7nrrDIaDTpFiW1U2WKpswQMifZwIAu5ymvLMRiwd5
	 0zdqa0gB0iRnoY57qhryfSvLKpcnwtmxcMvfEG6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 206/570] selftests: netfilter: Enable CONFIG_INET_SCTP_DIAG
Date: Mon, 18 Aug 2025 14:43:13 +0200
Message-ID: <20250818124513.743357024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 363646f4fefe..142eb2b03643 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -92,4 +92,4 @@ CONFIG_XFRM_STATISTICS=y
 CONFIG_NET_PKTGEN=m
 CONFIG_TUN=m
 CONFIG_INET_DIAG=m
-CONFIG_SCTP_DIAG=m
+CONFIG_INET_SCTP_DIAG=m
-- 
2.39.5



