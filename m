Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542C11FBC92;
	Mon, 27 Oct 2025 19:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592383; cv=none; b=LizcfOrYb049ZqYv88ivYgEjOXhVQVe+shfykhJ6XiDIkfs+rkJhOfv9m7y63q1owtlJhVRKlZh6+EONZ27CLY0wrAo1sa3LDnV03TkpR3XKkA7ADmdrlFDVO7xO7dMCrurtrhr/eLInU3WMGoMB2Zdm8584zMsR4TBgsQDKWeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592383; c=relaxed/simple;
	bh=TVR7rdg0bH/7p3vqjMp4WbmTDP7uivJbosz8rLWOlLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQ6mNtB5I9Mvrbiot1F64OpQZody8VIVb0mjgf9qpADcKibjk1Le6uEl8JQZZvp/Mj1XHFtCCEonkcHeA24ApNn5dRY6FtbvYtPyomMUPXvPlPJXq0jJ8zfGCnxU3nj6ZL7AhTwpBMr7h/QnG3NlJxOId/+Jb1okImgBJhmeLe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCz3pOeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCz3pOeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8789BC4CEF1;
	Mon, 27 Oct 2025 19:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592381;
	bh=TVR7rdg0bH/7p3vqjMp4WbmTDP7uivJbosz8rLWOlLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCz3pOeglHR74W7iAlAjhA8b6lRr9UWbr85stL6PyCiiKRTizWTr7jyAgqY3n0Axj
	 i+/jAHXDheweAB5JbgkJaWAKS8b3n5C6bGVJ/ocUp6+gsXx+yuH95QJWsHUS4nMgK3
	 IZVimoOrY8exMxKs1MNCgt03Vf2cO2c5ZtMKiCro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 099/157] selftests: mptcp: join: mark implicit tests as skipped if not supported
Date: Mon, 27 Oct 2025 19:36:00 +0100
Message-ID: <20251027183503.921177546@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3309,7 +3309,7 @@ endpoint_tests()
 	# subflow_rebuild_header is needed to support the implicit flag
 	# userspace pm type prevents add_addr
 	if reset "implicit EP" &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
@@ -3330,7 +3330,7 @@ endpoint_tests()
 	fi
 
 	if reset_with_tcp_filter "delete and re-add" ns2 10.0.3.2 REJECT OUTPUT &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		start_events
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_set_limits $ns2 0 3


