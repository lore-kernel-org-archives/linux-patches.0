Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927A732ABF1;
	Mon, 27 Oct 2025 19:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592658; cv=none; b=d1did2pI++sntdl9Q+o7IgXfGv9QaSgsbNpGQmuOp/NJtJkUn11oOTn5uwG+fMYVsg1Dv3GmUPccusQCu55g/l+oRS5uKhcUxwMofL7P05WiYl9OaNyLutPdDj+8jEyvIyxwHO5NdNDH/1do5aV4QFWmCuMoHHl0N0E1pujjkc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592658; c=relaxed/simple;
	bh=d/ua5Cnnzm1BEF5bKiMZRxzZHrF28fElMhEjZF4+uQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fajdfxFwGIBau3n/QKagCYnKsnAs89melY9o/IiV5H6V0zmP6bmmZ0qMAZ1qvF7+nqRnkkZZXPPCaglh0K6y4OzhI4AvGeQo5Jztx1Fe+njL410NJrkbFlqoJJzvhBiMQY040JwsvRIUIPnqCamsGferE3lNNreRfihA/Bt6bc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJ6hBwcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJ6hBwcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269E2C113D0;
	Mon, 27 Oct 2025 19:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592658;
	bh=d/ua5Cnnzm1BEF5bKiMZRxzZHrF28fElMhEjZF4+uQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJ6hBwcwyDUSTalHmjKx5FBAH5cFBc1lFjCdal6gZlKJ/ngg6/Bsb1gqeE0c3ZwBy
	 /JRYL+hKe8WrzxS6Fe5Azqws+E2bwqNJTqLHrjvu4vv8ygu91Q8otBfSOQa7zOjB8q
	 J8FLKZJ6jEIWqxR/Z4j0tsDf8aDddRfM8du8+z1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 47/84] selftests: mptcp: join: mark flush re-add as skipped if not supported
Date: Mon, 27 Oct 2025 19:36:36 +0100
Message-ID: <20251027183440.071925000@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit d68460bc31f9c8c6fc81fbb56ec952bec18409f1 upstream.

The call to 'continue_if' was missing: it properly marks a subtest as
'skipped' if the attached condition is not valid.

Without that, the test is wrongly marked as passed on older kernels.

Fixes: e06959e9eebd ("selftests: mptcp: join: test for flush/re-add endpoints")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251020-net-mptcp-c-flag-late-add-addr-v1-2-8207030cb0e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3910,7 +3910,7 @@ endpoint_tests()
 
 	# flush and re-add
 	if reset_with_tcp_filter "flush re-add" ns2 10.0.3.2 REJECT OUTPUT &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 1 2
 		# broadcast IP: no packet for this address will be received on ns1


