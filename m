Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C03134AC;
	Mon, 12 Aug 2024 16:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479774; cv=none; b=seYz1MpLbXQ9wMaj71pPOTTm1TjOqrgVwMCsv4faTk9iwRnoh3VKEpxx0GppadeavjvfE57f1QWd/oqBRYdSSfVyNv8BTivi9HaAKkmJZCkUNAd9ylyqMiOX6JO1gSbLnm/3W1GXBo5Bq9zRqlLJlpa/RlzCGBdsxpRBcJodfN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479774; c=relaxed/simple;
	bh=FLX+F2LQkaknXkaw54Ba22ZSJG35NcLPJoD02pCMm7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0cPDEcfgLtbtJpe0rPWGQ0hmfK0Mbc5bceGeez0ZKJFWMIhslncm4L/hOVO4ITEO51q12Eu9kwcMC1Lgw38TTZXzhTIrLoFu2rqLTwpPx8yvJvskeuDoBrL3XtLWQdTrIbjR4zkVexCn+SzfGwyj2RD7d54ICDA81cIK2u68oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLQqVnpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLQqVnpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1187AC32782;
	Mon, 12 Aug 2024 16:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479774;
	bh=FLX+F2LQkaknXkaw54Ba22ZSJG35NcLPJoD02pCMm7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLQqVnpGX+bEfspDTdKiShWkuVSUFXa6sdJNpwOpA3iGpAhohxwjeDTUyV+V70uV8
	 p0VdfgpiFjMTqw2BABaht51g0+D0hqjwPLC6l0wYbN5smpxRkElIP1XnCJ0Dn58UY/
	 BiIaakDktUIXag7G7PIsYXtDa/ahnnXQns612afM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 187/189] selftests: mptcp: join: test both signal & subflow
Date: Mon, 12 Aug 2024 18:04:03 +0200
Message-ID: <20240812160139.349790324@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 4d2868b5d191c74262f7407972d68d1bf3245d6a upstream.

It should be quite uncommon to set both the subflow and the signal
flags: the initiator of the connection is typically the one creating new
subflows, not the other peer, then no need to announce additional local
addresses, and use it to create subflows.

But some people might be confused about the flags, and set both "just to
be sure at least the right one is set". To verify the previous fix, and
avoid future regressions, this specific case is now validated: the
client announces a new address, and initiates a new subflow from the
same address.

While working on this, another bug has been noticed, where the client
reset the new subflow because an ADD_ADDR echo got received as the 3rd
ACK: this new test also explicitly checks that no RST have been sent by
the client and server.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240731-upstream-net-20240731-mptcp-endp-subflow-signal-v1-7-c8a9b036493b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2133,6 +2133,21 @@ signal_address_tests()
 		chk_add_nr 1 1
 	fi
 
+	# uncommon: subflow and signal flags on the same endpoint
+	# or because the user wrongly picked both, but still expects the client
+	# to create additional subflows
+	if reset "subflow and signal together"; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags signal,subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr 1 1 1
+		chk_add_nr 1 1 0 invert  # only initiated by ns2
+		chk_add_nr 0 0 0         # none initiated by ns1
+		chk_rst_nr 0 0 invert    # no RST sent by the client
+		chk_rst_nr 0 0           # no RST sent by the server
+	fi
+
 	# accept and use add_addr with additional subflows
 	if reset "multiple subflows and signal"; then
 		pm_nl_set_limits $ns1 0 3


