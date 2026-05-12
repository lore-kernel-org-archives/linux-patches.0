Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70536375AB1;
	Tue, 12 May 2026 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609674; cv=none; b=i5svxR2HpLgJoSU107i5fXTEJDW+X/Tn7gcNOdHvPxbv3MVEkWDq1fG1NwO9BeCN+T6BQSRHzSGgjA2MaXMSqrGG9jIo74x/XTx4N7a0vs+GtCqGbj1QQqwo6xKiitgfiWA4sqwjRwzqzLMu7jrzPxF8JzepYt5S0U2q+PpaKwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609674; c=relaxed/simple;
	bh=nj5X58eI7LDAEiR1jocpfg5X8uLDj7HdBE4oqHXlXTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eN6786ylIf3q5yfOowjQD6O7nGRSHzJnxeIyx/+aIMhuBLQ6WzvIRFk0vlmqOpSJ+SA/TGjVScGvfcG3NkgMBpPVGPlzzfJpZBIOjEGIR+HBQc8rA133GAk3sLswTKLEjv82Idn2Lui6sVQCFKX2JdG4DELPVGAKVxRzKzJUxv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIUHqfpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIUHqfpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DBEC2BCB0;
	Tue, 12 May 2026 18:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609674;
	bh=nj5X58eI7LDAEiR1jocpfg5X8uLDj7HdBE4oqHXlXTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIUHqfpH7QKivRh23OEsRGK/MNZap7PUgJ2FbbGIWyMN1pnNmTliCUM5CQW+Dqc0T
	 6pRaiPj3rtS4tZPMnYNt+PPTcZbM0a1hxILRr6t71vCmIYnfYQBsf49mHPIQ2EkQTe
	 nIFw789rxD9rDPOFSvp2VZeUPruUnX2NrSBMn0/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 250/307] selftests: mptcp: pm: restrict unknown check to pm_nl_ctl
Date: Tue, 12 May 2026 19:40:45 +0200
Message-ID: <20260512173945.402817623@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 53705ddfa18408f8e1f064331b6387509fa19f7f upstream.

When pm_netlink.sh is executed with '-i', 'ip mptcp' is used instead of
'pm_nl_ctl'. IPRoute2 doesn't support the 'unknown' flag, which has only
been added to 'pm_nl_ctl' for this specific check: to ensure that the
kernel ignores such unsupported flag.

No reason to add this flag to 'ip mptcp'. Then, this check should be
skipped when 'ip mptcp' is used.

Fixes: 0cef6fcac24d ("selftests: mptcp: ip_mptcp option for more scripts")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-11-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -194,9 +194,13 @@ check "show_endpoints" \
 flush_endpoint
 check "show_endpoints" "" "flush addrs"
 
-add_endpoint 10.0.1.1 flags unknown
-check "show_endpoints" "$(format_endpoints "1,10.0.1.1")" "ignore unknown flags"
-flush_endpoint
+# "unknown" flag is only supported by pm_nl_ctl
+if ! mptcp_lib_is_ip_mptcp; then
+	add_endpoint 10.0.1.1 flags unknown
+	check "show_endpoints" "$(format_endpoints "1,10.0.1.1")" \
+	      "ignore unknown flags"
+	flush_endpoint
+fi
 
 set_limits 9 1 2>/dev/null
 check "get_limits" "${default_limits}" "rcv addrs above hard limit"


