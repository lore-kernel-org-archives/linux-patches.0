Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43538328634;
	Mon, 27 Oct 2025 19:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592932; cv=none; b=DZGS/kbu9gBb8DyuUbAj66/7Fli5V9vcekq914TbBmqnNIGyB8+bKZUjhBYn4Wtci5VJ5/cg2UdPT/RcuiUMcfoIJVd5O/Ew+8+wfH7cFkC3Ubcy6V40mnJ48lhMQXjQ+dyPQlEkMbJWGzHlNVrBNVtKeLmmaq5H/okrNYhTtcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592932; c=relaxed/simple;
	bh=nvCt6M2rsKUeQZSvc/4ud2Ud0LOqqThP6Adb4Hvo0xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVu6tbeJPEF9vDcDToLq3Sgfsfdj4rUTZJ4vqTVKQR6eVifexMKy1wdkLSSLkQr6PojlYe5F1+C8zoPJtPAILhBsfthCZIW2DjT39VEs1C90keC4hObuvryCoc9HPAEPVGpjyAKcffshjbT7VBE4OlFQ46bov3UGuRTe0ySh7b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3PUItHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3PUItHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0861C4CEF1;
	Mon, 27 Oct 2025 19:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592932;
	bh=nvCt6M2rsKUeQZSvc/4ud2Ud0LOqqThP6Adb4Hvo0xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3PUItHxaCOIGsFRpFAT4yQi3E55gFHcuA42uJWgbkmTqwpkeIPEAJZiyGeWZv1AJ
	 kNOdQv3b03pnAU2A+B4xqd0mNa2+f9PzUxgmFMvlhzd8Fmd6uQKCHYImpP6bbgq5Ae
	 1s8YmETmT8s6MNSAaOoaeHB80Lo4xXtPVHXqCEc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 066/117] selftests: mptcp: join: mark implicit tests as skipped if not supported
Date: Mon, 27 Oct 2025 19:36:32 +0100
Message-ID: <20251027183455.793554709@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 973f80d715bd2504b4db6e049f292e694145cd79 upstream.

The call to 'continue_if' was missing: it properly marks a subtest as
'skipped' if the attached condition is not valid.

Without that, the test is wrongly marked as passed on older kernels.

Fixes: 36c4127ae8dd ("selftests: mptcp: join: skip implicit tests if not supported")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251020-net-mptcp-c-flag-late-add-addr-v1-3-8207030cb0e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3722,7 +3722,7 @@ endpoint_tests()
 	# subflow_rebuild_header is needed to support the implicit flag
 	# userspace pm type prevents add_addr
 	if reset "implicit EP" &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
@@ -3747,7 +3747,7 @@ endpoint_tests()
 	fi
 
 	if reset_with_tcp_filter "delete and re-add" ns2 10.0.3.2 REJECT OUTPUT &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		start_events
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_set_limits $ns2 0 3


