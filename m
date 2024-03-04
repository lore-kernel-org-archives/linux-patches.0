Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBCE8F58;
	Mon,  4 Mar 2024 21:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588505; cv=none; b=SkBbXC/5qmmt2vK+S4AFWlWSrT2kuDGCn6J1xsjdyFUp+7SodPD7o4ZfkJVnYYiN/nejSh3FThWvqxhC7XbZwK4s6MgaZnU/s4zIq4KcE3P1+HeoPBooQkeikg9k/iFA9Ush24yodA1Qvt1k6ioggo+Agpe1tciFb2Yb3YFjqAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588505; c=relaxed/simple;
	bh=R/DBVhNdyuth3uJ3+KsqlZtzMiH2Doojip/KLaYras4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aM1u8o9Vw19Qq0wIKFaoFh/yrAK7Nr5wJgBFFWjZpEw3cf2DoMdJre2miXil6j+Bmgm7JRNFXNzs0GogzqGVsT6k2AVVSCpsBPKPGLIcmYC3YO5AwxJs9q2YXdyVuX2sdsP7TTJcNdIuBm5n2gJLynRdsoqq2HTWBelqL4No/LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnxDVF8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnxDVF8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2663C433C7;
	Mon,  4 Mar 2024 21:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588505;
	bh=R/DBVhNdyuth3uJ3+KsqlZtzMiH2Doojip/KLaYras4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnxDVF8HTDzqZBRWSqZ4IxH1w+wSyEBr/PHkIm9r6C6S90evPYMyBIi6FkcioQW1+
	 6LDkokkgt4SAXuFPVahSQ21DpT28n7mQJA9m0QgVSApAaWMrfFw8YB4PbKCntccuZQ
	 cLdOlyErq9cRWomdeZl/ialdZpgoW0gs50MKt2Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 109/143] selftests: mptcp: join: add ss mptcp support check
Date: Mon,  4 Mar 2024 21:23:49 +0000
Message-ID: <20240304211553.405805581@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 9480f388a2ef54fba911d9325372abd69a328601 upstream.

Commands 'ss -M' are used in script mptcp_join.sh to display only MPTCP
sockets. So it must be checked if ss tool supports MPTCP in this script.

Fixes: e274f7154008 ("selftests: mptcp: add subflow limits test-cases")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-7-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -159,6 +159,11 @@ check_tools()
 		exit $ksft_skip
 	fi
 
+	if ! ss -h | grep -q MPTCP; then
+		echo "SKIP: ss tool does not support MPTCP"
+		exit $ksft_skip
+	fi
+
 	# Use the legacy version if available to support old kernel versions
 	if iptables-legacy -V &> /dev/null; then
 		iptables="iptables-legacy"


