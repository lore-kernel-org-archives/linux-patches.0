Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747B013AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59A1C433C9;
	Mon, 26 Jun 2023 18:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804133;
	bh=6vnA6jPQa68N90ix/jLKmQOG1Pp5Q2rLiyWlAqmtkco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOwKRRQk12eHuTBVXSQn9li/ywOoGoxqu7IbnoSzOj3383INDgjRnxOeu8Zo43COX
	 y5XBm+tGKFjAc6oTzAnJa3xQntWvsE8MjAjfz0Zvp+ZDF1E7d4GJo6ovxoI7fRPBto
	 ltiIvLHMLPuL+hdWY/VqJA7UqipOP/T6Jlms1Fho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 024/170] selftests: mptcp: userspace pm: skip if not supported
Date: Mon, 26 Jun 2023 20:09:53 +0200
Message-ID: <20230626180801.641318805@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit f90adb033891d418c5dafef34a9aa49f3c860991 upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the MPTCP Userspace PM introduced by commit 4638de5aefe5
("mptcp: handle local addrs announced by userspace PMs").

We can skip all these tests if the feature is not supported simply by
looking for the MPTCP pm_type's sysctl knob.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 259a834fadda ("selftests: mptcp: functional tests for the userspace PM type")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 192ab818f292..38a1d34f7b4d 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -5,6 +5,11 @@
 
 mptcp_lib_check_mptcp
 
+if ! mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
+	echo "userspace pm tests are not supported by the kernel: SKIP"
+	exit ${KSFT_SKIP}
+fi
+
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Cannot not run test without ip tool"
-- 
2.41.0



