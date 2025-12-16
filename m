Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D3C34EF0A;
	Tue, 16 Dec 2025 12:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887856; cv=none; b=fcojpHdrdRyPbeKi8xS5p88vpc1t3JMJLnvL4E9hM+rgqXyD9q25Ne+iHO13klI39rgpWUCqeQJr9sluM4T5pmZxI6O38POqKZftrt7TRaN0gfIXDZCNYUpYvTcsBF2N1Cq5W0j8Rm9Sbz6OPuJ6XRe9s2XLOSKHr7C22FjLJ90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887856; c=relaxed/simple;
	bh=hhHL0gmhMsZFwfb25yZ/LK9RQhmbswptqTsORV1ZK30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaVmu9ejqSwo9/kI3hfZXLyUwiDx8tOMWg8u3QJXRWTssYNgXP7yhoRxYhhbI9K3ppDq7Uo7z22h0Q5XglAClrif3SvYnSwR6loLyHTakCLe8pXaCTThVG+y2x88K25Rim7lbQLSENbfwgCOt5OD/o6x2t0rHkdRGU6s0KMq6kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7oejQvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7oejQvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9F7C4CEF5;
	Tue, 16 Dec 2025 12:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887856;
	bh=hhHL0gmhMsZFwfb25yZ/LK9RQhmbswptqTsORV1ZK30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7oejQvUsJylr8FW8uM9uaoVRyokOV5nv9cxgGDgMVEnT0NY41F689+55LNCkiALy
	 CGGZQ+WOwrSIJfG6yttxRfkJPWo66NR/0cjsb7SL9lfcuaXw+rz9gbP7A4jypUWBpr
	 3ikb1Ke6SHwotNr+5U3q0UlKVZkRBjsq9xmH6SvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 359/614] rtla/tests: Fix osnoise test calling timerlat
Date: Tue, 16 Dec 2025 12:12:06 +0100
Message-ID: <20251216111414.368830136@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit 34c170ae5c3036ef879567a37409a2859e327342 ]

osnoise test "top stop at failed action" is calling timerlat instead of
osnoise by mistake.

Fix it so that it calls the correct RTLA subcommand.

Fixes: 05b7e10687c6 ("tools/rtla: Add remaining support for osnoise actions")
Reviewed-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20251007095341.186923-3-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/tests/osnoise.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/tests/osnoise.t b/tools/tracing/rtla/tests/osnoise.t
index 08196443fef16..3963346089207 100644
--- a/tools/tracing/rtla/tests/osnoise.t
+++ b/tools/tracing/rtla/tests/osnoise.t
@@ -37,7 +37,7 @@ check "multiple actions" \
 check "hist stop at failed action" \
 	"osnoise hist -S 2 --on-threshold shell,command='echo -n 1; false' --on-threshold shell,command='echo -n 2'" 2 "^1# RTLA osnoise histogram$"
 check "top stop at failed action" \
-	"timerlat top -T 2 --on-threshold shell,command='echo -n abc; false' --on-threshold shell,command='echo -n defgh'" 2 "^abc" "defgh"
+	"osnoise top -S 2 --on-threshold shell,command='echo -n abc; false' --on-threshold shell,command='echo -n defgh'" 2 "^abc" "defgh"
 check "hist with continue" \
 	"osnoise hist -S 2 -d 5s --on-threshold shell,command='echo TestOutput' --on-threshold continue" 0 "^TestOutput$"
 check "top with continue" \
-- 
2.51.0



