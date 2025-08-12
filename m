Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20C426FA77;
	Tue, 12 Aug 2025 19:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026017; cv=none; b=rdWKaQ1BEZm/KJfe4yMhDburLenjdx0rEANOwOppRDC3DdebG5vsWokef4tRCZj2OMA07iDIjtaHZOoY8FbPVjYk8LLgKNxAfSLNXaWrYgp1ZAMifmTtKUkk0B3Lq3uKVvPovGDGeeAdXw5XPiXuSqQUh911SXQwz6O4EkzTaYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026017; c=relaxed/simple;
	bh=xBLvcp1ocaIXwpQTrYbKUeBiDP/PU7xPexZ3jYXSpJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsp7Tn4k3H6YSKYy6YmiSGunUAqvqXEQ8VTpWd8PaUTU5SgOLPFUkXwT3cbQ62agoSaZtRib/Qrt3sXmlIJ7meSqr/G0PVfODEHHCcKihsp1I6H79tlTWMCs6XXN5v7jqe5WTfQH1DkGrH/RKV45furNVo6EDXFQBp4HYBR3blw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfq7zG1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfq7zG1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC84C4CEF0;
	Tue, 12 Aug 2025 19:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026017;
	bh=xBLvcp1ocaIXwpQTrYbKUeBiDP/PU7xPexZ3jYXSpJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfq7zG1WGjZJAJsYjHVOaPDCgY8FXBmqR7R8zawfiaSspvBhAUUnnYIFB/sAtn50Z
	 juq6YiGjnqu0cDfrdrGAv2jMNz0FoLxMZVvBgYyRc729bqkOSuJHP9iz3S5g46itzb
	 6BkHP5AVRzqCqjmJgh3ML0ufvxXUZWB9VCapfbLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiumei Mu <xmu@redhat.com>,
	Shannon Nelson <sln@onemain.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 212/480] selftests: rtnetlink.sh: remove esp4_offload after test
Date: Tue, 12 Aug 2025 19:47:00 +0200
Message-ID: <20250812174406.207990931@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2e8243a65b50..d2298da320a6 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -673,6 +673,11 @@ kci_test_ipsec_offload()
 	sysfsf=$sysfsd/ipsec
 	sysfsnet=/sys/bus/netdevsim/devices/netdevsim0/net/
 	probed=false
+	esp4_offload_probed_default=false
+
+	if lsmod | grep -q esp4_offload; then
+		esp4_offload_probed_default=true
+	fi
 
 	if ! mount | grep -q debugfs; then
 		mount -t debugfs none /sys/kernel/debug/ &> /dev/null
@@ -766,6 +771,7 @@ EOF
 	fi
 
 	# clean up any leftovers
+	! "$esp4_offload_probed_default" && lsmod | grep -q esp4_offload && rmmod esp4_offload
 	echo 0 > /sys/bus/netdevsim/del_device
 	$probed && rmmod netdevsim
 
-- 
2.39.5



