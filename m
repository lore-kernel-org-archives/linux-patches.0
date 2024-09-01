Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C1E183CA3;
	Sun,  1 Sep 2024 16:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208064; cv=none; b=jI/Cest+5OKulJCojr2dCflo5j/Plwf6s0us3NY0M2bVgAJmc+Ef78wE7pvrHyVc5DNgcUzqc0CohcDzFYHNwlHJ8/cf96GAr809r4l+9EXBPu1M414xHU8K+gmjfIOli8bjkFZq5rk6tDNCiko2nucEs6PXmWBqGOvlS7yQd20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208064; c=relaxed/simple;
	bh=bTy4rdCtEERnwW+IBh/0BdCUVDwnD7HEMkOhuS1oD38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAAXANSg8PP15tOaz32LNAukrz03Bjgs0jAErDsGxyATadCqMWuSHjP03xvI+DQotTzedcW2Hi8Jv6A4/FGGb3z0LglzyiaYUNqxTNGYVvMWldpPFhqiKqZUPJHeDpHaQ/TGvzvIkWk53y1L5lvjbL0cjpu5P86wQgtMrtC8rFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhgJZ4N8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhgJZ4N8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3A1C4CEC3;
	Sun,  1 Sep 2024 16:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208064;
	bh=bTy4rdCtEERnwW+IBh/0BdCUVDwnD7HEMkOhuS1oD38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhgJZ4N8Y/Iy85T8sR6Ya2zAtq47wEy3Hc8YM0gyylAs1C6Ub8b0D3FY+CpRPDk0l
	 aRy7uxiSlRTlqFcC5WoeZ/Weguf8cveldZ+NsGs0RqRgxBPDAhZvDHUgtsI5V4Ls8+
	 hBvtPQN0QfRHKAhmXgWH15w5R7IzBUsUGm2aXxU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 61/93] selftests: forwarding: local_termination: Down ports on cleanup
Date: Sun,  1 Sep 2024 18:16:48 +0200
Message-ID: <20240901160809.661837519@linuxfoundation.org>
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

[ Upstream commit 65a3cce43d5b4c53cf16b0be1a03991f665a0806 ]

This test neglects to put ports down on cleanup. Fix it.

Fixes: 90b9566aa5cd ("selftests: forwarding: add a test for local_termination.sh")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/bf9b79f45de378f88344d44550f0a5052b386199.1724692132.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/local_termination.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/local_termination.sh b/tools/testing/selftests/net/forwarding/local_termination.sh
index c5b0cbc85b3e0..9b5a63519b949 100755
--- a/tools/testing/selftests/net/forwarding/local_termination.sh
+++ b/tools/testing/selftests/net/forwarding/local_termination.sh
@@ -278,6 +278,10 @@ bridge()
 cleanup()
 {
 	pre_cleanup
+
+	ip link set $h2 down
+	ip link set $h1 down
+
 	vrf_cleanup
 }
 
-- 
2.43.0



