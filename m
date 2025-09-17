Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037062F7459;
	Wed, 17 Sep 2025 12:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113028; cv=none; b=L/qe/x9KGwr05XslRbdPTIJ49MBKRD7xk4Zdc8P9N0+DaFyNXEHmoqPjf8DyfNYIbEtRfT0y9bAcHKT08ABaFb312C8NcscW4N0Q8ZfIK3IuBku/2XlSyqCN+SEsWxPGGzZc/WQmreWbDVeZ5hquKXV2XazNQ1oeQGrOgKUW6wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113028; c=relaxed/simple;
	bh=ZT0oonKPwO1nzW4aI8VxZ1kmbPKqBkWIiLBCM4E4opM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJDOV5r2Qvz9MsYJyaxWhPLBRbURRYPK3IhaFcGtJaTtb5tihKjZtnaWTov48poHBxOmxroD7wUoXPxupx3jEWtAzzPtHin/QUe3KqRaF4o4q3lmUk4LqIgnjDC+0C9JGTFJyJgzcvhYDZMD0gSc7ciWHL6nuZT2zlSD0caFm4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqEWq1fR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqEWq1fR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B626C4CEF5;
	Wed, 17 Sep 2025 12:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113027;
	bh=ZT0oonKPwO1nzW4aI8VxZ1kmbPKqBkWIiLBCM4E4opM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqEWq1fRkefFtn7IfM0JXF/KOc+PDbBY0ZyMjSu2q9NCha9nabQDamOnRZeLPq9Qn
	 dWMSgpA8bKikrtxh48GD6NIY+0Rd5/o+KA1dOPhJkIhbfYXdsZHqlPxBEfDHQ2qPZ2
	 4TIzd/mZ3USSei9aAZ+ih09kjzJgAKXXLg89pMFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Davide Caratti <dcaratti@redhat.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 147/189] selftests: can: enable CONFIG_CAN_VCAN as a module
Date: Wed, 17 Sep 2025 14:34:17 +0200
Message-ID: <20250917123355.461114065@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit d013ebc3499fd87cb9dee1dafd0c58aeb05c27c1 ]

A proper kernel configuration for running kselftest can be obtained with:

 $ yes | make kselftest-merge

Build of 'vcan' driver is currently missing, while the other required knobs
are already there because of net/link_netns.py [1]. Add a config file in
selftests/net/can to store the minimum set of kconfig needed for CAN
selftests.

[1] https://patch.msgid.link/20250219125039.18024-14-shaw.leon@gmail.com

Fixes: 77442ffa83e8 ("selftests: can: Import tst-filter from can-tests")
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://patch.msgid.link/fa4c0ea262ec529f25e5f5aa9269d84764c67321.1757516009.git.dcaratti@redhat.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/can/config | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/net/can/config

diff --git a/tools/testing/selftests/net/can/config b/tools/testing/selftests/net/can/config
new file mode 100644
index 0000000000000..188f797966709
--- /dev/null
+++ b/tools/testing/selftests/net/can/config
@@ -0,0 +1,3 @@
+CONFIG_CAN=m
+CONFIG_CAN_DEV=m
+CONFIG_CAN_VCAN=m
-- 
2.51.0



