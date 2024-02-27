Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE9C1420DF;
	Tue, 27 Feb 2024 13:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042149; cv=none; b=ZRSDUYPaVoI03ZyYoOdcdi2oRXs42+X5IcrI5vgvZyo9HBARgMmYNHkG9GDLUhehEUA6x3+a5VVSoHJL0xNDmLvxdDHNurTzQC5gLjhC/epOBlXObsiHpILQdzkIu2VgpDn+radSjj72281zGjHcac8hIVDhucdQgBpJGHIXcQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042149; c=relaxed/simple;
	bh=OscK/aJR/Mg0SPNPAKauknVzoB+J00Zue/EwU+730jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLaKo9sZedjrZml+1qdBuVlqzLqZZe/9x3VmYYMx4jwZ9OVOuV3D6yzgnLnBd2gmsMr0CWd2YmBXRzD8kFa2hX2NNkIWb8otAjq2JPWXqNYKkg32t+m1r8sUL8s6O1p5Oyo/mulhWVeW0DgIRUK7DpkOHfDxTm8j7kbyvsC7O7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYULJg19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYULJg19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEECBC433F1;
	Tue, 27 Feb 2024 13:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042149;
	bh=OscK/aJR/Mg0SPNPAKauknVzoB+J00Zue/EwU+730jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYULJg19Qw8H/rgaDrtXrpaHoCEAKnHM6ir/aYOuLIhdYl0qU1kT4GT3r4FvU/YW4
	 03LO788+6Nzsz/JvzVLg9NtCTzme7mPifYT2jB07MmBLYEmhnX7ufhbW3mxQolXer0
	 oprrdN8WWXVFd9AzC6vw+uCOWRfuTIzlRSesY2Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 197/299] selftests: mptcp: userspace_pm: unique subtest names
Date: Tue, 27 Feb 2024 14:25:08 +0100
Message-ID: <20240227131632.152833129@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 2ef0d804c090658960c008446523863fd7e3541e upstream.

It is important to have a unique (sub)test name in TAP, because some CI
environments drop tests with duplicated names.

Some subtests from the userspace_pm selftest had the same names. That's
because different subflows are created (and deleted) between the same
pair of IP addresses.

Simply adding the destination port in the name is then enough to have
different names, because the destination port is always different.

Note that adding such info takes a bit more space, so we need to
increase a bit the width to print the name, simply to keep all the
'[ OK ]' aligned as before.

Fixes: f589234e1af0 ("selftests: mptcp: userspace_pm: format subtests results in TAP")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -75,7 +75,7 @@ print_test()
 {
 	test_name="${1}"
 
-	_printf "%-63s" "${test_name}"
+	_printf "%-68s" "${test_name}"
 }
 
 print_results()
@@ -555,7 +555,7 @@ verify_subflow_events()
 	local remid
 	local info
 
-	info="${e_saddr} (${e_from}) => ${e_daddr} (${e_to})"
+	info="${e_saddr} (${e_from}) => ${e_daddr}:${e_dport} (${e_to})"
 
 	if [ "$e_type" = "$SUB_ESTABLISHED" ]
 	then


