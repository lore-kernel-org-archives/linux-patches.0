Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE7F2F8BE7;
	Tue, 12 Aug 2025 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021366; cv=none; b=C2h5Eq9adnh9Zqzn3QEg98zUtuL9E98FsNziP07w7jba2QkPCApOmWkmniW3ZKSRTMHH0k8c78waaKfAugpxs3YwbYuDeUasiKIFOkSGUEzXguW5ISqZ7tzjGsNuOkzagw5hQmNPBAqQi3vo8ZlquIpWSOpNM/wjfhldPMY2FkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021366; c=relaxed/simple;
	bh=4Fj6jzC+LExe/SF10wm4FAnlriFIko3mSbyky6fS7/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npmxR0CSR1PLfdsNoNQUsV4se9Rsl0Xwzl86iCE4WX5Wy+7szHYEswnHgPg9KrW/gB2n2gvBbqSg4cKDIC26C2ujGTHZoRhHbZSkl5vT7TFMBMIkWex65WhL78odcIw+Pt0ndxsI6OKO7n+rHwV8SQttkFqQJLTZ78K28gdGvCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRspyM/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRspyM/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EA4C4CEF6;
	Tue, 12 Aug 2025 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021366;
	bh=4Fj6jzC+LExe/SF10wm4FAnlriFIko3mSbyky6fS7/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRspyM/K4M5+wz1iy1PnLqiDXcY3yhZDvPwTsPZclQhIKcz6RFSUhOZhBAVmlksok
	 +NMytWsCNlZJ+lSDeFx8xmBekptzs6wUUjTxKksNb/v7UYlSVjKPR0bEILkUM+ZTrX
	 BHUQzh5XYJG4iLYFsVlzgrVGxvxAG+teJt6yMDOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiumei Mu <xmu@redhat.com>,
	Shannon Nelson <sln@onemain.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/262] selftests: rtnetlink.sh: remove esp4_offload after test
Date: Tue, 12 Aug 2025 19:28:09 +0200
Message-ID: <20250812172957.389948445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiumei Mu <xmu@redhat.com>

[ Upstream commit 5b32321fdaf3fd1a92ec726af18765e225b0ee2b ]

The esp4_offload module, loaded during IPsec offload tests, should
be reset to its default settings after testing.
Otherwise, leaving it enabled could unintentionally affect subsequence
test cases by keeping offload active.

Without this fix:
$ lsmod | grep offload; ./rtnetlink.sh -t kci_test_ipsec_offload ; lsmod | grep offload;
PASS: ipsec_offload
esp4_offload           12288  0
esp4                   32768  1 esp4_offload

With this fix:
$ lsmod | grep offload; ./rtnetlink.sh -t kci_test_ipsec_offload ; lsmod | grep offload;
PASS: ipsec_offload

Fixes: 2766a11161cc ("selftests: rtnetlink: add ipsec offload API test")
Signed-off-by: Xiumei Mu <xmu@redhat.com>
Reviewed-by: Shannon Nelson <sln@onemain.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/6d3a1d777c4de4eb0ca94ced9e77be8d48c5b12f.1753415428.git.xmu@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/rtnetlink.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 855505c40ed8..c9ba4d269c38 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -854,6 +854,11 @@ kci_test_ipsec_offload()
 	sysfsf=$sysfsd/ipsec
 	sysfsnet=/sys/bus/netdevsim/devices/netdevsim0/net/
 	probed=false
+	esp4_offload_probed_default=false
+
+	if lsmod | grep -q esp4_offload; then
+		esp4_offload_probed_default=true
+	fi
 
 	# setup netdevsim since dummydev doesn't have offload support
 	if [ ! -w /sys/bus/netdevsim/new_device ] ; then
@@ -943,6 +948,7 @@ EOF
 	fi
 
 	# clean up any leftovers
+	! "$esp4_offload_probed_default" && lsmod | grep -q esp4_offload && rmmod esp4_offload
 	echo 0 > /sys/bus/netdevsim/del_device
 	$probed && rmmod netdevsim
 
-- 
2.39.5



