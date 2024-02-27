Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F1613EFFB;
	Tue, 27 Feb 2024 13:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042152; cv=none; b=SwB0TcrFbDTeag85HrWbX+t5HSTZZF01F2fIeyjhWwUmWsprKYaGVzAtV0BVlidmmzWhllHO0dw+aoxkMo/+d3bLCQ/Dwm20Iew6E7gFxGvBgVmWowudaQDb78QvH8/Khloo7YgCl2POenbN7DWAOLdCeY+0Hgbg918xin/WzOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042152; c=relaxed/simple;
	bh=DDXtGJyGP5hbPMzeudjvmkZMrfJBRonuNJkRXyvAbzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIZQ1po9KauDgm0UtIcEdDttZRt/AR7AQnRQzFEsgG3Fa4AX6aS7tB9pCDquY9T9ZlpTwKZ5CNDZvbAd+PG5f7j0NnjyeyIzTd/70V2W1virV9eFA+jvGr6GmBoyC9a8yuNolFGeHCn+sH16jh/ejxVWrS4jEOdkLubqzfN3Lzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL9979TU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL9979TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CD2C433C7;
	Tue, 27 Feb 2024 13:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042152;
	bh=DDXtGJyGP5hbPMzeudjvmkZMrfJBRonuNJkRXyvAbzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WL9979TU3cHwgw42HAVMO16+1ruCySGWbExRgWtIQeGDSVViKzEusEB/rxyDpXdyt
	 fnB4HACV8UtKKY1X79J7O/1LPcHaROM3FXjlnSc/BQscK/KlrN2Q7iufXtJ/FQ9fFi
	 Hd9rxkhQ1HA9XmRJLCBoFsrtMp/wLuuVBcKeQuxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 198/299] selftests: mptcp: simult flows: fix some subtest names
Date: Tue, 27 Feb 2024 14:25:09 +0100
Message-ID: <20240227131632.187935596@linuxfoundation.org>
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

commit 4d8e0dde0403b5a86aa83e243f020711a9c3e31f upstream.

The selftest was correctly recording all the results, but the 'reverse
direction' part was missing in the name when needed.

It is important to have a unique (sub)test name in TAP, because some CI
environments drop tests with duplicated name.

Fixes: 675d99338e7a ("selftests: mptcp: simult flows: format subtests results in TAP")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -267,7 +267,8 @@ run_test()
 		[ $bail -eq 0 ] || exit $ret
 	fi
 
-	printf "%-60s" "$msg - reverse direction"
+	msg+=" - reverse direction"
+	printf "%-60s" "${msg}"
 	do_transfer $large $small $time
 	lret=$?
 	mptcp_lib_result_code "${lret}" "${msg}"


