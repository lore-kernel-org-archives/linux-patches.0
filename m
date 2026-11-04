Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831243;
	b=fNJ0YQgHJlA8is8UAHDBvFwco/xdBl3L2OHJ+STpaIZ29yWm2s83n8n03sDOIShShPmY
	 ncI5uQS9kUniB3l4qeMk5nZgL/m2HScHHPrKM/HOuv1O+NKJqCoD8t5YWBxbLtkDklAZa
	 L3BQxfYtFgQHa6Aw0kZLgVlget64QTI8WoeC40pttld/NMpWCflC1PBt8efU5ofkimLHc
	 Y/yQy5JgIUkIJhH6QYD8Fq5m3/colfgV3OTYAwUcdWPZNAzsYd5Je2AJW3T97aYhBdKGj
	 oOAosoY8XMgU/tSBUOldM1qIQ8ps0nqrIKIvvFjtPDCAwinMO1yUfeNSs4m5XhBMTfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rw/CtTCSTi2ELrZebKpkOHnC35AaaNatIIGK58sA6pA=;
	b=C7+YSUxaB9HnY4VzQqQz2cmtm3CtZboR3JirYzKuKzIMzKPyE/jA0/AFtLn+3edsUKx0
	 HDBB+uvXn1nxEwrEoO8P7ZAWAiyvQOYaOUW9/6Fedbi7RuLX8rbNvjwC/U+HMM630rYNB
	 Baf0FGtJUpPU0UJH9Ajr9Ofcvu+UiHsM8z+YASG+QhWj76dPP9+YzzDx6UTo8u6qsXa5K
	 RyHk7Fi8pEVyrUg+8gQLy/xDeHaFsdjg4qxWVIIb3NZzsYvnKAbPuGqG2SfxRxEXQuV3i
	 khLRh3nLrHNZurzpcn9YstRlhLT2z8+FjYS5By5QQlwSO54TCEHe4w+/QCMdf5dNHng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEwQ9fzE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66367606A33E;
	Wed,  4 Nov 2026 22:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEwQ9fzE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09851F000C1;
	Wed,  4 Nov 2026 22:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831243;
	bh=rw/CtTCSTi2ELrZebKpkOHnC35AaaNatIIGK58sA6pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEwQ9fzEEpLsoX/vwcRAV6iHo6OZ6TNzFBUWOhOHqjPy+YRF0YqegLRSWsZrGZs8Y
	 jlZfqsRwKKXAsdYXLrSMz3Y49cFP83gJq/GWOVDv+c0OrbRQcNqqd+4boIHwMyTBNA
	 sPpjgbU7ZMqXAxcPrGnf8z7MTtpA30lI14knSUiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0585/1005] selftests: ublk: increase timeout to 150 seconds
Date: Wed,  4 Nov 2026 16:05:18 -0500
Message-ID: <20261104211100.247254787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 4968fb7cc60676040258c8867f22931c8735126f ]

More tests need to be covered in existing generic tests, and default
45sec isn't enough, and timeout is often triggered, increase timeout
by adding setting file.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c4fa55f85c47 ("selftests: ublk: install test_common.sh and trace/ scripts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/Makefile | 2 ++
 tools/testing/selftests/ublk/settings | 1 +
 2 files changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/ublk/settings

diff --git a/tools/testing/selftests/ublk/Makefile b/tools/testing/selftests/ublk/Makefile
index 97be60993a213..0062784b1a308 100644
--- a/tools/testing/selftests/ublk/Makefile
+++ b/tools/testing/selftests/ublk/Makefile
@@ -40,6 +40,8 @@ TEST_PROGS += test_stress_03.sh
 TEST_PROGS += test_stress_04.sh
 TEST_PROGS += test_stress_05.sh
 
+TEST_FILES := settings
+
 TEST_GEN_PROGS_EXTENDED = kublk metadata_size
 STANDALONE_UTILS := metadata_size.c
 
diff --git a/tools/testing/selftests/ublk/settings b/tools/testing/selftests/ublk/settings
new file mode 100644
index 0000000000000..682a40f1c8e6f
--- /dev/null
+++ b/tools/testing/selftests/ublk/settings
@@ -0,0 +1 @@
+timeout=150
-- 
2.53.0



