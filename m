Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE7B35690D;
	Tue, 26 Aug 2025 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217372; cv=none; b=WiqaII2IFF9NTda0nqEp3QcL9dtsXHGNVfz/QpE148qHDrxJiVz/ev6brMKfF4ampBG4RFMHSFypY8XP/tI4a1PRoDIbfCdYzd/9Mo7bstSq4N0ZJ/uQH0dJTb1U2w2HzZXGcHCQqQR0mjEEpskoD6+WiCYeftXqbk42cV2juJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217372; c=relaxed/simple;
	bh=6bfWs55TUWoaEWiE4gHkeUDN1oeMG9Z+7vWJNvpDxfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPaEizpHYzlb5jlpP/RUCCJdzudQ8H9ewwKTrmvm9/tc4RcGSXiSyY6E0peZgL/wQTIMNWSwuESYqhqXoCxPUi7Gpoo/ylW4Od7xzcv9/oQ6OyU0O8wmbdqSt/Dz/V3dWXl896ZppcBNPO9fIfR4YSLXVW8D/Gjkj1PP56FiUWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rm+eKUtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rm+eKUtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B3CC4CEF1;
	Tue, 26 Aug 2025 14:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217372;
	bh=6bfWs55TUWoaEWiE4gHkeUDN1oeMG9Z+7vWJNvpDxfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rm+eKUtJTwncj7CdFX+YVas8Roq4QpnRyxgWaob9WBcGyBikqKlkrSVnSdwRvDFMP
	 ijq/egN6y3MS/srJaBA4iAYuNRuMW6ZgqLxhcQgBFtXliH9sIJdUUyAlEIcaKzr4We
	 0mnctGmnbxGYQY/Ot1Pmn9mWMFRyls6XRAw9yg0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiumei Mu <xmu@redhat.com>,
	Shannon Nelson <sln@onemain.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/523] selftests: rtnetlink.sh: remove esp4_offload after test
Date: Tue, 26 Aug 2025 13:05:28 +0200
Message-ID: <20250826110927.429474455@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a3597b3e579f..0a6212a96415 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -746,6 +746,11 @@ kci_test_ipsec_offload()
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
@@ -835,6 +840,7 @@ EOF
 	fi
 
 	# clean up any leftovers
+	! "$esp4_offload_probed_default" && lsmod | grep -q esp4_offload && rmmod esp4_offload
 	echo 0 > /sys/bus/netdevsim/del_device
 	$probed && rmmod netdevsim
 
-- 
2.39.5



