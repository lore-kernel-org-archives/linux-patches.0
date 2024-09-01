Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14744183CC5;
	Sun,  1 Sep 2024 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208061; cv=none; b=Yaj8Yp7FYWHCOBNuDioli+WYIf/lnxaG8F15DRgxAWhKTBVS/cfQIZ+7/1blnW63pfJNvhkTQhZZTYWlmsI510mpv6YvyQW96vV6FoU/3YoqNVemvHSPuWKqpq1x/I+C8flMYzTsbSIRX/9Niq7LZhbMGPJeh9md1SvJp+g7hDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208061; c=relaxed/simple;
	bh=Qu59aJdfwS1ww/tz25Il5QmyGrYhtztalvFi/pgiN+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKGbOsWGFYyH8/Nmr/HNQUyWzyfWF2tvbBAwV67+rFL45C5q7kKWENnVk14uNZv05Mkk7dNHSxCW3o4yzniN0J9gu25VxXzMjrEf446j5C8Maro24TsxLUbr7/l1zpHscI/u4+fimSiVzQISEJQtDUuR061ReIZT2J7qSk2tJsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIUoN3fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIUoN3fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774CCC4CEC3;
	Sun,  1 Sep 2024 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208061;
	bh=Qu59aJdfwS1ww/tz25Il5QmyGrYhtztalvFi/pgiN+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIUoN3fhKHkq6VK9qiTkvR3rIkIn5X8sG7e6cjN+Y0fnhper1k7Z3SlzGnJkRYskr
	 cfhrqyn00atLNWAz4A91w1fqR9CHJsukItkeGWT9XzI35lVWmrBqTXrnrsSOOaRhDX
	 pse+ZyQ7TEVVUbcK/FPSYfA8sMbmgCcLXrXNT8AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 60/93] selftests: forwarding: no_forwarding: Down ports on cleanup
Date: Sun,  1 Sep 2024 18:16:47 +0200
Message-ID: <20240901160809.622335634@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit e8497d6951ee8541d73784f9aac9942a7f239980 ]

This test neglects to put ports down on cleanup. Fix it.

Fixes: 476a4f05d9b8 ("selftests: forwarding: add a no_forwarding.sh test")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/0baf91dc24b95ae0cadfdf5db05b74888e6a228a.1724430120.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/no_forwarding.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/no_forwarding.sh b/tools/testing/selftests/net/forwarding/no_forwarding.sh
index af3b398d13f01..9e677aa64a06a 100755
--- a/tools/testing/selftests/net/forwarding/no_forwarding.sh
+++ b/tools/testing/selftests/net/forwarding/no_forwarding.sh
@@ -233,6 +233,9 @@ cleanup()
 {
 	pre_cleanup
 
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
 	h2_destroy
 	h1_destroy
 
-- 
2.43.0



