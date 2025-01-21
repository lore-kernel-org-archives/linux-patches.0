Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532421F472D;
	Tue, 21 Jan 2025 18:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482648; cv=none; b=q0A8OF+cs7xK8Td/xxf8K4g1blM0gAl+qn2+6wZB2wxKAXvaxhjscBeuLOMo6bIbAW7bGkFDhhRWOrKBGYn8u/HfkDqcEj47/2y5J7p0BvVmmYGm+BZ23qejdVSWy9AvqmWAjf9sdeeFZti6q3Qne1o76OPALSwUfbG/Gjdn5Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482648; c=relaxed/simple;
	bh=mCBniI7UqLpToS1nW6ZUfhUqgEbtQLU78ZbgmxIFRsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrZmr+XVsbhh6g96IHpyuIg8sC+QNmFJIHSJ7Cga4NxylslhbbA37PPbxpzdmsJ6ch2fY45BaIToLBEckrPH8GVrKpyofeNsnnyoM6K3peBflj59MRxNoOiCp3Ml7dYiL2Y8mx493fAxhPi1xDl8mMiC5xrR1+zKb39V/U7O+RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqkiGDze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqkiGDze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C79C4CEDF;
	Tue, 21 Jan 2025 18:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482647;
	bh=mCBniI7UqLpToS1nW6ZUfhUqgEbtQLU78ZbgmxIFRsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqkiGDzeMhMUWuyMOSOnnkymNfFFH91HgvmhBhYnh8rAN2vkFQN7MBxWb0qf9KlBu
	 ziuXF8jGr/ACWuUvrOkWSHWFI01HGzrYkzqU5Tu4IIayufTww/RVbYbivsFePIHYUJ
	 U7hCHLjX2C6YPRHyFgPyDtMP0WfLI2I1SqdguNac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/64] selftests: tc-testing: reduce rshift value
Date: Tue, 21 Jan 2025 18:52:24 +0100
Message-ID: <20250121174522.516459648@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e95274dfe86490ec2a5633035c24b2de6722841f ]

After previous change rshift >= 32 is no longer allowed.
Modify the test to use 31, the test doesn't seem to send
any traffic so the exact value shouldn't matter.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250103182458.1213486-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tc-testing/tc-tests/filters/flow.json | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/flow.json b/tools/testing/selftests/tc-testing/tc-tests/filters/flow.json
index 58189327f6444..383fbda07245c 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/flow.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/flow.json
@@ -78,10 +78,10 @@
         "setup": [
             "$TC qdisc add dev $DEV1 ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key dst rshift 0xff",
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key dst rshift 0x1f",
         "expExitCode": "0",
         "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
-        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys dst rshift 255 baseclass",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys dst rshift 31 baseclass",
         "matchCount": "1",
         "teardown": [
             "$TC qdisc del dev $DEV1 ingress"
-- 
2.39.5



