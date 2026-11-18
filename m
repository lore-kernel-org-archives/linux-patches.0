Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018904;
	b=5btepeM5b5SfFuBy9cYyI2q51YyaLbDmZUUgiGPzAphMeXbftvrnKmMPg4ZtH9w8pChE
	 v8PoTc1WQjFzy9gSDTRsnNpJEgoRIHDtEiDFIZgJNwAuYfUmEqjiv3RxhWp4EH/4yuy5X
	 DQ9NRAoixgzMujc3ZJtpvXQSGXcAtOyqj8rieGVOWKRSrpL2JsDCC4hNSb+dfhXJVB4g5
	 H5z0XLu4iNvB4zVQDUfD5r/PrbJrcqdyZTtyAFulntZrSfXwzlio9DS95KFl+HcVg13QS
	 7OOucXGofg0zdHr3pe7z3/uUvjYgsQ8kuC9ff8RclYvaYpJF8mG48cnhcxsAcZaq5Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w7dCk6l3ysqc6uQg6q4iyqkkinE4BzP4zXdwT6TYAZs=;
	b=dyCI5nc0D+9OKMcS6AfV2dYj+Z0Gpb2MuwyEcIFIhi9O57Dm/sHK4TFJlIrOHHlqQ9n8
	 c6mCjfOzzeaPhsxuz5aNei7gurvqso4JUEH5ZwDlykPxMREsBZlB4W2JNLuj/tCMjUbgV
	 TLSWF3vrmHNJQT2bP58Ci0+hV4y088pmzjqULe/fSbsQoECZpcjI4g4k/qsnXNrjB7rQm
	 Lf2GmKpPpFyY1NhRiwSBCpZWfpPmVnnUJi/jXIv/+zGZYzkZaxx8zYwuRn6lPDzshoJr5
	 N2HuFbTgT4OOSLKfUp+OWnymKTJyZosfenTy71ERjLNyfXCdv9bFM4Dlw+J/Dko3kMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsSrnGkX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D29606A31C;
	Wed, 18 Nov 2026 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsSrnGkX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119D11F000C4;
	Wed, 18 Nov 2026 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018904;
	bh=w7dCk6l3ysqc6uQg6q4iyqkkinE4BzP4zXdwT6TYAZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsSrnGkXzJc9trllskzWOcjtrAhTt1pwrnpw6FhUue8UBm3EBZTkca7P+Q/3fsQ4p
	 A8CDqvmOz8TAlmSufhLYMgYe1aUlIIYQMGo8olz6p/FcRbGlTuld+MLjpHrHCv5sMA
	 yr6PVJFNsnBnb+n1J/M5rTDOm8/9bETkK1iJG53o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1407/2651] perf test attr: Propagate the return value from the test to the wrapper
Date: Wed, 18 Nov 2026 15:44:07 +0100
Message-ID: <20261118150338.663643166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit f8596112cbad0072cdc957c0ea06695afda246dc ]

Currently it does not matter what the python script actually returns,
the test always passes, as the $err variable is always 0.

Fix that.

Fixes: 8519e4f44c2af722 ("perf test: Add a shell wrapper for "Setup struct perf_event_attr"")
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/attr.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/shell/attr.sh b/tools/perf/tests/shell/attr.sh
index 5a4e43b2471de..307e1535795a3 100755
--- a/tools/perf/tests/shell/attr.sh
+++ b/tools/perf/tests/shell/attr.sh
@@ -18,5 +18,6 @@ trap trap_cleanup EXIT TERM INT
 shelldir=$(dirname "$0")
 perf_path=$(which perf)
 python "${shelldir}"/lib/attr.py -d "${shelldir}"/attr -v -p "$perf_path"
+err=$?
 cleanup
 exit $err
-- 
2.53.0



